import 'package:flutter/material.dart';
import 'package:magik_antivirus/utils/app_essentials.dart';

///Provider que controla los estilos de la aplicación
///
///Debido a buscar algo más de orden en la aplicación y no sobrecargar la clase UserDataNotifier, este archivo guarda la información de los temas y colores, se encarga de la estética principalmente
///
///Ya que el color principal puede mutar en la aplicación, se debe poder cambiar en todo momento el color de los mapas y de los temas en función de dicho color
class StyleProvider extends ChangeNotifier {
  ///Color principal, precargado por el color guardado en las preferencias
  Color mainColor = AppEssentials.color;

  ///Booleana que rige si el modo actual es claro u oscuro, precargado por el modo guardado en las preferencias 
  bool isLightModeActive = AppEssentials.isLightMode;

  ///Función de cambio de color
  ///
  ///Además de cambiar el color y notificar los listeners, guarda los colores en las preferencias
  void changeThemeColor(Color color) {
    mainColor = color;
    AppEssentials.saveColorPreferences(color);
    notifyListeners();
  }

  ///Función de cambio de modo
  ///
  ///Si el tema era claro, lo cambia a oscuro y viceversa. También se encarga de guardar la elección en las preferencias
  void changeThemeMode() {
    isLightModeActive = !isLightModeActive;
    AppEssentials.changeTheme(isLightModeActive);
    notifyListeners();
  }

  ///Mapa de colores
  ///
  ///Este mapa servirá para guardar todos los colores de la aplicación, de modo que se accede a ellas de forma sencilla.
  Map<String, Color> get colorsMap => {
        "appLight":
            Color.alphaBlend(Color.fromRGBO(255, 255, 255, 0.7), mainColor),
        "appMain": mainColor,
        "appDark": Color.alphaBlend(Color.fromRGBO(0, 0, 0, 0.1), mainColor),
        "white": Colors.white,
        "black": Colors.black,
        "transpBlack": Color.fromARGB(25, 0, 0, 0),
        "grey": Color.fromARGB(255, 233, 233, 233),
        "red": Color.fromARGB(255, 151, 13, 13)
      };

