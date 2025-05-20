import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
// ignore: unnecessary_import
import 'package:flutter/rendering.dart';
import 'package:logger/logger.dart';
import 'package:magik_antivirus/model/data_access/device_dao.dart';
import 'package:magik_antivirus/model/utils/app_essentials.dart';
import 'package:magik_antivirus/model/utils/scan_isolate.dart';
import 'package:magik_antivirus/viewmodel/analysis_provider.dart';
import 'package:magik_antivirus/viewmodel/style_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

///Vista del análisis
class AnalysisView extends StatelessWidget {
  AnalysisView({super.key});

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
          SizedBox(
            width: 150,
            height: 150,
            child: ElevatedButton(
              onPressed: () {
                preAnalyse(null, context);
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
          SizedBox(
            width: 200,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: context.watch<StyleProvider>().palette[
                    (context.watch<StyleProvider>().isLightModeActive)
                        ? "appDark"
                        : "white"],
                foregroundColor: context.watch<StyleProvider>().palette[
                    (context.watch<StyleProvider>().isLightModeActive)
                        ? "white"
                        : "appDark"],
              ),
              onPressed: () async {
                String? path = await FilePicker.platform.getDirectoryPath();
                if (path != null) {
                  preAnalyse(path, context);
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
            SizedBox(height: 20),
            Text(
              "${AppLocalizations.of(context)!.pleaseWait}\n${AppLocalizations.of(context)!.mightTakeaWhile}",
              textAlign: TextAlign.center,
            ),
            ElevatedButton(
              onPressed: () {
                ScanIsolate.cancelScan(context);
              },
              child: Text(AppLocalizations.of(context)!.cancel),
            )
          ],
        )),
      );
    }
  }

  /*
  ---------------------------------------------------------------------------------------------
  Funciones
  ---------------------------------------------------------------------------------------------
  */

  ///Función de pre-análisis
  ///
  ///Comprueba si el usuario ha dado permisos a la aplicación para acceder a recursos externos
  /// - Si los ha recibido, se inicia el análisis
  /// - Si no los ha recibido, se vuelven a pedir
  /// - Si no son necesarios (todas las plataformas menos Android), se inicia el análisis directamente
  void preAnalyse(String? customDir, BuildContext context) async {
    context.read<AnalysisProvider>().setIsolateActive(true);
    if (Platform.isAndroid) {
      // Verificar el estado del permiso
      if (await Permission.manageExternalStorage.status.isGranted) {
        // Permiso ya concedido
        Logger().d("Permiso ya concedido");

        ScanIsolate.startAnalysis(customDir, context);

        AppEssentials.dev!.lastScan = DateTime.now();
        await DeviceDAO().update(AppEssentials.dev!);
      } else {
        // Solicitar permiso
        Logger().d("Solicitando permiso de almacenamiento...");
        if (await Permission.manageExternalStorage.request().isGranted) {
          // Permiso concedido
          Logger().d("Permiso concedido");
          ScanIsolate.startAnalysis(customDir, context);
        } else {
          // Permiso denegado
          Logger().d("Permiso denegado");
          context.read<AnalysisProvider>().isIsolateActive = false;
          context.read<AnalysisProvider>().setIsolateActive(false);
        }
      }
    } else {
      ScanIsolate.startAnalysis(customDir, context);

      AppEssentials.dev!.lastScan = DateTime.now();
      await DeviceDAO().update(AppEssentials.dev!);
    }
  }
}
