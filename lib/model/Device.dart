///La clase Device guarda los dispositivos de los usuarios
class Device {
  ///Identificador de cada dispositivo en la base de datos (Su dirección MAC)
  String? id;
  ///Nombre con el que se registró
  String name;
  ///El tipo se refiere al sistema operativo que corre el dispositivo (Android, iOS, macOS, Windows o Linux)
  String type;
  ///Fecha en la que se registró el dispositivo
  DateTime join_in;
  ///Última fecha en la que el dispositivo ha realizado un escaneo
  DateTime last_scan;

  ///Constructor
  Device({this.id, required this.name, required this.type, required this.join_in, required this.last_scan});
}