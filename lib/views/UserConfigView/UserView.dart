import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:magik_antivirus/main.dart';
import 'package:magik_antivirus/model/User.dart';
import 'package:magik_antivirus/views/LogInView.dart';
import 'package:magik_antivirus/widgets/Dialogs.dart';
import 'package:magik_antivirus/DataAccess/UserDAO.dart';
import 'package:magik_antivirus/utils/AppEssentials.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

///Vista de la gestión del usuario
///El usuario podrá ver todos sus datos: El nombre, email, su fecha de unión y el número de dispositivos conectados
///Aparte de esto, tiene una selección de botones para cambiar varios parámetros, como el nombre y la contraseña. La foto de perfil se puede cambiar si se pulsa en el icono de la imagen.
///Además de esos cambios, se puede cerrar sesión y borrar la cuenta con otros botones que se ven a continuación.
class UserView extends StatelessWidget {
  const UserView({super.key});

  @override
  Widget build(BuildContext context) {
    User u = context.watch<MainAppProvider>().thisUser!;
    return Scaffold(
      appBar: AppBar(
        title: Text(u.uname),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(10),
            color: AppEssentials.colorsMap["appMainLightBlue"],
            child: Row(
              spacing: 10,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                GestureDetector(
                    child: CircleAvatar(
                      backgroundImage: (u.userIMGData != null)
                          ? NetworkImage(u.userIMGData!)
                          : null,
                      radius: 60,
                    ),
                    onTap: () {
                      changeIMG(context, u);
                    }),
                Expanded(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(u.uname,
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold)),
                    Text(u.email),
                    Text(
                        "${AppLocalizations.of(context)!.userNumDevices} ${context.watch<MainAppProvider>().devList.length}"),
                  ],
                ))
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: () {
                    changeUserName(context);
                  },
                  child: Text(AppLocalizations.of(context)!.userCName)),
              ElevatedButton(
                  onPressed: () {
                    changeUserPass(context);
                  },
                  child: Text(AppLocalizations.of(context)!.userCPass)),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: () {
                    logOut(context);
                  },
                  child: Text(AppLocalizations.of(context)!.userLOut)),
              ElevatedButton(
                  onPressed: () {
                    eraseUser(context);
                  },
                  child: Text(AppLocalizations.of(context)!.userErase)),
            ],
          )
        ],
      ),
    );
  }

  ///Función de cambio de imagen:
  ///Abre un pop up con un textfield donde poner el url de la imagen
  ///Si recibe un url, cambia la imagen del usuario y de la aplicación
  void changeIMG(BuildContext context, User u) async {
    String? res = await showDialog(
        context: context, builder: (context) => ImageUploadContextDialog());
    if (res != null) {
      u.userIMGData = res;
      await UserDAO().update(u);
      context.read<MainAppProvider>().changeUser(u);
    }
  }

  ///Función de cambio de nombre de usuario:
  ///Abre un pop up con bloques de texto para confirmar el nuevo nombre de usuario.
  ///Si recibe del pop up el nombre de usuario correctamente, cambia los parámetros de éste.
  void changeUserPass(BuildContext context) async {
    String? newPass = await showDialog<String>(
        context: context, builder: (context) => ChangePasswordContextDialog());
    if (newPass != null) {
      context.read<MainAppProvider>().thisUser!.pass = newPass;
      await UserDAO().update(context.read<MainAppProvider>().thisUser!);
    }
  }

  ///Función de cambio de contraseña:
  ///Abre un pop up con bloques de texto para confirmar la nueva contraseña.
  ///Si recibe del pop up la nueva contraseña correctamente, cambia los parámetros del usuario
  void changeUserName(BuildContext context) async {
    String? newName = await showDialog<String>(
        context: context, builder: (context) => ChangeUserNameContextDialog());
    if (newName != null) {
      context.read<MainAppProvider>().thisUser!.uname = newName;
      await UserDAO().update(context.read<MainAppProvider>().thisUser!);
    }
  }

  ///Función de borrado de usuario:
  ///Abre un pop up donde el usuario elige si quiere o no borrar su cuenta
  ///Si elige que sí, se realizan las operaciones de borrado de cuenta
  void eraseUser(BuildContext context) async {
    bool? res = await showDialog<bool>(
        context: context, builder: (context) => EraseContextDialog());
    if (res != null && res) {
      Navigator.pop(context);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LogInView()));
      context.read<MainAppProvider>().erase();
    }
  }

  ///Función de cierre de sesión
  ///Es más simple que el resto, simplemente cambia los parámetros de las preferencias y vuelve al login (sin vuelta atrás)
  void logOut(BuildContext context) {
    Navigator.pop(context);
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LogInView()));
    context.read<MainAppProvider>().logout();
  }
}
