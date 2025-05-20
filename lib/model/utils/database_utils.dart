import 'dart:io';
import 'package:path/path.dart';
import 'dart:convert' as convert;
import 'package:logger/logger.dart';
import 'package:http/http.dart' as http;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:magik_antivirus/model/interfaces/api_content.dart';

///Utils del gestor de SQLite
class SQLiteUtils {
  ///Base de datos de SQLite
  static late Database db;

  ///Función de carga de la BD de SQLite
  static Future<void> loadDB() async {
    DatabaseFactory dbfact;
    sqfliteFfiInit();
    if (!(Platform.isAndroid || Platform.isIOS)) {
      dbfact = databaseFactoryFfi;
    } else {
      dbfact = databaseFactory;
    }

    //Creo el path a la base de datos
    final dbPath = join(await dbfact.getDatabasesPath(), "localdb.db");
    //Se abre la base de datos
    db = await dbfact.openDatabase(dbPath);
  }

  ///Función de creación de la BD (Saldrá la primera vez que se inicie la app)
  static Future<void> startDB() async {
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
  }
}

///Utils del API que se vaya a leer
class APIReaderUtils {
  ///Enlace estático al API Rest
  ///
  ///Da igual el endpoint del api que sea, ya que esto se repite en todos.
  static String apiRESTLink = "tfg-antivirus-erik-at-api.vercel.app";

  ///Token de la API
  ///
  ///La API está protegida de modo que solo pueden acceder a ella los usuarios registrados en la aplicación
  static String apiToken = "";

  ///Función de obtención del token para la API
  static void getToken(String username, String password) async {
    Uri url = Uri.https(apiRESTLink, "api/token");

    var response = await http.post(url, headers: {
      "Content-Type": "application/x-www-form-urlencoded"
    }, body: {
      'username': username,
      'password': password,
    });

    if (response.statusCode == 200) {
      apiToken = convert.json.decode(response.body)["access_token"];
    } else {
      Logger().e("Error de entrega de Token");
    }
  }

  ///Función de petición GET
  ///
  ///Recibe un enlace a un endpoint y devuelve el resultado de la búsqueda del API
  static Future<String> getData(Uri url) async {
    Logger().d(url);
    //Función que recibe una url y devuelve el cuerpo del API
    var response = await http.get(
      url,
      headers: {
        'Authorization': 'bearer $apiToken',
        'Content-Type': 'application/json',
      },
    ); //Busca la url pasada
    if (response.statusCode == 200) {
      //Si el statusCode es 200 (Conexión realizada correctamente)
      return response.body; //Devuelve el body de la búsqueda
    } else {
      //Si no, devuelve simplemente noBody
      return "noBody";
    }
  }

  ///Función de petición POST
  ///
  ///Recibe un enlace y un objeto y envía una petición POST del objeto como JSON
  static Future<String> postData(Uri url, APIContent item) async {
    var response = await http.post(url,
        headers: {
          'Authorization': 'bearer $apiToken',
          'Content-Type': 'application/json',
        },
        body: convert.jsonEncode(item.toAPI()));
    return response.body;
  }

  ///Función de petición PUT
  ///
  ///Recibe un enlace y un objeto y envía una petición PUT del objeto como JSON
  static Future<String> putData(Uri url, APIContent item) async {
    var response = await http.put(url,
        headers: {
          'Authorization': 'bearer $apiToken',
          'Content-Type': 'application/json',
        },
        body: convert.jsonEncode(item.toAPI()));
    Logger().d(
        "El put del item ${item.toAPI()} ha dado el codigo ${response.statusCode}");
    return response.body;
  }

  ///Función de petición DELETE
  ///
  ///Recibe un enlace y un objeto y envía una petición DELETE del objeto como JSON
  static Future<String> deleteData(Uri url) async {
    var response = await http.delete(
      url,
      headers: {'Authorization': 'bearer $apiToken'},
    );
    return response.body;
  }
}
