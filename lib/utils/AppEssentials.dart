import 'dart:io';
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path/path.dart';
import 'package:logger/logger.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart' as crypto;
import 'package:magik_antivirus/model/File.dart';
import 'package:magik_antivirus/model/User.dart';
import 'package:magik_antivirus/model/Device.dart';
import 'package:magik_antivirus/model/Signature.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:magik_antivirus/DataAccess/FileDAO.dart';
import 'package:magik_antivirus/DataAccess/UserDAO.dart';
import 'package:magik_antivirus/DataAccess/DeviceDAO.dart';
import 'package:magik_antivirus/utils/StyleEssentials.dart';
import 'package:magik_antivirus/DataAccess/SignatureDAO.dart';
import 'package:shared_preferences/shared_preferences.dart';

///Métodos atributos 'esenciales' para el correcto funcionamiento de la aplicación
///
///Todos los objetos y funciones de la clase están configurados de forma estática para poder acceder desde cualquier lado
///
///El motivo por el que están aquí es o para ayudar al Provider antes de cargarlo y durante su uso.
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
  static ThemeData theme = ((prefs.getString("themeMode") ?? "Dark") == "Dark")
      ? StyleEssentials.darkMode
      : StyleEssentials.lightMode;

  ///Lista de idiomas que se pueden usar
  static List<Locale> listLocales = [
    Locale('es'),
    Locale('en'),
    Locale('de'),
    Locale('fr')
  ];

  ///Dispositivo actual
  static Device? dev;

  ///Función de obtención de preferencias
  ///
  ///Obtiene las preferencias del usuario de la base de datos
  static Future<void> getProperties() async {
    prefs = await SharedPreferences.getInstance();
    if (prefs.getKeys().length == 0) {
      newPreferences();
    }
    if (prefs.getBool("isUserRegistered") != null &&
        prefs.getBool("isUserRegistered")!) {
      user = await UserDAO().get(prefs.getString("userName")!);
    }
  }

  static void newPreferences() {
    prefs.setBool("isUserRegistered", false);
    prefs.setString("userName", "");
    prefs.setString("userPass", "");
    prefs.setString("chosenLang", "es");
    prefs.setString("themeMode", "light");
  }

  ///Función de cambio de lenguaje
  ///
  ///Cambia el lenguaje de estas preferencias y actualiza la BD con ello
  static void changeLang(String lang) async {
    prefs.setString("chosenLang", lang);
  }

  ///Función de registro y guardado de dispositivos
  ///
  ///La función recoge el identificador del dispositivo en función de su SO y lo utiliza para buscar en la BD una ocurrencia existente
  ///
  ///- Si existe, guarda en el dispositivo estático la ocurrencia
  ///
  ///- Si no existe, la crea con todos los datos necesarios
  static void registerThisDevice() async {
    DeviceInfoPlugin plugin = DeviceInfoPlugin();
    String dname = switch (Platform.operatingSystem) {
      "android" => (await plugin.androidInfo).model,
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
    Device? devDB = await DeviceDAO().get(thisdev.id!);
    if (devDB != null) {
      dev = devDB;
    } else {
      DeviceDAO().insert(thisdev);
      dev = thisdev;
    }
  }

  ///Función de escaneo de directorios:
  ///
  ///Mira si el File que está mirando es un directorio y si su acceso está o no prohibido
  ///
  ///Si es un archivo, imprime su path (esto es solo de prueba de momento)
  ///
  ///Si es un directorio y tiene acceso a él, llama otra vez a su función, esta vez desde este nuevo directorio
  static Future<void> scanDir(Directory d, Set<String> forbiddenPaths) async {
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
  static void changeTheme(bool isDark) async {
    prefs.setString("themeMode", isDark ? "Dark" : "Light");
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

    await Fluttertoast.showToast(
        msg: quarantinedFile(basename(f.path))[chosenLocale]!);
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
}
