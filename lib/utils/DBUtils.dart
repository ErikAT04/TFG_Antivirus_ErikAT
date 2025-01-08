import 'dart:io';
import 'package:path/path.dart';
import 'package:mysql_client/mysql_client.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';


///Utils del gestor de MySQL
class MySQLUtils {
  ///Conexión a la BD de MySQL
  static late MySQLConnection connection;

  ///Función de carga de la BD de MySQL
  static Future<void> loadSQLDB() async {
    connection = await MySQLConnection.createConnection(
        host: 'sql.freedb.tech',
        port: 3306,
        userName: 'freedb_AT_Root',
        password: 'RR5xHVqx2J#uVN?',
        databaseName: 'freedb_PruebasAndroid',
        secure: true);
    if (!connection.connected) {
      //En caso de que en algún dispositivo no se conecte directamente a la base de datos
      await connection.connect();
    }
  }
}

///Utils del gestor de SQLite
class SQLiteUtils {
  ///Función de creación de la BD (Saldrá la primera vez que se inicie la app)
  static Future<void> startDB() async {
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
      "isUserRegistered": 0,
      "userName": "",
      "userPass": "",
      "chosenLang": "es",
      "isAutoThemeMode": 0,
      "themeMode": "dark"
    });
    print("preferences inserted");
  }

  ///Base de datos de SQLite
  static late Database db;

  ///Función de carga de la BD de SQLite
  static Future<void> cargardb() async {
    var dbfact;
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
class APIReaderUtils {}
