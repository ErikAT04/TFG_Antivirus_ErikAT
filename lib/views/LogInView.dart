import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import 'package:magik_antivirus/utils/AppEssentials.dart';
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
                  onPressed: () {},
                  child: Text(AppLocalizations.of(context)!.logIn)),
              Padding(padding: EdgeInsets.all(5)),
              ElevatedButton(
                  onPressed: () {},
                  child: Text(AppLocalizations.of(context)!.signUp)),
                  Padding(padding: EdgeInsets.all(5)),
            ],
          ),
        ),
        DropdownButton(
            items: [
              DropdownMenuItem(
                child: CountryFlag.fromCountryCode("ES"),
                value: "es",
              ),
              DropdownMenuItem(
                child: CountryFlag.fromCountryCode("US"),
                value: "en",
              ),
              DropdownMenuItem(
                child: CountryFlag.fromCountryCode("DE"),
                value: "de",
              ),
              DropdownMenuItem(
                child: CountryFlag.fromCountryCode("FR"),
                value: "fr",
              )
            ],
            value: context.watch<MainAppProvider>().language.languageCode,
            onChanged: (value) {
              context.read<MainAppProvider>().changeLang(value!);
            }),
        Switch(value: context.watch<MainAppProvider>().theme == AppEssentials.darkMode, onChanged: (value){
          context.read<MainAppProvider>().changeTheme(value);
        })
      ])
    );
  }
}


/*
Builder(builder: (context) {
            return GestureDetector(
              child: Icon(Icons.menu),
              onTap: () {
                Scaffold.of(context).openDrawer();
              },
            );
          })
          */