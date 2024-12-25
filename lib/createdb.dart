import 'package:path/path.dart' as path;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main(List<String> args) async {
  sqfliteFfiInit();

  var databaseFactory = databaseFactoryFfi;

  var dbpath =
      path.join(await databaseFactory.getDatabasesPath(), 'localdb.db');
  var db = await databaseFactory.openDatabase(dbpath);
  print("Database opened");
  await db.execute("""
    CREATE TABLE IF NOT EXISTS preferences(
      isUserRegistered BOOLEAN,
      userName TEXT,
      userPass TEXT,
      chosenLang TEXT,
      isAutoThemeMode BOOLEAN,
      themeMode TEXT
    );
    """);
  print("Table preferences created");
  await db.execute("""
    CREATE TABLE IF NOT EXISTS files(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT,
      route TEXT,
      newName TEXT,
      newRoute TEXT,
      malwareType TEXT,
      quarantineDate DATE
    );
  """);
  print("Table files created");
  await db.execute("""
    CREATE TABLE IF NOT EXISTS forbFolders(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT,
      route TEXT
    );
  """);
  print("Table folders created");
  await db.insert('preferences', {
    "isUserRegistered": 'false',
    "userName": "",
    "userPass": "",
    "chosenLang": "es",
    "isAutoThemeMode": 'false',
    "themeMode": "dark"
  });
  print("preferences inserted");
}
