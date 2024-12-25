import 'package:magik_antivirus/DataAccess/DAOInterfaces.dart';
import 'package:magik_antivirus/model/User.dart';

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