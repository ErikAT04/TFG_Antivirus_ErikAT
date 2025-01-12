import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

///Vista de la versión de la aplicación
class AboutView extends StatefulWidget {
  const AboutView({super.key, required this.language});

  final String language;

  @override
  State<AboutView> createState() => AboutViewState(language: this.language);
}

class AboutViewState extends State<AboutView> {

  AboutViewState({required this.language});

  ///Todo lo que es la pantalla principal carga de un archivo Markdown que cambia según el idioma
  String language;

  String? data;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    rootBundle.loadString("assets/changelogs/log_$language.md").then((value){
      setState(() {
        data = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ExcludeSemantics(child: Text(AppLocalizations.of(context)!.appVer)),
      ),
      body: ExcludeSemantics(child: Column(
        children: [
          Center(child: Text("Magik Antivirus", style: TextStyle(fontSize: 30),)),
          (data!=null)?
          Expanded(child: Markdown(data: data!)):
          Padding(padding: EdgeInsets.all(0))
        ],
      )),
    );
  }
}