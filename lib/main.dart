import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:magik_antivirus/utils/DBUtils.dart';
import 'package:provider/provider.dart';
import 'package:magik_antivirus/views/LogInView.dart';
import 'package:magik_antivirus/utils/AppEssentials.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  //await MySQLUtils.loadSQLDB();
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
      home: LogInView(),
    );
  }
}

class MainAppProvider extends ChangeNotifier {
  Locale language = Locale(AppEssentials.chosenLocale);

  ThemeData theme = AppEssentials.lightMode;
  

  void changeLang(String lang) {
    AppEssentials.changeLang(lang);
    language = Locale(AppEssentials.chosenLocale);
    notifyListeners();
  }
  
  void changeTheme(bool val){
    theme = val?AppEssentials.darkMode:AppEssentials.lightMode;
    notifyListeners();
  }
}
