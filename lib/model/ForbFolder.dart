class ForbFolder {
  int id;
  String name;
  String route;

  ForbFolder({required this.id, required this.name, required this.route});
}
/*
    CREATE TABLE IF NOT EXISTS forbFolders(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT,
      route TEXT
    );
    */