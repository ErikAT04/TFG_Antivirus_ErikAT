import 'dart:io';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:magik_antivirus/DataAccess/DeviceDAO.dart';
import 'package:magik_antivirus/DataAccess/ForbFolderDAO.dart';
import 'package:magik_antivirus/DataAccess/UserDAO.dart';
import 'package:magik_antivirus/model/Device.dart';
import 'package:magik_antivirus/model/ForbFolder.dart';
import 'package:magik_antivirus/model/User.dart';
import 'package:magik_antivirus/utils/AppEssentials.dart';
import 'package:permission_handler/permission_handler.dart';

///Provider de la aplicación, que guarda datos que van mutando a lo largo de la aplicación y se comparten entre varias vistas.
class MainAppProvider extends ChangeNotifier {
  ///Idioma de la aplicación, empezando en el idioma que haya guardado en las preferencias de la app
  Locale language = Locale(AppEssentials.chosenLocale);

  ///Usuario de la aplicación, empezando por el usuario guardado en las preferencias
  User? thisUser = AppEssentials.user;

  ///Función de cambio de usuario
  ///
  ///Además, guarda el email de usuario y una booleana que marca que se inicie sesión de forma automática
  void changeUser(User user) {
    thisUser = user;
    notifyListeners();
    AppEssentials.putUser(user);
  }

  ///Lista de directorios prohibidos
  List<ForbFolder> fFoldersList = [];

  ///Estado del "hilo"
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
    // Verificar el estado del permiso
    if (await Permission.manageExternalStorage.status.isGranted) {
      // Permiso ya concedido
      Logger().d("Permiso ya concedido");
      Set<String> folders =
          (await ForbFolderDAO().list()).map((folder) => folder.route).toSet();

      String mainDirectory = (Platform.isAndroid)
          ? "/storage/emulated/0"
          : (Platform.isWindows)
              ? "C:\\"
              : "/";

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
  }

  ///Función que sirve para cambiar el idioma de la aplicación
  ///
  ///Además de cambiar el idioma, guarda en las preferencias el idioma elegido
  void changeLang(String lang) {
    language = Locale(lang);
    notifyListeners();
    AppEssentials.changeLang(lang);
  }

  

  ///Función de borrado de directorios prohibidos
  ///
  ///Borra el archivo tanto de la lista actual como de la base de datos local
  void deleteThisFolder(ForbFolder folder) async {
    fFoldersList.remove(folder);
    await ForbFolderDAO().delete(folder);
    notifyListeners();
  }

  ///Función de cierre de sesión
  ///
  ///Además de cerrar sesión poniendo al usuario nulo, desmarca la booleana de auto registro y quita el usuario del dispositivo (Por si se va a usar más tarde)
  void logout() async {
    thisUser = null;
    AppEssentials.prefs.setBool("isUserRegistered", false);
    AppEssentials.dev!.user = null;
    await DeviceDAO().update(AppEssentials.dev!);
    notifyListeners();
  }

  ///Función de borrado de cuenta
  ///
  ///Se borra al usuario de la base de datos en red y luego se procede como en el cierre de sesión
  void erase() async {
    User u = thisUser!;
    //Todos los dispositivos asignados a este usuario tendrán un usuario nulo al borrar el usuario.
    for (Device d in await AppEssentials.getDevicesList()) {
      d.user = null;
      await DeviceDAO().update(d);
    }
    logout();
    await UserDAO().delete(u);
  }

  ///Función de recarga de los directorios prohibidos
  void reloadFFolders() async {
    fFoldersList = await ForbFolderDAO().list();
    notifyListeners();
  }
}
