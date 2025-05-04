import 'package:flutter/material.dart';
import 'package:magik_antivirus/utils/app_essentials.dart';

///Provider que controla los estilos de la aplicación
///
///Ya que el color principal puede mutar en la aplicación, se debe poder cambiar en todo momento el color de los mapas y de los temas en función de dicho color
class StyleProvider extends ChangeNotifier {
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

  ///Color principal, precargado por el color guardado en las preferencias
  Color mainColor = AppEssentials.color;

  ///Mapa de colores
  ///
  ///Este mapa servirá para guardar todos los colores de la aplicación, de modo que se accede a ellas de forma sencilla.
  Map<String, Color> get palette => {
        "appLight": Color.alphaBlend(Color.fromRGBO(255, 255, 255, 0.7),
            mainColor), //Fundido con blanco semitransparente
        "appMain": mainColor,
        "appDark": Color.alphaBlend(Color.fromRGBO(0, 0, 0, 0.1),
            mainColor), //Fundido con negro casi transparente
        "white": Colors.white,
        "black": Colors.black,
        "transpBlack": Color.fromARGB(25, 0, 0, 0),
        "grey": Color.fromARGB(255, 233, 233, 233),
        "red": Color.fromARGB(255, 151, 13, 13)
      };

  ///Tema del modo oscuro
  ThemeData get darkMode => ThemeData(
      brightness: Brightness.dark,
      fontFamily: "Roboto",
      colorSchemeSeed: palette["appMain"],
      canvasColor: palette["appDark"],
      cardColor: palette["appDark"],
      dialogBackgroundColor: palette["appDark"],
      dividerColor: palette["appLight"],
      focusColor: palette["appLight"],
      highlightColor: palette["appMain"],
      hoverColor: palette["appMain"],
      //primaryColor: colorsMap["appMain"],
      primaryColorDark: palette["appDark"],
      primaryColorLight: palette["appLight"],
      scaffoldBackgroundColor: palette["appMain"],
      secondaryHeaderColor: palette["appMain"],
      cardTheme: CardThemeData(
        color: palette["appDark"],
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: palette["appLight"],
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
        iconColor: WidgetStateProperty.resolveWith<Color?>(
          //Texto
          (Set<WidgetState> states) {
            if (states.contains(WidgetState.hovered) ||
                states.contains(WidgetState.pressed)) {
              return palette["white"];
            }
            return palette["appLight"];
          },
        ),
        backgroundColor: WidgetStateProperty.resolveWith<Color?>(
          //Fondo
          (Set<WidgetState> states) {
            if (states.contains(WidgetState.hovered) ||
                states.contains(WidgetState.pressed)) {
              return palette["appLight"];
            }
            return palette["appDark"];
          },
        ),
        foregroundColor: WidgetStateProperty.resolveWith<Color?>(
          //Texto
          (Set<WidgetState> states) {
            if (states.contains(WidgetState.hovered) ||
                states.contains(WidgetState.pressed)) {
              return palette["white"];
            }
            return palette["appLight"];
          },
        ),
        side: WidgetStateProperty.resolveWith<BorderSide?>(
          //Fondo
          (Set<WidgetState> states) {
            if (states.contains(WidgetState.hovered) ||
                states.contains(WidgetState.pressed)) {
              return BorderSide(color: palette["white"]!);
            }
            return BorderSide(color: palette["appLight"]!);
          },
        ),
      )),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        type: BottomNavigationBarType.fixed,
        backgroundColor: palette["appDark"],
        selectedItemColor: palette["appLight"],
        unselectedItemColor: palette["appLight"],
        selectedLabelStyle: TextStyle(color: palette["appLight"]),
        unselectedLabelStyle: TextStyle(color: palette["appLight"]),
      ),
      appBarTheme: AppBarTheme(
        foregroundColor: palette["white"],
        centerTitle: true,
        backgroundColor: palette["appDark"],
        titleTextStyle: TextStyle(color: palette["white"], fontSize: 20),
      ),
      textTheme: Typography.whiteCupertino,
      inputDecorationTheme: InputDecorationTheme(
        labelStyle: TextStyle(
          color: palette["appLight"],
        ),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: palette["appLight"]!)),
        errorBorder:
            OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: palette["appLight"]!),
        ),
      ),
      iconTheme: IconThemeData(color: palette["appLight"]),
      drawerTheme: DrawerThemeData(
        backgroundColor: palette["appDark"],
        surfaceTintColor: palette["appLight"],
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: palette["appDark"],
      ),
      listTileTheme: ListTileThemeData(
          iconColor: palette["appLight"],
          textColor: palette["appLight"],
          subtitleTextStyle: TextStyle(color: palette["white"])),
      navigationRailTheme: NavigationRailThemeData(
          backgroundColor: palette["appDark"],
          unselectedIconTheme: IconThemeData(
            color: palette["appLight"],
          ),
          selectedIconTheme: IconThemeData(color: palette["appLight"]),
          selectedLabelTextStyle: TextStyle(color: palette["appLight"]),
          unselectedLabelTextStyle: TextStyle(color: palette["appLight"])));

  ///Tema del modo claro
  ThemeData get lightMode => ThemeData(
      brightness: Brightness.light,
      fontFamily: "Roboto",
      colorSchemeSeed: palette["white"],
      canvasColor: palette["appMain"],
      cardColor: palette["appMain"],
      dialogBackgroundColor: palette["appMain"],
      dividerColor: palette["appLight"],
      focusColor: palette["appLight"],
      highlightColor: palette["appLight"],
      hoverColor: palette["appLight"],
      //primaryColor: colorsMap["appMain"],
      primaryColorDark: palette["appDark"],
      primaryColorLight: palette["appLight"],
      scaffoldBackgroundColor: palette["white"],
      secondaryHeaderColor: palette["appMain"],
      cardTheme: CardThemeData(
        color: palette["white"],
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: palette["appMain"],
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
        iconColor: WidgetStateProperty.resolveWith<Color?>(
          //Texto
          (Set<WidgetState> states) {
            if (states.contains(WidgetState.hovered) ||
                states.contains(WidgetState.pressed)) {
              return palette["white"];
            }
            return palette["appLight"];
          },
        ),
        backgroundColor: WidgetStateProperty.resolveWith<Color?>(
          //Fondo
          (Set<WidgetState> states) {
            if (states.contains(WidgetState.hovered) ||
                states.contains(WidgetState.pressed)) {
              return palette["appDark"];
            }
            return palette["white"];
          },
        ),
        foregroundColor: WidgetStateProperty.resolveWith<Color?>(
          //Texto
          (Set<WidgetState> states) {
            if (states.contains(WidgetState.hovered) ||
                states.contains(WidgetState.pressed)) {
              return palette["white"];
            }
            return palette["black"];
          },
        ),
        side: WidgetStateProperty.resolveWith<BorderSide?>(
          //Borde
          (Set<WidgetState> states) {
            if (states.contains(WidgetState.hovered) ||
                states.contains(WidgetState.pressed)) {
              return BorderSide(color: palette["appDark"]!);
            }
            return BorderSide(color: palette["appMain"]!);
          },
        ),
      )),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: palette["grey"],
        selectedItemColor: palette["appDark"],
        unselectedItemColor: palette["appDark"],
        selectedLabelStyle: TextStyle(color: palette["appDark"]),
        unselectedLabelStyle: TextStyle(color: palette["appDark"]),
      ),
      appBarTheme: AppBarTheme(
          shadowColor: palette["appMain"],
          centerTitle: true,
          foregroundColor: palette["appMain"],
          backgroundColor: palette["grey"],
          titleTextStyle: TextStyle(color: palette["appMain"], fontSize: 20)),
      textTheme: Typography.blackCupertino,
      inputDecorationTheme: InputDecorationTheme(
        labelStyle: TextStyle(
          color: palette["appMain"],
        ),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: palette["appMain"]!)),
        errorBorder:
            OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: palette["appMain"]!),
        ),
      ),
      iconTheme: IconThemeData(color: palette["appMain"]),
      drawerTheme: DrawerThemeData(
          backgroundColor: palette["white"],
          surfaceTintColor: palette["black"]),
      dialogTheme: DialogThemeData(
        backgroundColor: palette["white"],
      ),
      listTileTheme: ListTileThemeData(
          iconColor: palette["appMain"],
          textColor: palette["appMain"],
          subtitleTextStyle: TextStyle(color: palette["appMain"])),
      navigationRailTheme: NavigationRailThemeData(
          backgroundColor: palette["grey"],
          unselectedIconTheme: IconThemeData(
            color: palette["appMain"],
          ),
          selectedIconTheme: IconThemeData(color: palette["appMain"]),
          selectedLabelTextStyle: TextStyle(color: palette["appMain"]),
          unselectedLabelTextStyle: TextStyle(color: palette["appMain"])));

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
