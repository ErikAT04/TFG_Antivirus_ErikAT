import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:magik_antivirus/model/User.dart';
import 'package:magik_antivirus/model/Prefs.dart';
import 'package:magik_antivirus/model/Device.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:magik_antivirus/DataAccess/UserDAO.dart';
import 'package:magik_antivirus/DataAccess/PrefsDAO.dart';
import 'package:magik_antivirus/DataAccess/DeviceDAO.dart';
import 'package:magik_antivirus/DataAccess/ForbFolderDAO.dart';


///App Essentials: El conjunto de objetos y métodos que la aplicación necesita acceder de forma estática desde todos lados
class AppEssentials {
  ///Usuario estático
  ///Este usuario se guardará para, cuando se inicialice el programa, pasar su información al provider
  static User? user;

  ///Preferencias de la aplicación
  ///Guardará y gestionará las preferencias de la aplicación, haciendo las operaciones CRUD de las bases de datos
  static late Preferences preferences;

  ///Función de obtención de preferencias
  ///Obtiene las preferencias del usuario de la base de datos
  static Future<void> getProperties() async {
    preferences = (await PrefsDAO().get(""))!;
    if(preferences.isUserRegistered){
      user = await UserDAO().get(preferences.uname);
      print('pasa por aqui');
    }
  }

  ///Función de cambio de lenguaje
  ///Cambia el lenguaje de estas preferencias y actualiza la BD con ello
  static void changeLang(String lang) async {
    preferences.lang = lang;
    await PrefsDAO().update(preferences);
  }

  ///Mapa de colores
  ///Este mapa servirá para guardar todos los colores de la aplicación, de modo que se accede a ellas de forma sencilla.
  static Map<String, Color> colorsMap = {
    "appMainLightBlue": Color.fromARGB(255, 40, 184, 221),
    "appMainBlue": Color.fromARGB(255, 14, 54, 111),
    "appDarkBlue": Color.fromARGB(255, 10, 32, 64),
    "white": Colors.white,
    "black": Colors.black,
    "transpBlack": Color.fromARGB(25, 0, 0, 0)
  };

  ///Tema del modo oscuro
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
      foregroundColor: colorsMap["white"],
      centerTitle: true,
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
    ),
    listTileTheme: ListTileThemeData(
      iconColor: colorsMap["appMainLightBlue"],
      textColor: colorsMap["appMainLightBlue"],
      subtitleTextStyle: TextStyle(color: colorsMap["white"])
    ),
  );

  ///Tema del modo claro
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
      shadowColor: colorsMap["appMainBlue"],
      centerTitle: true,
      foregroundColor: colorsMap["appMainBlue"],
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
    ),
    listTileTheme: ListTileThemeData(
      iconColor: colorsMap["appMainBlue"],
      textColor: colorsMap["appMainBlue"],
      subtitleTextStyle: TextStyle(color: colorsMap["appMainBlue"])
    ),
  );

  ///Lista de idiomas que se pueden usar
  static List<Locale> listLocales = [
    Locale('es'),
    Locale('en'),
    Locale('de'),
    Locale('fr')
  ];

  ///Dispositivo actual
  static Device? dev;

  ///Función de registro y guardado de dispositivos
  ///La función recoge el identificador del dispositivo en función de su SO y lo utiliza para buscar en la BD una ocurrencia existente
  ///- Si existe, guarda en el dispositivo estático la ocurrencia
  ///- Si no existe, la crea con todos los datos necesarios 
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

  ///Lenguaje elegido
  static String chosenLocale = preferences.lang;

  ///Tema elegido
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

  ///Función de prueba de análisis:
  ///Si el dispositivo es Windows, comienza una búsqueda de archivos en C:\, mientras que en android (sin rootear) comienza en la raíz a la que tiene acceso
  static Future<void> pruebaAnalisisArchivos() async{
    List<String> forbiddenPaths = (await ForbFolderDAO().list()).map((folder) => folder.route).toList();
    if(Platform.isWindows){
      scanDir(Directory("C:"), forbiddenPaths);
    } else {
      scanDir(Directory("/storage/emulated/0"), forbiddenPaths);
    }
  }

  ///Función de escaneo de directorios:
  ///Mira si el File que está mirando es un directorio y si su acceso está o no prohibido
  ///Si es un archivo, imprime su path (esto es solo de prueba de momento)
  ///Si es un directorio y tiene acceso a él, llama otra vez a su función, esta vez desde este nuevo directorio
  static void scanDir(Directory d, List<String> forbiddenPaths) async{
    await for(var f in d.list(recursive: false, followLinks: false)){
      print(f.path);
      if(f.statSync().type == FileSystemEntityType.directory && !forbiddenPaths.contains(f.path)){
        scanDir((Directory(f.path)), forbiddenPaths);
      } 
    }
  }

  ///Función de cambio de tema:
  ///Cambia el tema de las preferencias y actualiza estas en la BD
  static void changeTheme(bool isDark) async {
    preferences.themeMode = isDark?"darkMode":"lightMode";
    await PrefsDAO().update(preferences);
  }

  ///Función de adición de usuarios a la BD
  ///Introduce el email y la contraseña en las preferencias, actualizando la BD con ello
  static void putUser(User user) async{
    preferences.isUserRegistered = true;
    preferences.uname = user.email;
    preferences.upass = user.pass;
    await PrefsDAO().update(preferences);
  }

  ///Expresión regular de corrección del email:
  ///El correo electrónico puede tener 
  static RegExp emailRegExp = RegExp(r'^[a-zA-Z0-9]+@[a-z]+\.[a-z]{3}$');
}