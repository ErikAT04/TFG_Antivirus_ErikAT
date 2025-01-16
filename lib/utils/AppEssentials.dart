import 'dart:convert';
import 'dart:io';
import 'package:magik_antivirus/DataAccess/FileDAO.dart';
import 'package:path/path.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:magik_antivirus/DataAccess/SignatureDAO.dart';
import 'package:magik_antivirus/model/File.dart';
import 'package:magik_antivirus/model/Signature.dart';
import 'package:magik_antivirus/model/User.dart';
import 'package:magik_antivirus/model/Prefs.dart';
import 'package:magik_antivirus/model/Device.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:magik_antivirus/DataAccess/UserDAO.dart';
import 'package:magik_antivirus/DataAccess/PrefsDAO.dart';
import 'package:magik_antivirus/DataAccess/DeviceDAO.dart';
import 'package:crypto/crypto.dart' as crypto;
import 'package:magik_antivirus/utils/StyleEssentials.dart';

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
  static late Preferences preferences;

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
  static String chosenLocale = preferences.lang;

  ///Tema elegido
  static ThemeData theme = (preferences.isAutoTheme)
      ? StyleEssentials.darkMode
      : (preferences.themeMode == "Dark")
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
    preferences = (await PrefsDAO().get(""))!;
    if (preferences.isUserRegistered) {
      user = await UserDAO().get(preferences.uname);
      print('pasa por aqui');
    }
  }

  ///Función de cambio de lenguaje
  ///
  ///Cambia el lenguaje de estas preferencias y actualiza la BD con ello
  static void changeLang(String lang) async {
    preferences.lang = lang;
    await PrefsDAO().update(preferences);
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
        name: dname,
        type: Platform.operatingSystem,
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
        var bytes = await f.readAsBytes();
        String s = md5.convert(bytes).toString();
        if (sigs.map((sig) => sig.signature).toList().contains(s)) {
          Signature? signature = null;
          for (var sig in sigs) {
            if (sig.signature == s) {
              signature = sig;
            }
          }
          putInQuarantine(
            f, signature!
          );
        }
        print("${f.path} : $s");
      } else if (f is Directory && !forbiddenPaths.contains(f.path)) {
        try {
          await scanDir((Directory(f.path)), forbiddenPaths);
        } catch (e) {
          print("Error de directorio");
        }
      }
    }
  }

  ///Función de cambio de tema:
  ///
  ///Cambia el tema de las preferencias y actualiza estas en la BD
  static void changeTheme(bool isDark) async {
    preferences.themeMode = isDark ? "darkMode" : "lightMode";
    await PrefsDAO().update(preferences);
  }

  ///Función de adición de usuarios a la BD
  ///
  ///Introduce el email y la contraseña en las preferencias, actualizando la BD con ello
  static void putUser(User user) async {
    preferences.isUserRegistered = true;
    preferences.uname = user.email;
    preferences.upass = user.pass;
    await PrefsDAO().update(preferences);
  }

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

  static void putInQuarantine(File f, Signature sig) async {
    String pathSHA =
        crypto.sha256.convert(utf8.encode(basename(f.path))).toString();
    File file = await File(join(quarantineDirectory.path, pathSHA));
    var fileInside = await f.readAsBytes();
    file = await file.writeAsString(fileInside.toString());
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

  static void getOutOfQuarantine(SysFile s) async {
    File file = File(s.route);
    File quarantined = File(s.newRoute);

    var bytes = await quarantined.readAsString();

    file = await file.writeAsBytes(utf8.encode(bytes));
    await file.create();

    await quarantined.delete();

    await FileDAO().delete(s);
  }
}
