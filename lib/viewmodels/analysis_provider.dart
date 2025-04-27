import 'dart:io';
import 'package:flutter/foundation.dart';
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

  var numThreads = 0;

  var finishedThreads = 0;

  List<String> folders = [];

  ///Función de análisis de archivos
  ///
  ///En esta versión de prueba, comienza con pedir el permiso de acceder a los ficheros al usuario si fuera necesario
  ///
  ///Si este acepta, recorrerá los archivos del dispositivo.
  ///
  ///Al estar en el notifier y ser una función asíncrona, es posible hacer otras tareas en el equipo mientras esta se lleva a cabo
  void analizarArchivos(String? custom_dir) async {
    isIsolateActive = true;
    notifyListeners();
    folders =
        (await ForbFolderDAO().list()).map((folder) => folder.route).toList();
    if (Platform.isAndroid) {
      // Verificar el estado del permiso
      if (await Permission.manageExternalStorage.status.isGranted) {
        // Permiso ya concedido
        Logger().d("Permiso ya concedido");

        startAnalysis(custom_dir);

        AppEssentials.dev!.last_scan = DateTime.now();
        await DeviceDAO().update(AppEssentials.dev!);
      } else {
        // Solicitar permiso
        Logger().d("Solicitando permiso de almacenamiento...");
        if (await Permission.manageExternalStorage.request().isGranted) {
          // Permiso concedido
          Logger().d("Permiso concedido");
          analizarArchivos(custom_dir);
        } else {
          // Permiso denegado
          Logger().d("Permiso denegado");
          isIsolateActive = false;
          notifyListeners();
        }
      }
    } else {
      startAnalysis(custom_dir);

      AppEssentials.dev!.last_scan = DateTime.now();
      await DeviceDAO().update(AppEssentials.dev!);
    }
  }

  void checkIsolatesFinished() {
    isIsolateActive = numThreads > finishedThreads;
    notifyListeners();
  }

  void startAnalysis(String? custom_dir) async {
    List<Directory> dirs = [];

    var filesInRoot =
        Directory(custom_dir ?? AppEssentials.mainDirectory).listSync();

    for (var f in filesInRoot) {
      if (f is Directory) {
        dirs.add(f);
      }
    }

    finishedThreads = 0;

    numThreads = dirs.length +
        1; // Tantos "hilos" como directorios haya +1 para el directorio raíz

    for (Directory d in dirs) {
      AppEssentials.scanDir(d, folders).then((_) {
        finishedThreads++;
        checkIsolatesFinished();
      }).catchError((e) {
        Logger().e("Error: $e");
        isIsolateActive = false;
        notifyListeners();
      });
    }

    for (var file in filesInRoot) {
      if (file is File) {
        await AppEssentials.scanFile(file);
      }
    }
    finishedThreads++;
    checkIsolatesFinished();
  }
}
