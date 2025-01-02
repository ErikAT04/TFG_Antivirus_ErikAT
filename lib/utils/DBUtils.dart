import 'dart:io';

import 'package:mysql_client/mysql_client.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';

///Utils del gestor de MySQL
class MySQLUtils {
  static late MySQLConnection connection;

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

//Utils del gestor de SQLite
class SQLiteUtils {
  static Future<void> startDB() async {
    if (!(Platform.isAndroid || Platform.isIOS)) {
      sqfliteFfiInit();
      //Llamo a la base de datos de databaseFactoryFfi para crear la BD
      final databaseFactory = databaseFactoryFfi;
    }

    //Creo el path a la base de datos
    final dbPath = (!(Platform.isAndroid || Platform.isIOS))
        ? join(await databaseFactory.getDatabasesPath(), "localdb.db")
        : join(await getDatabasesPath(), 'localdb.db');

    db = await databaseFactory.openDatabase(dbPath);
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

  static late Database db;

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

    db = await databaseFactory.openDatabase(dbPath);
  }
}

//Utils del API que se vaya a leer
class APIReaderUtils {}
