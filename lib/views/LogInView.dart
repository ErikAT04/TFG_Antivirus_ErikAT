import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import 'package:magik_antivirus/utils/AppEssentials.dart';
import 'package:magik_antivirus/views/MainView.dart';
import 'package:provider/provider.dart';
import 'package:magik_antivirus/main.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LogInView extends StatefulWidget {
  const LogInView({super.key});

  @override
  State<LogInView> createState() => LogInViewState();
}

class LogInViewState extends State<LogInView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppEssentials.colorsMap["appMainBlue"],
      appBar: AppBar(
          title: Center(
              child: Text(
        AppLocalizations.of(context)!.logIn),
      )),
      body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Card(
          child: Column(
            children: [
              Padding(padding: EdgeInsets.all(5)),
              Text(AppLocalizations.of(context)!.putCredentials, style: TextStyle(fontSize: 16),),
              Container(
                  margin: EdgeInsets.all(10),
                  child: TextField(
                      decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.user,
                  ))),
              Container(
                  margin: EdgeInsets.all(10),
                  child: TextField(
                    decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!.pass),
                  )),
              ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Mainview()));
                  },
                  child: Text(AppLocalizations.of(context)!.logIn)),
              Padding(padding: EdgeInsets.all(5)),
              ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Mainview()));
                  },
                  child: Text(AppLocalizations.of(context)!.signUp)),
                  Padding(padding: EdgeInsets.all(5)),
            ],
          ),
        ),
      ])
    );
  }
}