import 'dart:io';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:magik_antivirus/DataAccess/ForbFolderDAO.dart';
import 'package:magik_antivirus/DataAccess/PrefsDAO.dart';
import 'package:magik_antivirus/DataAccess/UserDAO.dart';
import 'package:magik_antivirus/model/Device.dart';
import 'package:magik_antivirus/model/ForbFolder.dart';
import 'package:magik_antivirus/model/User.dart';
import 'package:magik_antivirus/utils/DBUtils.dart';
import 'package:magik_antivirus/views/MainView.dart';
import 'package:provider/provider.dart';
import 'package:magik_antivirus/views/LogInView.dart';
import 'package:magik_antivirus/utils/AppEssentials.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await MySQLUtils.loadSQLDB();
  await SQLiteUtils.cargardb();
  try{
  await AppEssentials.getProperties();
  }catch(e){
    await SQLiteUtils.startDB();
    await AppEssentials.getProperties();
  }
  runApp(ChangeNotifierProvider(
    create: (context) => MainAppProvider(),
    child: MainApp(),
  ));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate
      ],
      supportedLocales: AppEssentials.listLocales,
      locale: context.watch<MainAppProvider>().language,
      theme: context.watch<MainAppProvider>().theme,
      home: (context.watch<MainAppProvider>().thisUser==null)?LogInView():Mainview(), //Si no se carga un usuario por defecto, se va al inicio de sesión.
    );
  }
}

class MainAppProvider extends ChangeNotifier {
  Locale language = Locale(AppEssentials.chosenLocale);

  ThemeData theme = (AppEssentials.preferences.themeMode=="darkMode")?AppEssentials.darkMode:AppEssentials.lightMode;
  
  User? thisUser = AppEssentials.user;

  List<ForbFolder> fFoldersList = [];

  List<Device> devList = [];

  void changeLang(String lang) {
    language = Locale(lang);
    notifyListeners();
    AppEssentials.changeLang(lang);
  }
  
  void changeTheme(bool val){
    theme = val?AppEssentials.darkMode:AppEssentials.lightMode;
    AppEssentials.changeTheme(val);
    notifyListeners();
  }

  void changeUser(User user) {
    this.thisUser = user;
    AppEssentials.putUser(user);
    notifyListeners();
  }

  void deleteThisFolder(ForbFolder folder) async {
    fFoldersList.remove(folder);
    await ForbFolderDAO().delete(folder);
    notifyListeners();
  }

  void logout() async{
    thisUser = null;
    AppEssentials.preferences.isUserRegistered = false;
    await PrefsDAO().update(AppEssentials.preferences);
    notifyListeners();
  }

  void erase() async{
    await UserDAO().delete(thisUser!);
    logout();
  }
}
