import 'package:magik_antivirus/model/Device.dart';
import 'package:magik_antivirus/utils/DBUtils.dart';
import 'package:magik_antivirus/DataAccess/DAOInterfaces.dart';
///Clase que lleva todo lo relacionado a las operaciones CRUD de los dispositivos
///
///La información de esta se hace por medio de la base de datos de MySQL, ya que se guarda en un servidor en red que gestiona a cada usuario y sus dispositivos
class DeviceDAO implements DAOInterface<Device, String>{
  ///Función de borrado de dispositivos (Actualmente sin uso)
  ///
  ///Recibe un dispositivo por parámetro y lo borra de la BD
  @override
  Future<bool> delete(Device item) async {
    try{
      var res =  await MySQLUtils.connection.execute("DELETE FROM device WHERE id LIKE '${item.id}'");
      return res.affectedRows.toInt()==1;
    }catch(e){
      print(e);
      return false;
    }
  }

  ///Función de obtención de dispositivo
  ///
  ///Recibe una clave por parámetro y devuelve el dispositivo que encuentre en la BD
  @override
  Future<Device?> get(String value) async {
    try{
      var res = await MySQLUtils.connection.execute("SELECT * FROM device WHERE id LIKE '${value}'");
      var line = res.rows.first;
      return Device(name: line.colAt(1)!, type: line.colAt(2)!, join_in: DateTime.parse(line.colAt(4)!), last_scan: DateTime.parse(line.colAt(3)!), id: line.colAt(0), user: line.colAt(5));
    }catch(e){
      print(e);
      return null;
    }
  }

  ///Función de inserción de dispositivos
  ///
  ///Recibe un dispositivo por parámetro y lo inserta en la BD
  @override
  Future<bool> insert(Device item) async {
    try{
      var res = await MySQLUtils.connection.execute("INSERT INTO device(id, dev_name, dev_type, join_in, last_scan) values ('${item.id}', '${item.name}', '${item.type}', '${item.join_in}', '${item.last_scan}')");
      return res.affectedRows.toInt()==1;
    }catch(e){
      print(e);
      return false;
    }
  }

  ///Función de listado
  ///
  ///Devuelve una lista con todos los dispositivos de la BD
  @override
  Future<List<Device>> list() async {
    List<Device> list = [];
    try{
      var res = await MySQLUtils.connection.execute("SELECT * FROM device");
      for (var line in res.rows){
       list.add(Device(name: line.colAt(1)!, type: line.colAt(2)!, join_in: DateTime.parse(line.colAt(4)!), last_scan: DateTime.parse(line.colAt(3)!), id: line.colAt(0), user: line.colAt(5)));
      }
    }catch(e){
      print(e);
    }
    return list;
  }

  ///Función de actualización
  ///
  ///Recibe un dispositivo por parámetro y actualiza sus valores en la BD
  @override
  Future<bool> update(Device item) async {
    try{
      var res = await MySQLUtils.connection.execute("UPDATE device SET dev_name='${item.name}', dev_type='${item.type}', last_scan='${item.last_scan}', user=${(item.user!=null)?"'${item.user}'":"NULL"} WHERE id='${item.id}'");
      return res.affectedRows.toInt()==1;
    }catch(e){
      print(e);
      return false;
    }
  }
}