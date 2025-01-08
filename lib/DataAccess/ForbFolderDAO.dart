import 'package:magik_antivirus/utils/DBUtils.dart';
import 'package:magik_antivirus/model/ForbFolder.dart';
import 'package:magik_antivirus/DataAccess/DAOInterfaces.dart';
///Clase que lleva todo lo relacionado a las operaciones CRUD de los ficheros a los que no se tiene acceso
///La información de esta se hace por medio de la base de datos de SQLite, ya que se guarda en local
class ForbFolderDAO implements DAOInterface<ForbFolder, int>{
  @override
  Future<bool> delete(ForbFolder item) async {
    try{
      var res = await SQLiteUtils.db.delete('forbFolders', where: 'id=?', whereArgs: [item.id]);
      return res==1;
    }catch(e){
      print(e);
      return false;
    }
  }

  @override
  Future<ForbFolder?> get(int value) async {
    try{
      var res = await SQLiteUtils.db.query('forbFolders', where: 'id=?', whereArgs: [value]);
      var line = res.first;
      return ForbFolder(id: int.parse(line["id"].toString()), name: line["name"].toString(), route: line["route"].toString());
    }catch(e){
      print(e);
      return null;
    }
  }

  @override
  Future<bool> insert(ForbFolder item) async {
    try{
      var res = await SQLiteUtils.db.insert('forbFolders', {
        'name':item.name,
        'route':item.route
      });
      return res==1;
    }catch(e){
      print(e);
      return false;
    }
  }

  @override
  Future<List<ForbFolder>> list() async {
    List<ForbFolder> list = [];
    try{
      var res = await SQLiteUtils.db.query('forbFolders');
      for (var line in res){
        list.add(ForbFolder(id: int.parse(line["id"].toString()), name: line["name"].toString(), route: line["route"].toString()));
      }
    }catch(e){
      print(e);
    }
    return list;
  }

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
      print(e);
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