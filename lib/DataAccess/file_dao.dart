import 'package:logger/logger.dart';
import 'package:magik_antivirus/model/file.dart';
import 'package:magik_antivirus/utils/database_utils.dart';
import 'package:magik_antivirus/DataAccess/dao_interfaces.dart';

///Clase que lleva todo lo relacionado a las operaciones CRUD de los archivos
///
///La información de esta se hace por medio de la base de datos de SQLite, ya que se guarda en local
class FileDAO implements DAOInterface<SysFile, int>{
  ///Función de borrado
  ///
  ///Recibe un item y lo borra por su ID
  @override
  Future<bool> delete(SysFile item) async {
    try{
    var res = await SQLiteUtils.db.delete('files', where: 'id = ?', whereArgs: [item.id]);
    return res==1;
    }catch(e){
      Logger().e(e);
      return false;
    }
  }

  ///Función de obtención (Sin uso actualmente)
  ///
  ///Recibe un id por parámetro y devuelve la información de un fichero
  @override
  Future<SysFile?> get(int value) async {
    try{
      var line = (await SQLiteUtils.db.query('files', where: 'id=?', whereArgs: [value])).first;
      return SysFile(id: int.parse(line["id"].toString()), name: line["name"].toString(), route: line["route"].toString(), newName: line["newName"].toString(), newRoute: line["newRoute"].toString(), malwareType: line["malwareType"].toString(), quarantineDate: DateTime.parse(line["quarantineDate"].toString().substring(0, 10)));
    }catch(e){
      Logger().e(e);
      return null;
    }
  }
  ///Función de Inserción
  ///
  ///Recibe un item y guarda su información en la base de datos
  @override
  Future<bool> insert(SysFile item) async {
    try{
      var res = await SQLiteUtils.db.insert('files', {
        'name': item.name,
        'route': item.route,
        'newName': item.newName,
        'newRoute': item.newRoute,
        'malwareType': item.malwareType,
        'quarantineDate': item.quarantineDate.toString().substring(0, 10)
      });
      return res!=0;
    }catch(e){
      Logger().e(e);
      return false;
    }
  }
  ///Función de Listado
  ///
  ///Envia al usuario el listado de todos los archivos en la BD 
  @override
  Future<List<SysFile>> list() async {
    List<SysFile> list = [];
    try{
      var res = await SQLiteUtils.db.query('files');
      for (var line in res){
        list.add(SysFile(id: int.parse(line["id"].toString()), name: line["name"].toString(), route: line["route"].toString(), newName: line["newName"].toString(), newRoute: line["newRoute"].toString(), malwareType: line["malwareType"].toString(), quarantineDate: DateTime.parse(line["quarantineDate"].toString().substring(0, 10))));
      }
    }catch(e){}
    return list;
  }
  /*
CREATE TABLE IF NOT EXISTS files(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT,
      route TEXT,
      newName TEXT,
      newRoute TEXT,
      malwareType TEXT,
      quarantineDate DATE
    );
*/
  ///Función de Modificación (Sin uso actualmente)
  ///
  ///Recibe un objeto entero por parámetro y cambia todos sus valores de la BD en función del ID 
  @override
  Future<bool> update(SysFile item) async {
    try{
      var res = await SQLiteUtils.db.update('files', {
        'name': item.name,
        'route': item.route,
        'newName': item.newName,
        'newRoute': item.newRoute,
        'malwareType': item.malwareType,
        'quarantineDate': item.quarantineDate
      }, where: "id=?", whereArgs: [item.id]);
      return res!=0;
    }catch(e){
      Logger().e(e);
      return false;
    }
  }
}