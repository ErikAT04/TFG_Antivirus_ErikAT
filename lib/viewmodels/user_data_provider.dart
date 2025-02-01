import 'package:flutter/material.dart';
import 'package:magik_antivirus/data_access/device_dao.dart';
import 'package:magik_antivirus/data_access/forbidden_folders_dao.dart';
import 'package:magik_antivirus/data_access/user_dao.dart';
import 'package:magik_antivirus/model/device.dart';
import 'package:magik_antivirus/model/forbidden_folder.dart';
import 'package:magik_antivirus/model/user.dart';
import 'package:magik_antivirus/utils/app_essentials.dart';

///Provider de la aplicación, que guarda datos que van mutando a lo largo de la aplicación y se comparten entre varias vistas.
class UserDataProvider extends ChangeNotifier {

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
