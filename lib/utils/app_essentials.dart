import 'dart:io';
import 'dart:convert';
import 'package:path/path.dart';
import 'package:logger/logger.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart' as crypto;
import 'package:magik_antivirus/model/file.dart';
import 'package:magik_antivirus/model/user.dart';
import 'package:magik_antivirus/model/device.dart';
import 'package:magik_antivirus/model/signature.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:magik_antivirus/data_access/file_dao.dart';
import 'package:magik_antivirus/data_access/device_dao.dart';
import 'package:magik_antivirus/data_access/signature_dao.dart';
import 'package:shared_preferences/shared_preferences.dart';

///Métodos atributos 'esenciales' para el correcto funcionamiento de la aplicación
///
///Todos los objetos y funciones de la clase están configurados de forma estática para poder acceder desde cualquier lado
///
///El motivo por el que están aquí es o para ayudar a los Provider antes de cargarlo y durante su uso.
class AppEssentials {
  ///Usuario estático
  ///
  ///Este usuario se guardará para, cuando se inicialice el programa, pasar su información al provider
  static User? user;

  ///Preferencias de la aplicación
  ///
  ///Guardará y gestionará las preferencias de la aplicación, haciendo las operaciones CRUD de las bases de datos
  static late SharedPreferences prefs;

  ///Expresión regular de corrección del email:
  ///
  ///El correo electrónico puede tener
  static RegExp emailRegExp = RegExp(r'^[a-zA-Z0-9]+@[a-z]+\.[a-z]{3}$');

  ///Directorio en cuarentena
  ///
  ///Guardará el directorio donde se guardan todos los archivos del dispositivo
  static late Directory quarantineDirectory;

  ///Lista de Firmas
  ///
  ///Al estar siendo cargado de una API que, de primeras, no cambia de forma constante, es innecesario meter esta información en el Provider
  static late List<Signature> sigs;

  ///Lenguaje elegido
  static String chosenLocale = prefs.getString("chosenLang") ?? "es";

  ///Tema elegido
  static bool isLightMode =
      ((prefs.getString("themeMode") ?? "Dark") != "Dark");

  ///Lista de idiomas que se pueden usar
  static List<Locale> listLocales = [
    Locale('es'),
    Locale('en'),
    Locale('de'),
    Locale('fr')
  ];

  ///Dispositivo actual
  static Device? dev;

  ///Color principal actual
  static late Color color;

