class SysFile{
  int id;
  String name;
  String route;
  String newName;
  String newRoute;
  String malwareType;
  DateTime quarantineDate;

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