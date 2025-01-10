import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:magik_antivirus/main.dart';
import 'package:crypto/crypto.dart' as crypto;
import 'package:magik_antivirus/model/User.dart';
import 'package:magik_antivirus/views/MainView.dart';
import 'package:magik_antivirus/widgets/Dialogs.dart';
import 'package:magik_antivirus/DataAccess/UserDAO.dart';
import 'package:magik_antivirus/utils/AppEssentials.dart';
import 'package:magik_antivirus/DataAccess/DeviceDAO.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

///Vista de inicio de sesión
class LogInView extends StatefulWidget {
  const LogInView({super.key});

  @override
  State<LogInView> createState() => LogInViewState();
}

///Estado de la vista de inicio de sesión:
class LogInViewState extends State<LogInView> {
  ///Controller del texto de la contraseña
  TextEditingController passController = TextEditingController();
  ///Controller del texto del correo electrónico
  TextEditingController emailController = TextEditingController();
  ///String nullable del error de la contraseña
  String? passErrorText;
  ///String nullable del error del email
  String? emailErrorText;

  ///El usuario verá una Card con distintos campos: Dos TextFields y dos botones, uno para iniciar sesión y otro para registrarse
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppEssentials.colorsMap["appMainBlue"],
        appBar: AppBar(
            title: Center(
          child: Text(AppLocalizations.of(context)!.logIn),
        )),
        body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Card(
            child: Column(
              children: [
                Padding(padding: EdgeInsets.all(5)),
                Text(
                  AppLocalizations.of(context)!.putCredentials,
                  style: TextStyle(fontSize: 16),
                ),
                Container(
                    margin: EdgeInsets.all(10),
                    child: TextField(
                        controller: emailController,
                        decoration: InputDecoration(
                            labelText: AppLocalizations.of(context)!.user,
                            errorText: emailErrorText))),
                Container(
                    margin: EdgeInsets.all(10),
                    child: TextField(
                      controller: passController,
                      decoration: InputDecoration(
                          labelText: AppLocalizations.of(context)!.pass,
                          errorText: passErrorText),
                      obscureText: true,
                    )),
                ElevatedButton(
                    onPressed: () {
                      logIn(context);
                    },
                    child: Text(AppLocalizations.of(context)!.logIn)),
                Padding(padding: EdgeInsets.all(5)),
                ElevatedButton(
                    onPressed: () {
                      signUp(context);
                    },
                    child: Text(AppLocalizations.of(context)!.signUp)),
                Padding(padding: EdgeInsets.all(5)),
              ],
            ),
          ),
        ]));
  }

  ///Método de inicio de sesión
  ///
  ///El programa verificará los campos de usuario y contraseña
  ///
  ///-	Si están vacíos, dará error
  ///
  ///-	Si tienen datos, buscarán un usuario en la base de datos que coincida con el email o el nombre dado.
  ///
  /// -	Si no hay ocurrencias en la base de datos, mostrará un error de que el usuario no existe
  /// 
  /// -	Si hay ocurrencias, mira a ver si la contraseña es correcta
  /// 
  ///  - Si no es correcta, mostrará un error de contraseña
  /// 
  ///  - Si es correcta, enviará al usuario a la próxima página: La Vista Principal
  void logIn(BuildContext context) async {
    User? user;
    String? passError = null;
    String? emailError = null;
    bool completedSuccesfully = false;

    if (passController.text.isEmpty || emailController.text.isEmpty) {
      passError = (passController.text.isEmpty)
          ? AppLocalizations.of(context)!.errorEmptyField
          : null;
      emailError = (emailController.text.isEmpty)
          ? AppLocalizations.of(context)!.errorEmptyField
          : null;
    } else {
      user = await UserDAO().get(emailController.text);
      if (user == null) {
        emailError = AppLocalizations.of(context)!.errorNotFound;
      } else {
        if (crypto.sha256
                .convert(utf8.encode(passController.text))
                .toString() ==
            user.pass) {
          completedSuccesfully = true;
          AppEssentials.dev!.user = user.email;
          await DeviceDAO().update(AppEssentials.dev!);
          context.read<MainAppProvider>().changeUser(user);
        } else {
          passError = AppLocalizations.of(context)!.errorWrongPass;
        }
      }
    }
    if (completedSuccesfully) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Mainview()));
    } else {
      setState(() {
        passErrorText = passError;
        emailErrorText = emailError;
      });
    }
  }
  
  ///Función de registro
  ///
  ///Abre un pop up para hacer el formulario de registro.
  ///
  ///Si recibe el usuario del registro (Es decir, se ha hecho todo correctamente), se crea la cuenta y se pasa a la pantalla principal
  void signUp(BuildContext context) async {
    User? u = await showDialog<User>(
        context: context, builder: (context) => RegisterContextDialog());
    if (u != null) {
      AppEssentials.dev!.user = u.email;
      await DeviceDAO().update(AppEssentials.dev!);
      context.read<MainAppProvider>().changeUser(u);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Mainview()));
    }
  }
}
