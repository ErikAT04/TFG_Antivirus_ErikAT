import 'dart:convert' as convert;
import 'package:logger/logger.dart';
import 'package:magik_antivirus/model/user.dart';
import 'package:magik_antivirus/utils/database_utils.dart';
import 'package:magik_antivirus/data_access/dao_interfaces.dart';

///Clase que lleva todo lo relacionado a las operaciones CRUD de los dispositivos
///
///La información de esta se hace por medio de un servicio API REST conectado a una base de datos de MySQL, ya que se guarda en un servidor en red que gestiona a cada usuario y sus dispositivos
class UserDAO implements DAOInterface<User, String> {
  final routerUrl = "api/users";

  ///Función de borrado
  ///
  ///Recibe un usuario y lo borra por su email
  @override
  Future<bool> delete(User item) async {
    try {
      var uri = Uri.https(
          APIReaderUtils.apiRESTLink, "$routerUrl/${item.email}/remove");
      var body = await APIReaderUtils.deleteData(uri);
      return body == "Eliminado correctamente";
    } catch (e) {
      Logger().e(e);
      return false;
    }
  }

  ///Función de obtención
  ///
  ///Recibe un email y busca el usuario que tenga dicho email
  @override
  Future<User?> get(String value) async {
    try {
      var uri = Uri.https(APIReaderUtils.apiRESTLink, "$routerUrl/$value");
      var body = await APIReaderUtils.getData(uri);
      if (body != "Dispositivo no encontrado") {
        var map = convert.jsonDecode(body);
        return User(
            email: map["email"]!,
            username: map["username"]!,
            passwd: map["passwd"]!,
            image: map["image"]);
      } else {
        return null;
      }
    } catch (e) {
      Logger().e(e);
      return null;
    }
  }

  ///Función de inserción
  ///
  ///Recibe un usuario y lo inserta en la base de datos
  @override
  Future<bool> insert(User item) async {
    try {
      var uri = Uri.https(APIReaderUtils.apiRESTLink, "$routerUrl/insert");
      var body = await APIReaderUtils.postData(uri, item);
      return body == convert.jsonEncode(item.toAPI());
    } catch (e) {
      Logger().e(e);
      return false;
    }
  }

  ///Función de listado
  ///
  ///Devuelve todos los usuarios de la base de datos (Sin uso actualmente)
  @override
  Future<List<User>> list() async {
    List<User> users = [];
    try {
      var uri = Uri.https(APIReaderUtils.apiRESTLink, "$routerUrl/");
      var body = await APIReaderUtils.getData(uri);
      var mapList = convert.jsonDecode(body);
      for (var map in mapList) {
        users.add(User(
            email: map["email"]!,
            username: map["username"]!,
            passwd: map["passwd"]!,
            image: map["image"]));
      }
    } catch (e) {
      Logger().e(e);
    }
    return users;
  }

  ///Función de actualización
  ///
  ///Recibe un usuario por parámetros y modifica sus datos en función del email.
  ///
  ///Si la imagen del usuario es nula (No tiene imagen), no se intenta añadir ese parámetro
  @override
  Future<bool> update(User item) async {
    try {
      var uri = Uri.https(
          APIReaderUtils.apiRESTLink, "$routerUrl/${item.email}/update");
      Logger().d(uri.toString());
      var body = await APIReaderUtils.putData(uri, item);

      return body == convert.jsonEncode(item.toAPI());
    } catch (e) {
      Logger().e(e);
      return false;
    }
  }
}
/*
CREATE TABLE user(
  email VARCHAR(255) PRIMARY KEY,
  username VARCHAR(255) UNIQUE,
  pass VARCHAR(255) NOT NULL,
  image VARCHAR(255)
);
*/
