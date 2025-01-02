import 'package:magik_antivirus/DataAccess/DAOInterfaces.dart';
import 'package:magik_antivirus/model/ForbFolder.dart';
///Clase que lleva todo lo relacionado a las operaciones CRUD de los ficheros a los que no se tiene acceso
///La información de esta se hace por medio de la base de datos de SQLite, ya que se guarda en local
class ForbFolderDAO implements DAOInterface<ForbFolder, int>{
  @override
  Future<bool> delete(ForbFolder item) async {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<ForbFolder?> get(int value) async {
    // TODO: implement get
    throw UnimplementedError();
  }

  @override
  Future<bool> insert(ForbFolder item) async {
    // TODO: implement insert
    throw UnimplementedError();
  }

  @override
  Future<List<ForbFolder>> list() async {
    // TODO: implement list
    throw UnimplementedError();
  }

  @override
  Future<bool> update(ForbFolder item) async {
    // TODO: implement update
    throw UnimplementedError();
  }

}