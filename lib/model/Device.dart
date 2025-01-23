///La clase Device guarda los dispositivos de los usuarios
class Device {
  ///Identificador de cada dispositivo en la base de datos (El identificador dependerá del dispositivo)
  String? id;

  ///Nombre con el que se registró
  String dev_name;

  ///El tipo se refiere al sistema operativo que corre el dispositivo (android, ios, macos, windows o linux)
  String dev_type;

  ///Fecha en la que se registró el dispositivo
  DateTime join_in;

  ///Última fecha en la que el dispositivo ha realizado un escaneo
  DateTime last_scan;

  ///Correo electrónico del usuario del dispositivo
  ///
  ///Es posible que el dispositivo no tenga un usuario asignado
  String? user;

  ///Constructor
  Device(
      {this.id,
      required this.dev_name,
      required this.dev_type,
      required this.join_in,
      required this.last_scan,
      this.user});

  ///Mapeo de objeto a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'dev_name': dev_name,
      'dev_type': dev_type,
      'join_in': join_in.toString(), 
      'last_scan': last_scan.toString(),
      'user': user,
    };
  }
}