  ///Tema del modo oscuro
  ThemeData get darkMode => ThemeData(
      fontFamily: "Roboto",
      colorSchemeSeed: colorsMap["appMain"],
      canvasColor: colorsMap["appDark"],
      cardColor: colorsMap["appDark"],
      dialogBackgroundColor: colorsMap["appDark"],
      dividerColor: colorsMap["appLight"],
      focusColor: colorsMap["appLight"],
      highlightColor: colorsMap["appMain"],
      hoverColor: colorsMap["appMain"],
      //primaryColor: colorsMap["appMain"],
      primaryColorDark: colorsMap["appDark"],
      primaryColorLight: colorsMap["appLight"],
      scaffoldBackgroundColor: colorsMap["appMain"],
      secondaryHeaderColor: colorsMap["appMain"],
      cardTheme: CardThemeData(
        color: colorsMap["appDark"],
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
        iconColor: WidgetStateProperty.resolveWith<Color?>(
          //Texto
          (Set<WidgetState> states) {
            if (states.contains(WidgetState.hovered) ||
                states.contains(WidgetState.pressed)) {
              return colorsMap["white"];
            }
            return colorsMap["appLight"];
          },
        ),
        backgroundColor: WidgetStateProperty.resolveWith<Color?>(
          //Fondo
          (Set<WidgetState> states) {
            if (states.contains(WidgetState.hovered) ||
                states.contains(WidgetState.pressed)) {
              return colorsMap["appLight"];
            }
            return colorsMap["appDark"];
          },
        ),
        foregroundColor: WidgetStateProperty.resolveWith<Color?>(
          //Texto
          (Set<WidgetState> states) {
            if (states.contains(WidgetState.hovered) ||
                states.contains(WidgetState.pressed)) {
              return colorsMap["white"];
            }
            return colorsMap["appLight"];
          },
        ),
        side: WidgetStateProperty.resolveWith<BorderSide?>(
          //Fondo
          (Set<WidgetState> states) {
            if (states.contains(WidgetState.hovered) ||
                states.contains(WidgetState.pressed)) {
              return BorderSide(color: colorsMap["white"]!);
            }
            return BorderSide(color: colorsMap["appLight"]!);
          },
        ),
      )),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: colorsMap["appDark"],
        selectedItemColor: colorsMap["appLight"],
        unselectedItemColor: colorsMap["appLight"],
        selectedLabelStyle: TextStyle(color: colorsMap["appLight"]),
        unselectedLabelStyle: TextStyle(color: colorsMap["appLight"]),
      ),
      appBarTheme: AppBarTheme(
        foregroundColor: colorsMap["white"],
        centerTitle: true,
        backgroundColor: colorsMap["appDark"],
        titleTextStyle: TextStyle(color: colorsMap["white"], fontSize: 20),
      ),
      textTheme: Typography.whiteCupertino,
      inputDecorationTheme: InputDecorationTheme(
        labelStyle: TextStyle(
          color: colorsMap["appLight"],
        ),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: colorsMap["appLight"]!)),
        errorBorder:
            OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: colorsMap["appLight"]!),
        ),
      ),
      iconTheme: IconThemeData(color: colorsMap["appLight"]),
      drawerTheme: DrawerThemeData(
        backgroundColor: colorsMap["appDark"],
        surfaceTintColor: colorsMap["appLight"],
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: colorsMap["appDark"],
      ),
      listTileTheme: ListTileThemeData(
          iconColor: colorsMap["appLight"],
          textColor: colorsMap["appLight"],
          subtitleTextStyle: TextStyle(color: colorsMap["white"])),
      navigationRailTheme: NavigationRailThemeData(
          backgroundColor: colorsMap["appDark"],
          unselectedIconTheme: IconThemeData(
            color: colorsMap["appLight"],
          ),
          selectedIconTheme: IconThemeData(color: colorsMap["appLight"]),
          selectedLabelTextStyle: TextStyle(color: colorsMap["appLight"]),
          unselectedLabelTextStyle: TextStyle(color: colorsMap["appLight"])));

  ///Tema del modo claro
  ThemeData get lightMode => ThemeData(
      fontFamily: "Roboto",
      colorSchemeSeed: colorsMap["white"],
      canvasColor: colorsMap["appMain"],
      cardColor: colorsMap["appMain"],
      dialogBackgroundColor: colorsMap["appMain"],
      dividerColor: colorsMap["appLight"],
      focusColor: colorsMap["appLight"],
      highlightColor: colorsMap["appLight"],
      hoverColor: colorsMap["appLight"],
      //primaryColor: colorsMap["appMain"],
      primaryColorDark: colorsMap["appDark"],
      primaryColorLight: colorsMap["appLight"],
      scaffoldBackgroundColor: colorsMap["white"],
      secondaryHeaderColor: colorsMap["appMain"],
      cardTheme: CardThemeData(
        color: colorsMap["white"],
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
        iconColor: WidgetStateProperty.resolveWith<Color?>(
          //Texto
          (Set<WidgetState> states) {
            if (states.contains(WidgetState.hovered) ||
                states.contains(WidgetState.pressed)) {
              return colorsMap["white"];
            }
            return colorsMap["appLight"];
          },
        ),
        backgroundColor: WidgetStateProperty.resolveWith<Color?>(
          //Fondo
          (Set<WidgetState> states) {
            if (states.contains(WidgetState.hovered) ||
                states.contains(WidgetState.pressed)) {
              return colorsMap["appDark"];
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
              return BorderSide(color: colorsMap["appDark"]!);
            }
            return BorderSide(color: colorsMap["appMain"]!);
          },
        ),
      )),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: colorsMap["grey"],
        selectedItemColor: colorsMap["appDark"],
        unselectedItemColor: colorsMap["appDark"],
        selectedLabelStyle: TextStyle(color: colorsMap["appDark"]),
        unselectedLabelStyle: TextStyle(color: colorsMap["appDark"]),
      ),
      appBarTheme: AppBarTheme(
          shadowColor: colorsMap["appMain"],
          centerTitle: true,
          foregroundColor: colorsMap["appMain"],
          backgroundColor: colorsMap["grey"],
          titleTextStyle: TextStyle(color: colorsMap["appMain"], fontSize: 20)),
      textTheme: Typography.blackCupertino,
      inputDecorationTheme: InputDecorationTheme(
        labelStyle: TextStyle(
          color: colorsMap["appMain"],
        ),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: colorsMap["appMain"]!)),
        errorBorder:
            OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: colorsMap["appMain"]!),
        ),
      ),
      iconTheme: IconThemeData(color: colorsMap["appMain"]),
      drawerTheme: DrawerThemeData(
          backgroundColor: colorsMap["white"],
          surfaceTintColor: colorsMap["black"]),
      dialogTheme: DialogThemeData(
        backgroundColor: colorsMap["white"],
      ),
      listTileTheme: ListTileThemeData(
          iconColor: colorsMap["appMain"],
          textColor: colorsMap["appMain"],
          subtitleTextStyle: TextStyle(color: colorsMap["appMain"])),
      navigationRailTheme: NavigationRailThemeData(
          backgroundColor: colorsMap["grey"],
          unselectedIconTheme: IconThemeData(
            color: colorsMap["appMain"],
          ),
          selectedIconTheme: IconThemeData(color: colorsMap["appMain"]),
          selectedLabelTextStyle: TextStyle(color: colorsMap["appMain"]),
          unselectedLabelTextStyle: TextStyle(color: colorsMap["appMain"])));

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
