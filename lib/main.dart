import 'package:path/path.dart' as p;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:magik_antivirus/views/LogInView.dart';
import 'package:magik_antivirus/utils/AppEssentials.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (context)=>MainAppProvider(),
    child: MainApp(),
  ));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LogInView(),
    );
  }
}


class MainAppProvider extends ChangeNotifier {
  Map<String, String> mapaLenguaje = AppEssentials.mapaLenguaje[AppEssentials.getLang()]!;

  void changeLang(String lang){
    AppEssentials.changeLang(lang);
    mapaLenguaje = AppEssentials.mapaLenguaje[AppEssentials.getLang()]!;
    notifyListeners();
  }
}
