import 'package:magik_antivirus/DataAccess/DAOInterfaces.dart';
import 'package:magik_antivirus/model/User.dart';
///Clase que lleva todo lo relacionado a las operaciones CRUD de los dispositivos
///La información de esta se hace por medio de la base de datos de MySQL, ya que se guarda en un servidor en red que gestiona a cada usuario y sus dispositivos
class UserDAO implements DAOInterface<User, String>{
  @override
  Future<bool> delete(User item) async {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<User?> get(String value) async {
    // TODO: implement get
    throw UnimplementedError();
  }

  @override
  Future<bool> insert(User item) async {
    // TODO: implement insert
    throw UnimplementedError();
  }

  @override
  Future<List<User>> list() async {
    // TODO: implement list
    throw UnimplementedError();
  }

  @override
  Future<bool> update(User item) async {
    // TODO: implement update
    throw UnimplementedError();
  }

}