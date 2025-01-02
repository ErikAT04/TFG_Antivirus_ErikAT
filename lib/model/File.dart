///La clase SysFile hace referencia a los archivos del sistema que se registran en la base de datos.
///Son todos aquellos que, por algún motivo de seguridad, han sido puestos en cuarentena
class SysFile{
  ///Identificador del archivo
  int id;
  ///Nombre del archivo antes de ser puesto en cuarentena
  String name;
  ///Ruta del archivo antes de ser puesto en cuarentena
  String route;
  ///Nombre del archivo en cuarentena
  String newName;
  ///Ruta del archivo en cuarentena
  String newRoute;
  ///Tipo de Malware encontrado (WIP)
  String malwareType;
  ///Fecha de puesta en cuarentena
  DateTime quarantineDate;

  ///Constructor
  SysFile({required this.id, required this.name, required this.route, required this.newName, required this.newRoute, required this.malwareType, required this.quarantineDate});
}

/*
CREATE TABLE IF NOT EXISTS files(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT,
      route TEXT,
      newName TEXT,
      newRoute TEXT,
      malwareType TEXT,
      quarantineDate DATE
    );
*/