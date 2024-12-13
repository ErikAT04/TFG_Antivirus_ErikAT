import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:magik_antivirus/main.dart';

class LogInView extends StatefulWidget {
  const LogInView({super.key});
  
  @override
  State<LogInView> createState() => LogInViewState();
}

class LogInViewState extends State<LogInView> {

  late Map<String, String> lang;

  @override
  Widget build(BuildContext context) {
    lang = context.watch<MainAppProvider>().mapaLenguaje;
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text(lang["logIn"]!),),
      ),
      body: Center(
        child: Card(
          child: Column(
            children: [
              Text(lang["putCredentials"]!),
              Container(margin: EdgeInsets.all(10), child: TextField(decoration: InputDecoration(labelText: lang["userOrEmail"]),)),
              Container(margin: EdgeInsets.all(10), child: TextField(decoration: InputDecoration(labelText: lang["pass"]),)),
              TextButton(onPressed: (){}, child: Text(lang["logIn"]!)),
              TextButton(onPressed: (){}, child: Text(lang["signUp"]!))
            ],
          ),
        ),
      ),
    );
  }
}