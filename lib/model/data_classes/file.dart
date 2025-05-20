///La clase QuarantinedFile hace referencia a los archivos que se registran en la base de datos local.
///
///Son todos aquellos que, por algún motivo de seguridad, han sido puestos en cuarentena.
class QuarantinedFile {
  ///Identificador del archivo
  int? id;

  ///Nombre del archivo antes de ser puesto en cuarentena
  String name;

  ///Ruta del archivo antes de ser puesto en cuarentena
  String route;

  ///Nombre del archivo en cuarentena
  String newName;

  ///Ruta del archivo en cuarentena
  String newRoute;

  ///Tipo de Malware encontrado
  String malwareType;

  ///Fecha de puesta en cuarentena
  DateTime quarantineDate;

  ///Constructor
  QuarantinedFile(
      {this.id,
      required this.name,
      required this.route,
      required this.newName,
      required this.newRoute,
      required this.malwareType,
      required this.quarantineDate});
}
