class Preferences{
  bool isUserRegistered;
  String uname;
  String upass;
  String lang;
  bool isAutoTheme;
  String themeMode;

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