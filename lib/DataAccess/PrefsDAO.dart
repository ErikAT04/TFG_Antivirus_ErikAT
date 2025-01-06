import 'package:magik_antivirus/DataAccess/DAOInterfaces.dart';
import 'package:magik_antivirus/model/Prefs.dart';
import 'package:magik_antivirus/utils/DBUtils.dart';

///Clase que lleva todo lo relacionado a las operaciones CRUD de las preferencias del usuario
///La información de esta se hace por medio de la base de datos de SQLite, ya que se guarda en local
class PrefsDAO implements DAOInterface<Preferences, String> {
  final db = SQLiteUtils.db;
  @override
  Future<bool> delete(Preferences item) async {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<Preferences?> get(String value) async {
    Preferences? prefs = null;
    try {
      var map = (await db.query('preferences')).first;
      /*isUserRegistered BOOLEAN,
      userName TEXT,
      userPass TEXT,
      chosenLang TEXT,
      isAutoThemeMode BOOLEAN,
      themeMode TEXT */
      prefs = Preferences(
          isUserRegistered:map['isUserRegistered'].toString() == "1",
          uname: map['userName'].toString(),
          upass: map['userPass'].toString(),
          lang: map['chosenLang'].toString(),
          isAutoTheme:map['isAutoThemeMode'].toString() == "1",
          themeMode: map["themeMode"].toString());
    } catch (e) {
      print(e);
    }
    return prefs;
  }

  @override
  Future<bool> insert(Preferences item) async {
    // TODO: implement insert
    throw UnimplementedError();
  }

  @override
  Future<List<Preferences>> list() async {
    // TODO: implement list
    throw UnimplementedError();
  }

  @override
  Future<bool> update(Preferences item) async {
    try {
      var res = await db.update('preferences', {
        "isUserRegistered": (item.isUserRegistered)? 1:0,
        "userName": item.uname,
        "userPass": item.upass,
        "chosenLang": item.lang,
        "isAutoThemeMode" : (item.isAutoTheme)?1:0,
        "themeMode" : item.themeMode
      });
      return res == 1;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
