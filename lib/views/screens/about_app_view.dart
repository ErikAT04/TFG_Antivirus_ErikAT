import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:magik_antivirus/viewmodel/style_provider.dart';
import 'package:provider/provider.dart';

///Vista de la versión de la aplicación
class AboutView extends StatefulWidget {
  const AboutView({super.key, required this.language});

  ///Idioma a cargar
  final String language;

  @override
  State<AboutView> createState() => AboutViewState(language: language);
}

class AboutViewState extends State<AboutView> {
  ///Constructor de la vista
  ///
  ///Recibe el idioma a cargar por parámetro
  AboutViewState({required this.language});

  ///Todo lo que es la pantalla principal carga de un archivo Markdown que cambia según el idioma
  String language;

  ///String que guarda toda la información del archivo markdown a cargar
  String? data;

  ///Inicio del estado de la vista
  ///
  ///Por medio de la clase rootbundle, accede a los assets y carga la información del markdown con el idioma elegido
  @override
  void initState() {
    super.initState();
    rootBundle.loadString("assets/changelogs/log_$language.md").then((value) {
      setState(() {
        data = value;
      });
    });
  }

  ///Construcción de la vista.
  ///
  ///El usuario verá una pantalla con el nombre de la aplicación, y los cambios de la aplicación.
  ///
  ///Esos cambios se verán en el idioma seleccionado en la aplicación.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        bottom: PreferredSize(
            preferredSize: Size.fromHeight(4),
            child: Container(
              color: context.watch<StyleProvider>().palette[
                  (context.watch<StyleProvider>().isLightModeActive)
                      ? "appMain"
                      : "appLight"],
              height: 1,
            )),
        title:
            ExcludeSemantics(child: Text(AppLocalizations.of(context)!.appVer)),
      ),
      body: ExcludeSemantics(
          child: Column(
        children: [
          Center(
              child: Text(
            "Magik Antivirus",
            style: TextStyle(fontSize: 30),
          )),
          (data != null)
              ? Expanded(child: Markdown(data: data!))
              : Padding(padding: EdgeInsets.all(0))
        ],
      )),
    );
  }
}
