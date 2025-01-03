import 'dart:io';

import 'package:flutter/services.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:magik_antivirus/DataAccess/DeviceDAO.dart';
import 'package:magik_antivirus/DataAccess/PrefsDAO.dart';
import 'package:magik_antivirus/DataAccess/UserDAO.dart';
import 'package:magik_antivirus/model/Device.dart';
import 'package:magik_antivirus/model/Prefs.dart';
import 'package:flutter/material.dart';
import 'package:magik_antivirus/model/User.dart';
import 'package:path_provider/path_provider.dart';

///App Essentials: El conjunto de objetos y métodos que la aplicación necesita acceder de forma estática desde todos lados
class AppEssentials {
  static User? user;

  static late Preferences preferences;

  static Future<void> getProperties() async {
    preferences = (await PrefsDAO().get(""))!;
    if(preferences.isUserRegistered){
      user = await UserDAO().get(preferences.uname);
      print('pasa por aqui');
    }
  }

  static void changeLang(String lang) async {
    preferences.lang = lang;
    await PrefsDAO().update(preferences);
  }

  static Map<String, Color> colorsMap = {
    "appMainLightBlue": Color.fromARGB(255, 40, 184, 221),
    "appMainBlue": Color.fromARGB(255, 14, 54, 111),
    "appDarkBlue": Color.fromARGB(255, 10, 32, 64),
    "white": Colors.white,
    "black": Colors.black,
    "transpBlack": Color.fromARGB(25, 0, 0, 0)
  };

