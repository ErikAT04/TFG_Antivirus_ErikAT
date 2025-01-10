import 'package:logger/logger.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:magik_antivirus/main.dart';
import 'package:magik_antivirus/utils/AppEssentials.dart';
import 'package:magik_antivirus/DataAccess/DeviceDAO.dart';
import 'package:permission_handler/permission_handler.dart';
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
    bool isActive = context.watch<MainAppProvider>().isIsolateActive;
    String state = context.watch<MainAppProvider>().estado;
    if (!isActive) {
      return Center(
        child: Container(
          width: 150,
          height: 150,
          child: ElevatedButton(
            onPressed: () {
              scan();
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.shield, size: 30),
                Text(AppLocalizations.of(context)!.analyse),
              ],
            ),
          ),
        ),
      );
    } else {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [CircularProgressIndicator(), Text(state)],
        ),
      );
    }
  }

  ///Función de escaneo de ficheros del dispositivo
  ///
  ///Si necesita algún tipo de permiso del SO, lo pide (Permissions plugin)
  void scan() async {
    context.read<MainAppProvider>().prueba();
    /*
    setState(() {
      isActive = true;
    });
    // Verificar el estado del permiso
    if (await Permission.manageExternalStorage.status.isGranted) {
      // Permiso ya concedido
      Logger().d("Permiso concedido");
      await AppEssentials.pruebaAnalisisArchivos();
      AppEssentials.dev!.last_scan = DateTime.now();
      await DeviceDAO().update(AppEssentials.dev!);
    } else {
      // Solicitar permiso
      print("Solicitando permiso de almacenamiento...");
      if (await Permission.manageExternalStorage.request().isGranted) {
        // Permiso concedido
        Logger().d("Permiso concedido");
        await AppEssentials.pruebaAnalisisArchivos();
        AppEssentials.dev!.last_scan = DateTime.now();
        await DeviceDAO().update(AppEssentials.dev!);
      } else {
        // Permiso denegado
        Logger().d("Permiso denegado");
      }
    }
    await Future.delayed(Duration(seconds: 10));
    setState(() {
      isActive = false;
    });
    */
  }
}
