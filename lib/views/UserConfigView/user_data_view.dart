import 'package:flutter/material.dart';
import 'package:magik_antivirus/viewmodels/style_provider.dart';
import 'package:magik_antivirus/viewmodels/user_data_provider.dart';
import 'package:provider/provider.dart';
import 'package:magik_antivirus/model/user.dart';
import 'package:magik_antivirus/model/device.dart';
import 'package:magik_antivirus/views/login_view.dart';
import 'package:magik_antivirus/widgets/dialogs.dart';
import 'package:magik_antivirus/DataAccess/user_dao.dart';
import 'package:magik_antivirus/DataAccess/device_dao.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

///Vista de la gestión del usuario.
class UserView extends StatefulWidget {
  const UserView({super.key});

  @override
  State<UserView> createState() => UserViewState();
}

class UserViewState extends State<UserView> {
  ///Lista de dispositivos
  ///
  ///Sirve para mostrar la cantidad de dispositivos asociados a la cuenta
  List<Device> devs = [];

  ///Inicio del estado de la vista
  ///
  ///Carga la lista de dispositivos para mostrar la cantidad de éstos que el usuario tiene registrados en su cuenta.
  @override
  void initState() {
    super.initState();
    loadList();
  }

  ///El usuario podrá ver todos sus datos: El nombre, email, su fecha de unión y el número de dispositivos conectados.
  ///
  ///Aparte de esto, tiene una lista de opciones para cambiar varios parámetros, como el nombre y la contraseña. La foto de perfil se puede cambiar si se pulsa en el icono de la imagen.
  ///
  ///Además de esos cambios, se puede cerrar sesión y borrar la cuenta con otros botones que se ven a continuación.
  @override
  Widget build(BuildContext context) {
    User u = context.watch<UserDataProvider>().thisUser!;
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.userTile),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MergeSemantics(
              child: Container(
            padding: EdgeInsets.all(10),
            color: (context.watch<StyleProvider>().isLightModeActive)
                ? context.watch<StyleProvider>().colorsMap["grey"]
                : context.watch<StyleProvider>().colorsMap["appDark"],
            child: Row(
              spacing: 10,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Semantics(
                    label: AppLocalizations.of(context)!.userImg,
                    hint: AppLocalizations.of(context)!.userImgContext,
                    child: GestureDetector(
                        child: CircleAvatar(
                          backgroundImage:
                              (u.image != null) ? NetworkImage(u.image!) : null,
                          radius: 60,
                        ),
                        onTap: () {
                          changeIMG(context, u);
                        })),
                Expanded(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(u.username,
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold)),
                    Text(u.email),
                    Text(
                        "${AppLocalizations.of(context)!.userNumDevices} ${devs.length}"),
                  ],
                ))
              ],
            ),
          )),
          Expanded(
              child: ListView(
            children: [
              Semantics(
                label: AppLocalizations.of(context)!.userCName,
                hint: AppLocalizations.of(context)!.userCNameContext,
                child: GestureDetector(
                    onTap: () {
                      changeUserName(context);
                    },
                    child: ListTile(
                      leading: Icon(Icons.text_format),
                      title: Text(AppLocalizations.of(context)!.userCName),
                      subtitle:
                          Text(AppLocalizations.of(context)!.userCNameContext),
                    )),
              ),
              Semantics(
                label: AppLocalizations.of(context)!.userCPass,
                hint: AppLocalizations.of(context)!.userCPassContext,
                child: GestureDetector(
                    onTap: () {
                      changeUserPass(context);
                    },
                    child: ListTile(
                      leading: Icon(Icons.password),
                      title: Text(AppLocalizations.of(context)!.userCPass),
                      subtitle:
                          Text(AppLocalizations.of(context)!.userCPassContext),
                    )),
              ),
              Semantics(
                label: AppLocalizations.of(context)!.userLOut,
                hint: AppLocalizations.of(context)!.userLOutContext,
                child: GestureDetector(
                    onTap: () {
                      logOut(context);
                    },
                    child: ListTile(
                      leading: Icon(Icons.logout),
                      title: Text(AppLocalizations.of(context)!.userLOut),
                      subtitle:
                          Text(AppLocalizations.of(context)!.userLOutContext),
                    )),
              ),
              Semantics(
                label: AppLocalizations.of(context)!.userErase,
                hint: AppLocalizations.of(context)!.userEraseContext,
                child: GestureDetector(
                    onTap: () {
                      eraseUser(context);
                    },
                    child: ListTile(
                      iconColor: Colors.white,
                      leading: Icon(Icons.remove),
                      textColor:
                          context.watch<StyleProvider>().colorsMap["white"],
                      tileColor:
                          context.watch<StyleProvider>().colorsMap["red"],
                      title: Text(AppLocalizations.of(context)!.userErase),
                      subtitle:
                          Text(AppLocalizations.of(context)!.userEraseContext),
                    )),
              )
            ],
          ))
        ],
      ),
    );
  }

  ///Función de cambio de imagen
  ///
  ///Abre un pop up con un textfield donde poner el url de la imagen
  ///
  ///Si recibe un url, cambia la imagen del usuario y de la aplicación
  void changeIMG(BuildContext context, User u) async {
    String? res = await showDialog(
        context: context, builder: (context) => ImageUploadContextDialog());
    if (res != null) {
      u.image = res;
      await UserDAO().update(u);
    }
    context.read<UserDataProvider>().changeUser(u);
  }

  ///Función de cambio de nombre de usuario
  ///
  ///Abre un pop up con bloques de texto para confirmar el nuevo nombre de usuario.
  ///
  ///Si recibe del pop up el nombre de usuario correctamente, cambia los parámetros de éste.
  void changeUserPass(BuildContext context) async {
    String? newPass = await showDialog<String>(
        context: context, builder: (context) => ChangePasswordContextDialog());
    if (newPass != null) {
      context.read<UserDataProvider>().thisUser!.passwd = newPass;
      await UserDAO().update(context.read<UserDataProvider>().thisUser!);
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Contraseña actualizada correctamente")));
    }
  }

  ///Función de cambio de contraseña
  ///
  ///Abre un pop up con bloques de texto para confirmar la nueva contraseña.
  ///
  ///Si recibe del pop up la nueva contraseña correctamente, cambia los parámetros del usuario
  void changeUserName(BuildContext context) async {
    String? newName = await showDialog<String>(
        context: context, builder: (context) => ChangeUserNameContextDialog());
    if (newName != null) {
      context.read<UserDataProvider>().thisUser!.username = newName;
      await UserDAO().update(context.read<UserDataProvider>().thisUser!);
      context
          .read<UserDataProvider>()
          .changeUser(context.read<UserDataProvider>().thisUser!);
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Nombre actualizado correctamente")));
    }
  }

  ///Función de borrado de usuario
  ///
  ///Abre un pop up donde el usuario elige si quiere o no borrar su cuenta
  ///
  ///Si elige que sí, se realizan las operaciones de borrado de cuenta
  void eraseUser(BuildContext context) async {
    bool? res = await showDialog<bool>(
        context: context, builder: (context) => EraseContextDialog());
    if (res != null && res) {
      Navigator.pop(context);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LogInView()));
      context.read<UserDataProvider>().erase();
    }
  }

  ///Función de cierre de sesión
  ///
  ///Es más simple que el resto, simplemente cambia los parámetros de las preferencias y vuelve al login (sin vuelta atrás)
  void logOut(BuildContext context) {
    Navigator.pop(context);
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LogInView()));
    context.read<UserDataProvider>().logout();
  }

  void loadList() async {
    List<Device> auxList = await DeviceDAO().list();
    setState(() {
      devs = auxList;
    });
  }
}
