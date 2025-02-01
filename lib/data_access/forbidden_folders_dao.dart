import 'package:logger/logger.dart';
import 'package:magik_antivirus/utils/database_utils.dart';
import 'package:magik_antivirus/model/forbidden_folder.dart';
import 'package:magik_antivirus/data_access/dao_interfaces.dart';
///Clase que lleva todo lo relacionado a las operaciones CRUD de los ficheros a los que no se tiene acceso
///
///La información de esta se hace por medio de la base de datos de SQLite, ya que se guarda en local
class ForbFolderDAO implements DAOInterface<ForbFolder, int>{
  ///Función de borrado:
  ///
  ///Recibe un directorio y lo elimina de la BD
  @override
  Future<bool> delete(ForbFolder item) async {
    try{
      var res = await SQLiteUtils.db.delete('forbFolders', where: 'id=?', whereArgs: [item.id]);
      return res==1;
    }catch(e){
      Logger().e(e);
      return false;
    }
  }

  ///Función de obtención (Actualmente sin uso)
  ///
  ///Recibe un entero por parámetro y devuelve el directorio con ese id 
  @override
  Future<ForbFolder?> get(int value) async {
    try{
      var res = await SQLiteUtils.db.query('forbFolders', where: 'id=?', whereArgs: [value]);
      var line = res.first;
      return ForbFolder(id: int.parse(line["id"].toString()), name: line["name"].toString(), route: line["route"].toString());
    }catch(e){
      Logger().e(e);
      return null;
    }
  }

  ///Función de inserción
  ///
  ///Recibe un directorio por parámetros y lo añade a la BD
  @override
  Future<bool> insert(ForbFolder item) async {
    try{
      var res = await SQLiteUtils.db.insert('forbFolders', {
        'name':item.name,
        'route':item.route
      });
      return res==1;
    }catch(e){
      Logger().e(e);
      return false;
    }
  }

  ///Función de listado
  ///
  ///Devuelve la lista de directorios prohibidos de la BD
  @override
  Future<List<ForbFolder>> list() async {
    List<ForbFolder> list = [];
    try{
      var res = await SQLiteUtils.db.query('forbFolders');
      for (var line in res){
        list.add(ForbFolder(id: int.parse(line["id"].toString()), name: line["name"].toString(), route: line["route"].toString()));
      }
    }catch(e){
      Logger().e(e);
    }
    return list;
  }

  ///Función de actualización (Actualmente sin uso)
  ///
  ///Recibe un directorio por parámetro y actualiza sus valores en la BD en función de su id
  @override
  Future<bool> update(ForbFolder item) async {
    try{
      var res = await SQLiteUtils.db.update('forbFolders', {
        'name':item.name,
        'route':item.route
      },
      where: 'id=?', whereArgs: [item.id]);
      return res == 1;
    }catch(e){
      Logger().e(e);
      return false;
    }
  }
}
/*
    CREATE TABLE IF NOT EXISTS forbFolders(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT,
      route TEXT
    );
    */