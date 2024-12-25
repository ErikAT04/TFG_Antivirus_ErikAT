import 'package:mysql_client/mysql_client.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';

///Utils del gestor de MySQL
class MySQLUtils{
  static late MySQLConnection connection;

  static Future<void> loadSQLDB() async{
    connection = await MySQLConnection.createConnection(
            host: 'sql.freedb.tech',
            port: 3306,
            userName: 'freedb_AT_Root',
            password: 'RR5xHVqx2J#uVN?',
            databaseName: 'freedb_PruebasAndroid',
            secure: true);
    if(!connection.connected){ //En caso de que en algún dispositivo no se conecte directamente a la base de datos
      await connection.connect();
    }
  }
}


//Utils del gestor de SQLite
class SQLiteUtils{
  static late Database db;

  static Future<void> cargardb() async{
    sqfliteFfiInit();
    
    //Llamo a la base de datos de databaseFactoryFfi para crear la BD
    final databaseFactory = databaseFactoryFfi;

    //Creo el path a la base de datos
    final dbPath = join(await databaseFactory.getDatabasesPath(), "localdb.db");

    db = await databaseFactory.openDatabase(dbPath);
  }

}

//Utils del API que se vaya a leer
class APIReaderUtils{
  
}