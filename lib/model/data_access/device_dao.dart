import 'dart:convert' as convert;
import 'package:logger/logger.dart';
import 'package:magik_antivirus/model/data_classes/device.dart';
import 'package:magik_antivirus/model/utils/database_utils.dart';
import 'package:magik_antivirus/model/interfaces/dao_interfaces.dart';

///Clase que lleva todo lo relacionado a las operaciones CRUD de los dispositivos
///
///La información de esta se hace por medio de un servicio API REST conectado a una base de datos de MySQL, ya que se guarda en un servidor en red que gestiona a cada usuario y sus dispositivos
class DeviceDAO implements DAOInterface<Device, String> {
  ///URL del router de la API (en este caso, el router de dispositivos)
  final routerUrl = "api/devices";

  ///Función de borrado de dispositivos (Actualmente sin uso)
  ///
  ///Recibe un dispositivo por parámetro y lo borra de la BD
  @override
  Future<bool> delete(Device item) async {
    try {
      var uri = Uri.https(
          APIReaderUtils.apiRESTLink, "$routerUrl/${item.id!}/remove");
      var body = await APIReaderUtils.deleteData(uri);
      return body == "Eliminado correctamente";
    } catch (e) {
      Logger().e(e);
      return false;
    }
  }

  ///Función de obtención de dispositivo
  ///
  ///Recibe una clave por parámetro y devuelve el dispositivo que encuentre en la BD
  @override
  Future<Device?> get(String value) async {
    try {
      var uri = Uri.https(APIReaderUtils.apiRESTLink, "$routerUrl/${value}");
      var body = await APIReaderUtils.getData(uri);
      if (body != "Dispositivo no encontrado") {
        var map = convert.jsonDecode(body);
        return Device(
            id: value,
            devName: map["dev_name"]!,
            devType: map["dev_type"]!,
            joinIn: DateTime.parse(map["join_in"]!),
            lastScan: DateTime.parse(map["last_scan"]!),
            user: map["user"]);
      } else {
        return null;
      }
    } catch (e) {
      Logger().e(e);
      return null;
    }
  }

  ///Función de inserción de dispositivos
  ///
  ///Recibe un dispositivo por parámetro y lo inserta en la BD
  @override
  Future<bool> insert(Device item) async {
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
  ///Devuelve una lista con todos los dispositivos de la BD
  @override
  Future<List<Device>> list() async {
    List<Device> list = [];
    try {
      var uri = Uri.https(APIReaderUtils.apiRESTLink, "$routerUrl/");
      var body = await APIReaderUtils.getData(uri);
      var mapList = convert.jsonDecode(body);
      for (var map in mapList) {
        list.add(Device(
            id: map["id"],
            devName: map["dev_name"]!,
            devType: map["dev_type"]!,
            joinIn: DateTime.parse(map["join_in"]!),
            lastScan: DateTime.parse(map["last_scan"]!),
            user: map["user"]));
      }
    } catch (e) {
      Logger().e(e);
    }
    return list;
  }

  ///Función de actualización
  ///
  ///Recibe un dispositivo por parámetro y actualiza sus valores en la BD
  @override
  Future<bool> update(Device item) async {
    try {
      var uri = Uri.https(
          APIReaderUtils.apiRESTLink, "$routerUrl/${item.id!}/update");
      var body = await APIReaderUtils.putData(uri, item);
      return body == convert.jsonEncode(item.toAPI());
    } catch (e) {
      Logger().e(e);
      return false;
    }
  }
}
