import 'package:flutter/services.dart';
import 'package:magik_antivirus/DataAccess/PrefsDAO.dart';
import 'package:magik_antivirus/model/Prefs.dart';
import 'package:flutter/material.dart';
import 'package:magik_antivirus/model/User.dart';

/// App Essentials: El contenido del pc
class AppEssentials {
  static late User user;

  static late Preferences preferences;

  static Future<void> getProperties() async {
    preferences = (await PrefsDAO().get(""))!;
  }

  static void changeLang(String lang) {
    preferences.lang = lang;
    chosenLocale = lang;
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
    highlightColor: colorsMap["appMainLightBlue"],
    hoverColor: colorsMap["appMainLightBlue"],
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
                    if (states.contains(WidgetState.hovered)) {
                      return colorsMap["appMainLightBlue"]; 
                    }
                    return colorsMap["appDarkBlue"]; 
                  },
                ),
        foregroundColor: WidgetStateProperty.resolveWith<Color?>( //Texto
          (Set<WidgetState> states) {
            if (states.contains(WidgetState.hovered)) {
              return colorsMap["white"];
            }
            return colorsMap["appMainLightBlue"];
          },
        ),
        side: WidgetStateProperty.resolveWith<BorderSide?>( //Fondo
          (Set<WidgetState> states) {
            if (states.contains(WidgetState.hovered)) {
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
      color: colorsMap["appDarkBlue"],
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
                    if (states.contains(WidgetState.hovered)) {
                      return colorsMap["appDarkBlue"];
                    }
                    return colorsMap["white"];
                  },
                ),
        foregroundColor: WidgetStateProperty.resolveWith<Color?>( //Texto
          (Set<WidgetState> states) {
            if (states.contains(WidgetState.hovered)) {
              return colorsMap["white"]; 
            }
            return colorsMap["black"];
          },
        ),
        side: WidgetStateProperty.resolveWith<BorderSide?>( //Borde
          (Set<WidgetState> states) {
            if (states.contains(WidgetState.hovered)) {
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
      color: colorsMap["white"],
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
  );

  static List<Locale> listLocales = [
    Locale('es'),
    Locale('en'),
    Locale('de'),
    Locale('fr')
  ];

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
}
