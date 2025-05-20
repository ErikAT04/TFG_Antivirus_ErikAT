// ignore_for_file: deprecated_member_use

import 'dart:io';
import 'dart:convert';
import 'package:flutter_device_name/flutter_device_name.dart';
import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart' as crypto;
import 'package:magik_antivirus/model/data_classes/file.dart';
import 'package:magik_antivirus/model/data_classes/user.dart';
import 'package:magik_antivirus/model/data_classes/device.dart';
import 'package:magik_antivirus/model/data_classes/hash.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:magik_antivirus/model/data_access/file_dao.dart';
import 'package:magik_antivirus/model/data_access/device_dao.dart';
import 'package:magik_antivirus/model/data_access/hash_dao.dart';
import 'package:shared_preferences/shared_preferences.dart';

///Métodos atributos 'esenciales' para el correcto funcionamiento de la aplicación
///
///Todos los objetos y funciones de la clase están configurados de forma estática para poder acceder desde cualquier lado
///
///El motivo por el que están aquí es o para ayudar a los Provider antes de cargarlo y durante su uso.
class AppEssentials {
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
  static late List<Hash> hashes;

  ///Lenguaje elegido
  static String chosenLocale = prefs.getString("chosenLang") ?? "es";

  ///Tema elegido
  static bool isLightMode =
      ((prefs.getString("themeMode") ?? "Dark") != "Dark");

  ///Dispositivo actual
  static Device? dev;

  ///Color principal actual
  static late Color color;

  ///Función de obtención de preferencias
  ///
  ///Obtiene las preferencias del usuario de la base de datos
  static Future<void> getPreferences() async {
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
      "android" =>
        (await DeviceName().getName()) ?? (await plugin.androidInfo).model,
      "ios" => (await plugin.iosInfo).name,
      "macos" => (await plugin.macOsInfo).computerName,
      "linux" => Platform.localHostname,
      "windows" => (await plugin.windowsInfo).userName,
      String() => Platform.localHostname
    };
    Device thisdev = Device(
        devName: dname,
        devType: Platform.operatingSystem,
        joinIn: DateTime.now(),
        lastScan: DateTime.now());
    thisdev.id = switch (Platform.operatingSystem) {
      "android" => (await plugin.androidInfo).id,
      "ios" => (await plugin.iosInfo).identifierForVendor,
      "macos" => (await plugin.macOsInfo).systemGUID,
      "linux" => (await plugin.linuxInfo).machineId,
      "windows" => (await plugin.windowsInfo).deviceId,
      String() => throw UnimplementedError()
    };
    thisdev.id = crypto.sha256.convert(utf8.encode(thisdev.id!)).toString();
    Device? devDB = await DeviceDAO().get(thisdev.id!);
    if (devDB != null) {
      dev = devDB;
      dev!.devName = dname;
      DeviceDAO().update(dev!);
    } else {
      DeviceDAO().insert(thisdev);
      dev = thisdev;
    }
  }

  ///Función de cambio de tema:
  ///
  ///Cambia el tema de las preferencias y actualiza estas en la BD
  static void changeTheme(bool isLight) async {
    prefs.setString("themeMode", isLight ? "Light" : "Dark");
  }

  ///Función de carga de firmas en la app
  static Future<void> loadHashes() async {
    hashes = await HashDAO().getHashes();
  }

  ///Función de obtención de la lista de dispositivos del usuario
  static Future<List<Device>> getDevicesList(User user) async {
    List<Device> devList = [];
    List<Device> auxList = await DeviceDAO().list();
    for (Device device in auxList) {
      if (device.user == user.email) {
        devList.add(device);
      }
    }
    return devList;
  }

  ///Función de restauración del archivo en cuarentena
  static Future<void> getOutOfQuarantine(QuarantinedFile s) async {
    File file = File(s.route); //"Archivo" en su ruta original
    //Si, por algun casual, el archivo ya existe, se le agrega un número al final hasta que no exista
    int i = 1;
    if (file.existsSync()) {
      file = File("${s.route}_$i");
      i++;
    }
    File quarantined = File(s.newRoute); //Archivo en cuarentena

    var bytes = await quarantined.readAsString();

    //Se decodifica el archvo en cuarentena y se escriben sus bytes en la ruta original
    file = await file.writeAsBytes(base64Decode(bytes));

    await file.create();

    await quarantined.delete();

    await FileDAO().delete(s);
  }

  ///Función encargada de borrar un archivo del sistema
  static Future<void> eraseFile(QuarantinedFile s) async {
    File file = File(s.newRoute);

    await file.delete();

    await FileDAO().delete(s);
  }
}
