import 'package:magik_antivirus/DataAccess/DAOInterfaces.dart';
import 'package:magik_antivirus/model/File.dart';

class FileDAO implements DAOInterface<SysFile, int>{
  @override
  Future<bool> delete(SysFile item) async {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<SysFile?> get(int value) async {
    // TODO: implement get
    throw UnimplementedError();
  }

  @override
  Future<bool> insert(SysFile item) async {
    // TODO: implement insert
    throw UnimplementedError();
  }

  @override
  Future<List<SysFile>> list() async {
    // TODO: implement list
    throw UnimplementedError();
  }

  @override
  Future<bool> update(SysFile item) async {
    // TODO: implement update
    throw UnimplementedError();
  }
}