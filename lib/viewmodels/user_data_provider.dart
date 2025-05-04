import 'dart:io';

import 'package:flutter/material.dart';
import 'package:magik_antivirus/data_access/device_dao.dart';
import 'package:magik_antivirus/data_access/forbidden_folders_dao.dart';
import 'package:magik_antivirus/data_access/user_dao.dart';
import 'package:magik_antivirus/model/device.dart';
import 'package:magik_antivirus/model/file.dart';
import 'package:magik_antivirus/model/forbidden_folder.dart';
import 'package:magik_antivirus/model/user.dart';
import 'package:magik_antivirus/utils/app_essentials.dart';
import 'package:magik_antivirus/utils/database_utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

///Provider de la aplicación, que guarda datos que van mutando a lo largo de la aplicación y se comparten entre varias vistas.
class UserDataProvider extends ChangeNotifier {
  ///Booleana que sirve para marcar si la aplicación se encuentra cargando los assets principales o no
  ///Cuando carga toda la información que necesita, se convierte en true y deja paso al procesamiento del resto de la aplicación.

  bool assetsLoaded = false;

  int loadingStatus = 0;

  ///Función de carga de todos los datos de la aplicación
  void loadAssets() async {
    //Carga de la Base de Datos
    await SQLiteUtils.cargardb();
    await SQLiteUtils.startDB();

    //Carga de las firmas de la API
    loadingStatus ++;
    notifyListeners();
    await AppEssentials.loadSigs();
    loadingStatus ++;
    notifyListeners();
    Directory dir = Directory(join(
        (await getApplicationDocumentsDirectory()).path, "MagikAV", "MyFiles"));
    if (!dir.existsSync()) {
      dir.createSync(recursive: true);
    }
    AppEssentials.quarantineDirectory = dir;
    loadingStatus++;
    notifyListeners();
await AppEssentials.registerThisDevice();
if (AppEssentials.dev!.user != null) {
  User? u = (await UserDAO().get(AppEssentials.dev!.user!));
  if (u != null) {
    changeUser(u);
  }
}
    assetsLoaded = true;
    notifyListeners();
  }

  ///Usuario de la aplicación, empezando por el usuario guardado en las preferencias
  User? thisUser;

  ///Función de cambio de usuario
  ///
  ///Además, guarda el email de usuario y una booleana que marca que se inicie sesión de forma automática
  void changeUser(User user) {
    thisUser = user;
    notifyListeners();
  }

  ///Lista de directorios prohibidos
  List<ForbFolder> fFoldersList = [];

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
    for (Device d in await AppEssentials.getDevicesList(u)) {
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

  List<QuarantinedFile> selectedFiles = [];

  ///Función de adición de archivos a la lista de seleccionados
  void addIntoFiles(QuarantinedFile file) {
    selectedFiles.add(file);
    notifyListeners();
  }

  ///Función de borrado de archivos de la lista de seleccionados
  void removeFromFiles(QuarantinedFile file) {
    selectedFiles.remove(file);
    notifyListeners();
  }

  ///Función de borrado de todos los archivos seleccionados
  void removeAllFiles() {
    selectedFiles.clear();
    notifyListeners();
  }
}
