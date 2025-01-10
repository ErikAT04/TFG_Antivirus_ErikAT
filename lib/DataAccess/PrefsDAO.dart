import 'package:magik_antivirus/model/Prefs.dart';
import 'package:magik_antivirus/utils/DBUtils.dart';
import 'package:magik_antivirus/DataAccess/DAOInterfaces.dart';

///Clase que lleva todo lo relacionado a las operaciones CRUD de las preferencias del usuario
///
///La información de esta se hace por medio de la base de datos de SQLite, ya que se guarda en local, y solo hay una ocurrencia en toda la tabla
class PrefsDAO implements DAOInterface<Preferences, String> {
  ///Función de borrado (Actualmente sin uso)
  ///
  ///Recibe un objeto de tipo Preferences y lo borra de la BD
  @override
  Future<bool> delete(Preferences item) async {
    try {
      var res = await SQLiteUtils.db.delete('preferences');
      return res == 1;
    } catch (e) {
      print(e);
      return false;
    }
  }

  ///Función de obtención:
  ///
  ///Devuelve la preferencias actuales de la BD
  @override
  Future<Preferences?> get(String value) async {
    Preferences? prefs = null;
    try {
      var map = (await SQLiteUtils.db.query('preferences')).first;
      prefs = Preferences(
          isUserRegistered: map['isUserRegistered'].toString() == "1",
          uname: map['userName'].toString(),
          upass: map['userPass'].toString(),
          lang: map['chosenLang'].toString(),
          isAutoTheme:
              map['isAutoThemeMode'].toString().toLowerCase() == "true",
          themeMode: map["themeMode"].toString());
    } catch (e) {
      print(e);
    }
    return prefs;
  }

  ///Función de inserción (Sin uso actualmente)
  ///
  ///Recibe un grupo de preferencias por parámetro y las inserta en la BD
  @override
  Future<bool> insert(Preferences item) async {
    try {
      var res = await SQLiteUtils.db.update('preferences', {
        "isUserRegistered": (item.isUserRegistered) ? 1 : 0,
        "userName": item.uname,
        "userPass": item.upass,
        "chosenLang": item.lang,
        "isAutoThemeMode": (item.isAutoTheme) ? 1 : 0,
        "themeMode": item.themeMode
      });
      return res == 1;
    } catch (e) {
      print(e);
      return false;
    }
  }

  ///Función de listado (Sin uso actualmente)
  ///
  ///Devuelve una lista de preferencias
  @override
  Future<List<Preferences>> list() async {
    List<Preferences> prefs = [];
    try {
      (await SQLiteUtils.db.query('preferences')).forEach((map) {
        prefs.add(Preferences(
            isUserRegistered: map['isUserRegistered'].toString() == "1",
            uname: map['userName'].toString(),
            upass: map['userPass'].toString(),
            lang: map['chosenLang'].toString(),
            isAutoTheme:
                map['isAutoThemeMode'].toString().toLowerCase() == "true",
            themeMode: map["themeMode"].toString()));
      });
    } catch (e) {
      print(e);
    }
    return prefs;
  }

  ///Función de actualización
  ///
  ///Recibe un objeto de Preferences por parámetro y modifica la BD con su información
  @override
  Future<bool> update(Preferences item) async {
    try {
      var res = await SQLiteUtils.db.update('preferences', {
        "isUserRegistered": (item.isUserRegistered) ? 1 : 0,
        "userName": item.uname,
        "userPass": item.upass,
        "chosenLang": item.lang,
        "isAutoThemeMode": (item.isAutoTheme) ? 1 : 0,
        "themeMode": item.themeMode
      });
      return res == 1;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
