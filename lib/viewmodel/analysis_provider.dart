import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

///Provider del apartado de análisis de ficheros
class AnalysisProvider extends ChangeNotifier {
  ///Estado del "hilo"
  ///
  ///Marca si el análisis de archivos sigue siendo ejecutado o no
  bool isIsolateActive = false;

  void setIsolateActive(bool value) {
    isIsolateActive = value;
    notifyListeners();
  }
}
