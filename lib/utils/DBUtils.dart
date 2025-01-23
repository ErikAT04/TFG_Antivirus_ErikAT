import 'dart:io';
import 'package:path/path.dart';
import 'package:logger/logger.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

///Utils del gestor de MySQL

///Utils del gestor de SQLite
class SQLiteUtils {
  ///Función de creación de la BD (Saldrá la primera vez que se inicie la app)
  static Future<void> startDB() async {
    Logger().i("Database opened");
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
    Logger().i("Table preferences created");
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
    Logger().i("Table files created");
    await db.execute("""
    CREATE TABLE IF NOT EXISTS forbFolders(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT,
      route TEXT
    );
  """);
    Logger().i("Table folders created");
    await db.insert('preferences', {
      "isUserRegistered": 0,
      "userName": "",
      "userPass": "",
      "chosenLang": "es",
      "isAutoThemeMode": 0,
      "themeMode": "dark"
    });
    Logger().i("preferences inserted");
  }

  ///Base de datos de SQLite
  static late Database db;

  ///Función de carga de la BD de SQLite
  static Future<void> cargardb() async {
    DatabaseFactory dbfact;
    sqfliteFfiInit();
    if (!(Platform.isAndroid || Platform.isIOS)) {
      //Llamo a la base de datos de databaseFactoryFfi para crear la BD
      dbfact = databaseFactoryFfi;
    } else {
      dbfact = databaseFactory;
    }

    //Creo el path a la base de datos
    final dbPath = join(await dbfact.getDatabasesPath(), "localdb.db");

    db = await dbfact.openDatabase(dbPath);
  }
}

//Utils del API que se vaya a leer
class APIReaderUtils {
  static String apiRESTLink = "tfg-antivirus-erik-at-api.vercel.app";

  static Future<String> getData(Uri url) async {
    Logger().d(url);
    //Función que recibe una url y devuelve el cuerpo del API
    var response = await http.get(url); //Busca la url pasada
    if (response.statusCode == 200) {
      //Si el statusCode es 200 (Conexión realizada correctamente)
      return response.body; //Devuelve el body de la búsqueda
    } else {
      //Si no, devuelve simplemente noBody
      return "noBody";
    }
  }

  static Future<String> postData(Uri url, Object item) async {
    var response = await http.post(url, body: convert.jsonEncode(item));
    return response.body;
  }

  static Future<String> putData(Uri url, Object item) async {
    var response = await http.put(url, body: convert.jsonEncode(item));
    return response.body;
  }

  static Future<String> deleteData(Uri url) async {
    var response = await http.delete(url);
    return response.body;
  }
}
