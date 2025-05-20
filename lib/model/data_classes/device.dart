import 'package:magik_antivirus/model/interfaces/api_content.dart';

///La clase Device guarda los dispositivos de los usuarios
class Device implements APIContent {
  ///Identificador de cada dispositivo en la base de datos (El identificador dependerá del dispositivo)
  String? id;

  ///Nombre con el que se registró
  String devName;

  ///El tipo se refiere al sistema operativo que corre el dispositivo (android, ios, macos, windows o linux)
  String devType;

  ///Fecha en la que se registró el dispositivo
  DateTime joinIn;

  ///Última fecha en la que el dispositivo ha realizado un escaneo
  DateTime lastScan;

  ///Correo electrónico del usuario del dispositivo
  ///
  ///Es posible que el dispositivo no tenga un usuario asignado
  String? user;

  ///Constructor
  Device(
      {this.id,
      required this.devName,
      required this.devType,
      required this.joinIn,
      required this.lastScan,
      this.user});

  @override
  Map<String, String?> toAPI() {
    return {
      'id': id.toString(),
      'dev_name': devName,
      'dev_type': devType,
      'join_in': joinIn.toString(),
      'last_scan': lastScan.toString(),
      'user': user,
    };
  }

  @override
  void toItem(Map<String, String> map) {
    id = map["id"];
    devName = map["dev_name"]!;
    devType = map["dev_type"]!;
    joinIn = DateTime.parse(map["join_in"]!);
    lastScan = DateTime.parse(map["last_scan"]!);
    user = map["user"];
  }
}
