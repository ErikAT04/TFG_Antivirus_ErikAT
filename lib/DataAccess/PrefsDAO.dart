import 'package:magik_antivirus/DataAccess/DAOInterfaces.dart';
import 'package:magik_antivirus/model/Prefs.dart';
import 'package:magik_antivirus/utils/DBUtils.dart';

class PrefsDAO implements DAOInterface<Preferences, String>{
  final db = SQLiteUtils.db;
  @override
  Future<bool> delete(Preferences item) async {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<Preferences?> get(String value) async {
    Preferences? prefs = null;
    try{
    var map = (await db.query('preferences')).first;
    /*isUserRegistered BOOLEAN,
      userName TEXT,
      userPass TEXT,
      chosenLang TEXT,
      isAutoThemeMode BOOLEAN,
      themeMode TEXT */
    prefs = Preferences(isUserRegistered: map['isUserRegistered'].toString().toLowerCase()=="true", uname: map['userName'].toString(), upass: map['userPass'].toString(), lang: map['chosenLang'].toString(), isAutoTheme: map['isAutoThemeMode'].toString().toLowerCase()=="true", themeMode: map["themeMode"].toString());
    }catch(e){
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
    // TODO: implement update
    throw UnimplementedError();
  }

}