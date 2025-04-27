import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:magik_antivirus/viewmodels/analysis_provider.dart';
import 'package:magik_antivirus/viewmodels/style_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

///Vista del análisis
class AnalysisView extends StatefulWidget {
  const AnalysisView({super.key});

  @override
  State<AnalysisView> createState() => AnalysisViewState();
}

///Estado de la vista Análisis:
class AnalysisViewState extends State<AnalysisView> {
  ///Booleana que marca si la ventana se encuentra haciendo algo en ese momento

  ///String que informa al usuario del estado de su escaneo (Actualmente sin uso)

  ///El usuario de primeras verá un botón grande donde pone 'Analizar'.
  ///
  ///Una vez le dé a este botón, el programa empezará a escanear todos los archivos del equipo en el que se encuentre, empezando desde la raíz del sistema de ficheros.
  ///
  ///Para hacer más amena la espera al usuario, éste verá un círculo girando y un texto que avisa de qué parte del proceso está llevando a cabo el programa.
  ///
  ///Además decir que se puede abandonar esta pestaña sin ningún problema, ya que no afectará al funcionamiento del análisis
  @override
  Widget build(BuildContext context) {
    bool isActive = context.watch<AnalysisProvider>().isIsolateActive;
    if (!isActive) {
      return Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 150,
            height: 150,
            child: ElevatedButton(
              onPressed: () {
                scan(null);
              },
              child: MergeSemantics(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.shield, size: 30),
                    Text(AppLocalizations.of(context)!.analyse),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          Container(
            width: 200,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: context.watch<StyleProvider>().colorsMap[
                    (context.watch<StyleProvider>().isLightModeActive)
                        ? "appDark"
                        : "white"],
                foregroundColor: context.watch<StyleProvider>().colorsMap[
                    (context.watch<StyleProvider>().isLightModeActive)
                        ? "white"
                        : "appDark"],
              ),
              onPressed: () async {
                String? path = await FilePicker.platform.getDirectoryPath();
                if (path != null) {
                  scan(path);
                }
              },
              child: MergeSemantics(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.analyseOneFolderBtt,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ));
    } else {
      return Center(
        child: ExcludeSemantics(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            Text(
                "${AppLocalizations.of(context)!.pleaseWait}\n${AppLocalizations.of(context)!.mightTakeaWhile}")
          ],
        )),
      );
    }
  }

  ///Función de escaneo de ficheros del dispositivo
  ///
  ///Si necesita algún tipo de permiso del SO, lo pide (Permissions plugin)
  void scan(String? path) async {
    context.read<AnalysisProvider>().analizarArchivos(path);
  }
}
