import 'package:flutter/material.dart';

///Clase que guarda los estilos de la aplicación
///
///Debido a buscar algo más de orden en la aplicación y no sobrecargar la clase AppEssentials, este archivo guarda la información de los temas y colores, se encarga de la estética principalmente
class StyleEssentials{
  ///Mapa de colores
  ///
  ///Este mapa servirá para guardar todos los colores de la aplicación, de modo que se accede a ellas de forma sencilla.
  static Map<String, Color> colorsMap = {
    "appMainLightBlue": Color.fromARGB(255, 40, 184, 221),
    "appMainBlue": Color.fromARGB(255, 14, 54, 111),
    "appDarkBlue": Color.fromARGB(255, 10, 32, 64),
    "white": Colors.white,
    "black": Colors.black,
    "transpBlack": Color.fromARGB(25, 0, 0, 0),
    "grey": Color.fromARGB(255, 233, 233, 233)
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
        backgroundColor: WidgetStateProperty.resolveWith<Color?>(
          //Fondo
          (Set<WidgetState> states) {
            if (states.contains(WidgetState.hovered) ||
                states.contains(WidgetState.pressed)) {
              return colorsMap["appMainLightBlue"];
            }
            return colorsMap["appDarkBlue"];
          },
        ),
        foregroundColor: WidgetStateProperty.resolveWith<Color?>(
          //Texto
          (Set<WidgetState> states) {
            if (states.contains(WidgetState.hovered) ||
                states.contains(WidgetState.pressed)) {
              return colorsMap["white"];
            }
            return colorsMap["appMainLightBlue"];
          },
        ),
        side: WidgetStateProperty.resolveWith<BorderSide?>(
          //Fondo
          (Set<WidgetState> states) {
            if (states.contains(WidgetState.hovered) ||
                states.contains(WidgetState.pressed)) {
              return BorderSide(color: colorsMap["white"]!);
            }
            return BorderSide(color: colorsMap["appMainLightBlue"]!);
          },
        ),
      )),
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
        titleTextStyle: TextStyle(color: colorsMap["white"], fontSize: 20),
      ),
      textTheme: Typography.whiteCupertino,
      inputDecorationTheme: InputDecorationTheme(
        labelStyle: TextStyle(
          color: colorsMap["appMainLightBlue"],
        ),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: colorsMap["appMainLightBlue"]!)),
        errorBorder:
            OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: colorsMap["appMainLightBlue"]!),
        ),
      ),
      iconTheme: IconThemeData(color: colorsMap["appMainLightBlue"]),
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
          subtitleTextStyle: TextStyle(color: colorsMap["white"])),
      navigationRailTheme: NavigationRailThemeData(
          backgroundColor: colorsMap["appDarkBlue"],
          unselectedIconTheme: IconThemeData(
            color: colorsMap["appMainLightBlue"],
          ),
          selectedIconTheme:
              IconThemeData(color: colorsMap["appMainLightBlue"]),
          selectedLabelTextStyle:
              TextStyle(color: colorsMap["appMainLightBlue"]),
          unselectedLabelTextStyle:
              TextStyle(color: colorsMap["appMainLightBlue"])));

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
        backgroundColor: WidgetStateProperty.resolveWith<Color?>(
          //Fondo
          (Set<WidgetState> states) {
            if (states.contains(WidgetState.hovered) ||
                states.contains(WidgetState.pressed)) {
              return colorsMap["appDarkBlue"];
            }
            return colorsMap["white"];
          },
        ),
        foregroundColor: WidgetStateProperty.resolveWith<Color?>(
          //Texto
          (Set<WidgetState> states) {
            if (states.contains(WidgetState.hovered) ||
                states.contains(WidgetState.pressed)) {
              return colorsMap["white"];
            }
            return colorsMap["black"];
          },
        ),
        side: WidgetStateProperty.resolveWith<BorderSide?>(
          //Borde
          (Set<WidgetState> states) {
            if (states.contains(WidgetState.hovered) ||
                states.contains(WidgetState.pressed)) {
              return BorderSide(color: colorsMap["appDarkBlue"]!);
            }
            return BorderSide(color: colorsMap["appMainBlue"]!);
          },
        ),
      )),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: colorsMap["grey"],
        selectedItemColor: colorsMap["appDarkBlue"],
        unselectedItemColor: colorsMap["appDarkBlue"],
        selectedLabelStyle: TextStyle(color: colorsMap["appDarkBlue"]),
        unselectedLabelStyle: TextStyle(color: colorsMap["appDarkBlue"]),
      ),
      appBarTheme: AppBarTheme(
          shadowColor: colorsMap["appMainBlue"],
          centerTitle: true,
          foregroundColor: colorsMap["appMainBlue"],
          backgroundColor: colorsMap["grey"],
          titleTextStyle:
              TextStyle(color: colorsMap["appMainBlue"], fontSize: 20)),
      textTheme: Typography.blackCupertino,
      inputDecorationTheme: InputDecorationTheme(
        labelStyle: TextStyle(
          color: colorsMap["appMainBlue"],
        ),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: colorsMap["appMainBlue"]!)),
        errorBorder:
            OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: colorsMap["appMainBlue"]!),
        ),
      ),
      iconTheme: IconThemeData(color: colorsMap["appMainBlue"]),
      drawerTheme: DrawerThemeData(
          backgroundColor: colorsMap["white"],
          surfaceTintColor: colorsMap["black"]),
      dialogTheme: DialogThemeData(
        backgroundColor: colorsMap["white"],
      ),
      listTileTheme: ListTileThemeData(
          iconColor: colorsMap["appMainBlue"],
          textColor: colorsMap["appMainBlue"],
          subtitleTextStyle: TextStyle(color: colorsMap["appMainBlue"])),
      navigationRailTheme: NavigationRailThemeData(
          backgroundColor: colorsMap["grey"],
          unselectedIconTheme: IconThemeData(
            color: colorsMap["appMainBlue"],
          ),
          selectedIconTheme: IconThemeData(color: colorsMap["appMainBlue"]),
          selectedLabelTextStyle: TextStyle(color: colorsMap["appMainBlue"]),
          unselectedLabelTextStyle:
              TextStyle(color: colorsMap["appMainBlue"])));

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