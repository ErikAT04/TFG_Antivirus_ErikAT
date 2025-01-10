import 'package:magik_antivirus/model/User.dart';
import 'package:magik_antivirus/utils/DBUtils.dart';
import 'package:magik_antivirus/DataAccess/DAOInterfaces.dart';
///Clase que lleva todo lo relacionado a las operaciones CRUD de los dispositivos
///La información de esta se hace por medio de la base de datos de MySQL, ya que se guarda en un servidor en red que gestiona a cada usuario y sus dispositivos
class UserDAO implements DAOInterface<User, String>{
  ///Función de borrado
  ///
  ///Recibe un usuario y lo borra por su email
  @override
  Future<bool> delete(User item) async {
    try{
      var res = await MySQLUtils.connection.execute('DELETE FROM user WHERE email LIKE "${item.email}"');
      return res.affectedRows.toInt() == 1;
    }catch(e){
      print(e);
      return false;
    }
  }
  ///Función de obtención
  ///
  ///Recibe un email y busca el usuario que tenga dicho email
  @override
  Future<User?> get(String value) async {
    User? user = null;
    try{
      var res = await MySQLUtils.connection.execute("SELECT * FROM user WHERE email LIKE '${value}' OR username LIKE '${value}'");
      var line = res.rows.first;
      print(line.colAt(3));
      user = User(uname: line.colAt(1)!, pass: line.colAt(2)!, email: line.colAt(0)!, userIMGData: (line.colAt(3)!=null)? (line.colAt(3)!) : null);
    }catch(e){
      print(e);
    }
    return user;
  }
  ///Función de inserción
  ///
  ///Recibe un usuario y lo inserta en la base de datos
  @override
  Future<bool> insert(User item) async {
    try{
      var res = await MySQLUtils.connection.execute('INSERT INTO user(email, pass, username) VALUES ("${item.email}", "${item.pass}", "${item.uname}")');
      return res.affectedRows.toInt() == 1;
    }catch(e){
      print(e);
      return false;
    }
  }
  ///Función de listado
  ///
  ///Devuelve todos los usuarios de la base de datos (Sin uso actualmente)
  @override
  Future<List<User>> list() async {
    List<User> users = [];
    try{
      var res = await MySQLUtils.connection.execute('SELECT * FROM user');
      for (var line in res.rows){
        users.add(User(uname: line.colAt(1)!, pass: line.colAt(2)!, email: line.colAt(0)!, userIMGData: (line.colAt(3)!=null)? line.colAt(3) : null));
      }
    }catch(e){
      print(e);
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
    try{
      var res = await MySQLUtils.connection.execute('UPDATE user SET username = "${item.uname}", pass = "${item.pass}"${(item.userIMGData!=null)? ', image = "${item.userIMGData}"' : ""} where email LIKE "${item.email}"');
      return res.affectedRows.toInt() == 1;
    }catch(e){
      print(e);
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