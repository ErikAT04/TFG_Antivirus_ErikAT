///La clase ForbFolder o ForbiddenFolder hace referencia a los llamados 'Directorios Prohibidos' de la App
///Son aquellos que el usuario ha negado acceso por diversos motivos. La aplicación no pasará por estas carpetas
class ForbFolder {
  ///Identificador
  int id;
  ///Nombre de la carpeta
  String name;
  ///Ruta de la carpeta
  String route;

  ///Constructor
  ForbFolder({required this.id, required this.name, required this.route});
}
/*
    CREATE TABLE IF NOT EXISTS forbFolders(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT,
      route TEXT
    );
    */