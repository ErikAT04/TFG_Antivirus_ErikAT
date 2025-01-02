///Clase de Preferencias del Usuario: Guarda distintos aspectos de la aplicación que puede configurar el usuario
class Preferences{
  ///Booleana que guarda si hay un usuario registrado en la aplicación. 
  ///Evita que se tenga que iniciar sesión todo el rato
  bool isUserRegistered;
  ///Nombre del usuario registrado
  String uname;
  ///Contraseña del usuario registrado
  String upass;
  ///Lenguaje seleccionado por el usuario
  String lang;
  ///Booleana que guarda si está marcada la opción del modo claro u oscuro en función del dispositivo
  bool isAutoTheme;
  ///Tema elegido por el usuario si esta opción está desactivada
  String themeMode;
  ///Constructor
  Preferences({required this.isUserRegistered, required this.uname, required this.upass, required this.lang, required this.isAutoTheme, required this.themeMode});
}
/*
CREATE TABLE IF NOT EXISTS preferences(
      isUserRegistered BOOLEAN,
      userName TEXT,
      userPass TEXT,
      chosenLang TEXT,
      isAutoThemeMode BOOLEAN,
      themeMode TEXT
    );
*/