  static ThemeData darkMode = ThemeData(
    fontFamily: "Roboto",
    colorSchemeSeed: colorsMap["appMainBlue"],
    canvasColor: colorsMap["appDarkBlue"],
    cardColor: colorsMap["appDarkBlue"],
    dialogBackgroundColor: colorsMap["appDarkBlue"],
    dividerColor: colorsMap["appMainLightBlue"],
    focusColor: colorsMap["appMainLightBlue"],
    highlightColor: colorsMap["appMainBlue"],
    hoverColor: colorsMap["appMainBlue"],
    //primaryColor: colorsMap["appMainBlue"],
    primaryColorDark: colorsMap["appDarkBlue"],
    primaryColorLight: colorsMap["appMainLightBlue"],
    scaffoldBackgroundColor: colorsMap["appMainBlue"],
    secondaryHeaderColor: colorsMap["appMainBlue"],
    cardTheme: CardThemeData(
      color: colorsMap["appDarkBlue"],
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith<Color?>( //Fondo
                  (Set<WidgetState> states) {
                    if (states.contains(WidgetState.hovered) || states.contains(WidgetState.pressed)) {
                      return colorsMap["appMainLightBlue"]; 
                    }
                    return colorsMap["appDarkBlue"]; 
                  },
                ),
        foregroundColor: WidgetStateProperty.resolveWith<Color?>( //Texto
          (Set<WidgetState> states) {
            if (states.contains(WidgetState.hovered) || states.contains(WidgetState.pressed)) {
              return colorsMap["white"];
            }
            return colorsMap["appMainLightBlue"];
          },
        ),
        side: WidgetStateProperty.resolveWith<BorderSide?>( //Fondo
          (Set<WidgetState> states) {
            if (states.contains(WidgetState.hovered) || states.contains(WidgetState.pressed)) {
              return BorderSide(color: colorsMap["white"]!);
            }
            return BorderSide(color: colorsMap["appMainLightBlue"]!);
          },
        ),
      )
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: colorsMap["appDarkBlue"],
      selectedItemColor: colorsMap["appMainLightBlue"],
      unselectedItemColor: colorsMap["appMainLightBlue"],
      selectedLabelStyle: TextStyle(color: colorsMap["appMainLightBlue"]),
      unselectedLabelStyle: TextStyle(color: colorsMap["appMainLightBlue"]),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: colorsMap["appDarkBlue"],
      titleTextStyle: TextStyle(color: colorsMap["white"], fontSize: 20)
    ),
    textTheme: Typography.whiteCupertino,
    inputDecorationTheme: InputDecorationTheme(
      labelStyle: TextStyle(
        color: colorsMap["appMainLightBlue"],
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: colorsMap["appMainLightBlue"]! )
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red)
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: colorsMap["appMainLightBlue"]!),
      ),
    ),
    iconTheme: IconThemeData(
      color: colorsMap["appMainLightBlue"]
    ),
    drawerTheme: DrawerThemeData(
      backgroundColor: colorsMap["appDarkBlue"],
      surfaceTintColor: colorsMap["appMainLightBlue"],
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: colorsMap["appDarkBlue"],
    )
  );


  static ThemeData lightMode = ThemeData(
    fontFamily: "Roboto",
    colorSchemeSeed: colorsMap["white"],
    canvasColor: colorsMap["appMainBlue"],
    cardColor: colorsMap["appMainBlue"],
    dialogBackgroundColor: colorsMap["appMainBlue"],
    dividerColor: colorsMap["appMainLightBlue"],
    focusColor: colorsMap["appMainLightBlue"],
    highlightColor: colorsMap["appMainLightBlue"],
    hoverColor: colorsMap["appMainLightBlue"],
    //primaryColor: colorsMap["appMainBlue"],
    primaryColorDark: colorsMap["appDarkBlue"],
    primaryColorLight: colorsMap["appMainLightBlue"],
    scaffoldBackgroundColor: colorsMap["white"],
    secondaryHeaderColor: colorsMap["appMainBlue"],
    cardTheme: CardThemeData(
      color: colorsMap["white"],
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith<Color?>( //Fondo
                  (Set<WidgetState> states) {
                    if (states.contains(WidgetState.hovered) || states.contains(WidgetState.pressed)) {
                      return colorsMap["appDarkBlue"];
                    }
                    return colorsMap["white"];
                  },
                ),
        foregroundColor: WidgetStateProperty.resolveWith<Color?>( //Texto
          (Set<WidgetState> states) {
            if (states.contains(WidgetState.hovered) || states.contains(WidgetState.pressed)) {
              return colorsMap["white"]; 
            }
            return colorsMap["black"];
          },
        ),
        side: WidgetStateProperty.resolveWith<BorderSide?>( //Borde
          (Set<WidgetState> states) {
            if (states.contains(WidgetState.hovered) || states.contains(WidgetState.pressed)) {
              return BorderSide(color: colorsMap["appDarkBlue"]!); 
            }
            return BorderSide(color: colorsMap["appMainBlue"]!);
          },
        ),
      )
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: colorsMap["white"],
      selectedItemColor: colorsMap["appDarkBlue"],
      unselectedItemColor: colorsMap["appDarkBlue"],
      selectedLabelStyle: TextStyle(color: colorsMap["appDarkBlue"]),
      unselectedLabelStyle: TextStyle(color: colorsMap["appDarkBlue"]),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: colorsMap["white"],
      titleTextStyle: TextStyle(color: colorsMap["appMainBlue"], fontSize: 20)
    ),
    textTheme: Typography.blackCupertino,
    inputDecorationTheme: InputDecorationTheme(
      labelStyle: TextStyle(
        color: colorsMap["appMainBlue"],
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: colorsMap["appMainBlue"]! )
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red)
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: colorsMap["appMainBlue"]!),
      ),
    ),
    iconTheme: IconThemeData(
      color: colorsMap["appMainBlue"]
    ),
    drawerTheme: DrawerThemeData(
      backgroundColor: colorsMap["white"],
      surfaceTintColor: colorsMap["black"]
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: colorsMap["white"],
    )
  );

  static List<Locale> listLocales = [
    Locale('es'),
    Locale('en'),
    Locale('de'),
    Locale('fr')
  ];

  static Device? dev;

  static void registerThisDevice() async{
    DeviceInfoPlugin plugin = DeviceInfoPlugin();
    String dname = switch(Platform.operatingSystem){
      "android"=> (await plugin.androidInfo).model,
      "ios"=> (await plugin.iosInfo).name,
      "macos"=> (await plugin.macOsInfo).computerName,
      "linux" => (await plugin.linuxInfo).name,
      "windows" => (await plugin.windowsInfo).userName,
      // TODO: Handle this case.
      String() => throw UnimplementedError()
    };
    Device thisdev = Device(name: dname, type: Platform.operatingSystem, join_in: DateTime.now(), last_scan: DateTime.now());
    thisdev.id = switch(Platform.operatingSystem){
      "android"=> (await plugin.androidInfo).id,
      "ios"=> (await plugin.iosInfo).identifierForVendor,
      "macos"=> (await plugin.macOsInfo).systemGUID,
      "linux" => (await plugin.linuxInfo).machineId,
      "windows" => (await plugin.windowsInfo).deviceId,
      // TODO: Handle this case.
      String() => throw UnimplementedError()
    };
    Device? devDB = await DeviceDAO().get(thisdev.id!);
    if(devDB!=null){
      dev = devDB;
    } else {
      DeviceDAO().insert(thisdev);
      dev = thisdev;
    }
  }
  static String chosenLocale = preferences.lang;

  static ThemeData theme = (preferences.isAutoTheme)?darkMode:(preferences.themeMode=="Dark")?darkMode:lightMode;

  /*
  Color? colorSchemeSeed,
  Color? canvasColor,
  Color? cardColor,
  Color? dialogBackgroundColor,
  Color? disabledColor,
  Color? dividerColor,
  Color? focusColor,
  Color? highlightColor,
  Color? hintColor,
  Color? hoverColor,
  Color? indicatorColor,
  Color? primaryColor,
  Color? primaryColorDark,
  Color? primaryColorLight,
  MaterialColor? primarySwatch,
  Color? scaffoldBackgroundColor,
  Color? secondaryHeaderColor,
  Color? shadowColor,
  Color? splashColor,
  Color? unselectedWidgetColor,
  */
  static Future<void> pruebaAnalisisArchivos() async{
    if(Platform.isWindows){
      scanDir(Directory("C:"));
    } else {
      scanDir(Directory("/storage/emulated/0"));
    }
  }

  static void scanDir(Directory d) async{
    await for(var f in d.list(recursive: false, followLinks: false)){
      print(f.path);
      if(f.statSync().type == FileSystemEntityType.directory){
        scanDir((Directory(f.path)));
      } 
    }
  }

  static void changeTheme(bool isDark) async {
    preferences.themeMode = isDark?"darkMode":"lightMode";
    await PrefsDAO().update(preferences);
  }

  static void putUser(User user) async{
    preferences.isUserRegistered = true;
    preferences.uname = user.email;
    preferences.upass = user.pass;
    await PrefsDAO().update(preferences);
  }

  static RegExp emailRegExp = RegExp(r'^[a-zA-Z0-9]+@[a-z]+\.[a-z]{3}$');
}

extension StringExtension on String {
    String capitalize() {
      return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
    }
}