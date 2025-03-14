import 'dart:io';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:magik_antivirus/data_access/device_dao.dart';
import 'package:magik_antivirus/data_access/forbidden_folders_dao.dart';
import 'package:magik_antivirus/utils/app_essentials.dart';
import 'package:permission_handler/permission_handler.dart';

///Provider del apartado de análisis de ficheros
class AnalysisProvider extends ChangeNotifier {
  ///Estado del "hilo"
  ///
  ///Marca si el análisis de archivos sigue siendo ejecutado o no
  bool isIsolateActive = false;

  ///Función de análisis de archivos
  ///
  ///En esta versión de prueba, comienza con pedir el permiso de acceder a los ficheros al usuario si fuera necesario
  ///
  ///Si este acepta, recorrerá los archivos del dispositivo.
  ///
  ///Al estar en el notifier y ser una función asíncrona, es posible hacer otras tareas en el equipo mientras esta se lleva a cabo
  void analizarArchivos() async {
    isIsolateActive = true;
    notifyListeners();
    Set<String> folders =
        (await ForbFolderDAO().list()).map((folder) => folder.route).toSet();

    String mainDirectory = (Platform.isAndroid)
        ? "/storage/emulated/0"
        : (Platform.isWindows)
            ? "C:\\"
            : "/";
    if (Platform.isAndroid) {
      // Verificar el estado del permiso
      if (await Permission.manageExternalStorage.status.isGranted) {
        // Permiso ya concedido
        Logger().d("Permiso ya concedido");

        await AppEssentials.scanDir(Directory(mainDirectory), folders);

        AppEssentials.dev!.last_scan = DateTime.now();
        await DeviceDAO().update(AppEssentials.dev!);
        isIsolateActive = false;
        notifyListeners();
      } else {
        // Solicitar permiso
        Logger().d("Solicitando permiso de almacenamiento...");
        if (await Permission.manageExternalStorage.request().isGranted) {
          // Permiso concedido
          Logger().d("Permiso concedido");
          analizarArchivos();
        } else {
          // Permiso denegado
          Logger().d("Permiso denegado");
          isIsolateActive = false;
          notifyListeners();
        }
      }
    } else {
      await AppEssentials.scanDir(Directory(mainDirectory), folders);

      AppEssentials.dev!.last_scan = DateTime.now();
      await DeviceDAO().update(AppEssentials.dev!);
      isIsolateActive = false;
      notifyListeners();
    }
  }
}