  ///Función de obtención de preferencias
  ///
  ///Obtiene las preferencias del usuario de la base de datos
  static Future<void> getProperties() async {
    prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey("colorR")) {
      await newPreferences();
    }
    int r = prefs.getInt("colorR") ?? 14;
    int g = prefs.getInt("colorG") ?? 54;
    int b = prefs.getInt("colorB") ?? 111;
    color = Color.fromARGB(255, r, g, b);
  }

  static Future<void> newPreferences() async {
    await prefs.setBool("isUserRegistered", false);
    await prefs.setString("userName", "");
    await prefs.setString("userPass", "");
    await prefs.setString("chosenLang", "es");
    await prefs.setString("themeMode", "light");
    await prefs.setInt("colorR", 14);
    await prefs.setInt("colorG", 54);
    await prefs.setInt("colorB", 111);
  }

  ///Función de cambio de lenguaje
  ///
  ///Cambia el lenguaje de estas preferencias y actualiza la BD con ello
  static void changeLang(String lang) async {
    await prefs.setString("chosenLang", lang);
  }

  static void saveColorPreferences(Color color) async {
    await AppEssentials.prefs.setInt("colorR", color.red);
    await AppEssentials.prefs.setInt("colorG", color.green);
    await AppEssentials.prefs.setInt("colorB", color.blue);
  }

  ///Función de registro y guardado de dispositivos
  ///
  ///La función recoge el identificador del dispositivo en función de su SO y lo utiliza para buscar en la BD una ocurrencia existente
  ///
  ///- Si existe, guarda en el dispositivo estático la ocurrencia
  ///
  ///- Si no existe, la crea con todos los datos necesarios
  static Future<void> registerThisDevice() async {
    DeviceInfoPlugin plugin = DeviceInfoPlugin();
    String dname = switch (Platform.operatingSystem) {
      "android" => (await plugin.androidInfo).host,
      "ios" => (await plugin.iosInfo).name,
      "macos" => (await plugin.macOsInfo).computerName,
      "linux" => (await plugin.linuxInfo).name,
      "windows" => (await plugin.windowsInfo).userName,
      // TODO: Handle this case.
      String() => throw UnimplementedError()
    };
    Device thisdev = Device(
        dev_name: dname,
        dev_type: Platform.operatingSystem,
        join_in: DateTime.now(),
        last_scan: DateTime.now());
    thisdev.id = switch (Platform.operatingSystem) {
      "android" => (await plugin.androidInfo).id,
      "ios" => (await plugin.iosInfo).identifierForVendor,
      "macos" => (await plugin.macOsInfo).systemGUID,
      "linux" => (await plugin.linuxInfo).machineId,
      "windows" => (await plugin.windowsInfo).deviceId,
      // TODO: Handle this case.
      String() => throw UnimplementedError()
    };
    //thisdev.id = crypto.sha256.convert(utf8.encode(thisdev.id!)).toString();
    Device? devDB = await DeviceDAO().get(thisdev.id!);
    if (devDB != null) {
      dev = devDB;
    } else {
      DeviceDAO().insert(thisdev);
      dev = thisdev;
    }
  }

  ///Directorio Principal del dispositivo
  ///
  ///Dependiendo del dispositivo, el directorio raíz puede ser uno u otro:
  ///- Android: /storage/emulated/0
  ///- Linux y MacOS: /
  ///- Windows: C:\\
  static String mainDirectory = (Platform.isAndroid)
      ? "/storage/emulated/0"
      : (Platform.isWindows)
          ? "C:\\"
          : "/";

  ///Función de escaneo de directorios:
  ///
  ///Mira si el File que está mirando es un directorio y si su acceso está o no prohibido
  ///
  ///Si es un archivo, imprime su path (esto es solo de prueba de momento)
  ///
  ///Si es un directorio y tiene acceso a él, llama otra vez a su función, esta vez desde este nuevo directorio
  static Future<void> scanDir(Directory d, List<String> forbiddenPaths) async {
    await for (var f in d.list(recursive: false)) {
      if (f is File) {
        try {
          var bytes = await f.readAsBytes();
          String s = md5.convert(bytes).toString();
          if (sigs.map((sig) => sig.signature).toList().contains(s)) {
            Signature? signature = null;
            for (var sig in sigs) {
              if (sig.signature == s) {
                signature = sig;
              }
            }
            putInQuarantine(f, signature!);
          }
          Logger().d("${f.path} : $s");
        } catch (e) {
          Logger().e("Error de Fichero en Uso: $e");
        }
      } else if (f is Directory && !forbiddenPaths.contains(f.path)) {
        try {
          await scanDir((Directory(f.path)), forbiddenPaths);
        } catch (e) {
          Logger().e("Error de directorio: $e");
        }
      }
    }
  }

  ///Función de cambio de tema:
  ///
  ///Cambia el tema de las preferencias y actualiza estas en la BD
  static void changeTheme(bool isLight) async {
    prefs.setString("themeMode", isLight ? "Light" : "Dark");
  }

  ///Función de adición de usuarios a la BD
  ///
  ///Introduce el email y la contraseña en las preferencias, actualizando la BD con ello
  static void putUser(User user) async {
    prefs.setBool("isUserRegistered", true);
    prefs.setString("userName", user.email);
    prefs.setString("userPass", user.passwd);
  }

  ///Función de carga de firmas en la app
  static Future<void> loadSigs() async {
    sigs = await SignatureDAO().getSigs();
  }

  ///Función de obtención de la lista de dispositivos del usuario
  static Future<List<Device>> getDevicesList() async {
    List<Device> devList = [];
    List<Device> auxList = await DeviceDAO().list();
    for (Device device in auxList) {
      if (device.user == user!.email) {
        devList.add(device);
      }
    }
    return devList;
  }

  ///Función de puesta en cuarentena
  static void putInQuarantine(File f, Signature sig) async {
    String pathSHA = crypto.sha256
        .convert(utf8.encode("${basename(f.path)} ${DateTime.now()}"))
        .toString();
    File file = await File(join(quarantineDirectory.path, pathSHA));
    var fileInside = await f.readAsBytes();
    file = await file.writeAsString(base64Encode(fileInside));
    await file.create();

    SysFile sysFile = SysFile(
        name: basename(f.path),
        route: f.path,
        newName: pathSHA,
        newRoute: file.path,
        malwareType: sig.type,
        quarantineDate: DateTime.now());

    await FileDAO().insert(sysFile);

    await f.delete();
  }

  ///Mapa que guarda la frase que mandará la notificación, dependiendo del idioma
  static Map<String, String> quarantinedFile(String filename) => {
        "es": "El archivo '$filename' ha sido puesto en cuarentena",
        "en": "File '$filename' has been quarantined",
        "de": "Die Datei „$filename“ wurde unter Quarantäne gestellt",
        "fr": "Le fichier '$filename' a été mis en quarantaine"
      };

  ///Mapa que guarda el título de la notificación dependiendo del idioma
  static Map<String, String> quarantine = {
    "es": "Archivo en cuarentena",
    "en": "File quarantined",
    "de": "Datei under Quarantäne",
    "fr": "Ficher en quarantaine"
  };

  ///Función de restauración del archivo en cuarentena
  static Future<void> getOutOfQuarantine(SysFile s) async {
    File file = File(s.route);
    File quarantined = File(s.newRoute);

    var bytes = await quarantined.readAsString();

    file = await file.writeAsBytes(base64Decode(bytes));
    await file.create();

    await quarantined.delete();

    await FileDAO().delete(s);
  }

  ///Función encargada de borrar un archivo del sistema
  static Future<void> eraseFile(SysFile s) async {
    File file = File(s.newRoute);

    await file.delete();

    await FileDAO().delete(s);
  }
}
