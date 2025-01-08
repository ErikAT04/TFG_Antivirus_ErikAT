import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:magik_antivirus/main.dart';
import 'package:crypto/crypto.dart' as crypto;
import 'package:magik_antivirus/model/User.dart';
import 'package:magik_antivirus/DataAccess/UserDAO.dart';
import 'package:magik_antivirus/utils/AppEssentials.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

///Dialog de borrado de cuenta
///El usuario verá un mensaje diciendo las consecuencias de borrar la cuenta, un botón de cancelar y uno de aceptas
///Si el usuario pulsa aceptar, se cierra y manda una señal afirmativa
///Si el usuario pulsa cancelar, se cierra y manda una señal negativa
class EraseContextDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Wrap(
        alignment: WrapAlignment.center,
        children: [
          Text(
            AppLocalizations.of(context)!.userAskErase,
            softWrap: true,
          ),
          ElevatedButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: Text(AppLocalizations.of(context)!.userErase)),
          ElevatedButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: Text(AppLocalizations.of(context)!.cancel)),
        ],
      ),
    );
  }
}

///Dialog de registro
class RegisterContextDialog extends StatefulWidget {
  const RegisterContextDialog({super.key});

  @override
  State<RegisterContextDialog> createState() => RegisterContextDialogState();
}

///Estado del dialog del registro:
///El usuario verá un pop up con 4 bloques de texto a rellenar y un botón de registro.
class RegisterContextDialogState extends State<RegisterContextDialog> {
  TextEditingController unameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController repPassController = TextEditingController();

  String? errorUname;
  String? errorEmail;
  String? errorPass;
  String? errorRepPass;

  @override
  Widget build(BuildContext context) {
    return Dialog(
        child: Container(
      margin: EdgeInsets.all(10),
      child: Wrap(
        spacing: 10,
        alignment: WrapAlignment.center,
        children: [
          TextField(
            controller: emailController,
            decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.email,
                errorText: errorEmail,
                labelStyle: TextStyle(
                    fontSize: 10,
                    color: (context.watch<MainAppProvider>().theme ==
                            AppEssentials.darkMode)
                        ? AppEssentials.colorsMap["appMainLightBlue"]
                        : AppEssentials.colorsMap["appMainBlue"]),
                errorStyle: TextStyle(fontSize: 10)),
          ),
          TextField(
            controller: unameController,
            decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.uname,
                errorText: errorUname,
                labelStyle: TextStyle(
                    fontSize: 10,
                    color: (context.watch<MainAppProvider>().theme ==
                            AppEssentials.darkMode)
                        ? AppEssentials.colorsMap["appMainLightBlue"]
                        : AppEssentials.colorsMap["appMainBlue"]),
                errorStyle: TextStyle(fontSize: 10)),
          ),
          TextField(
            controller: passController,
            decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.pass,
                errorText: errorPass,
                labelStyle: TextStyle(
                    fontSize: 10,
                    color: (context.watch<MainAppProvider>().theme ==
                            AppEssentials.darkMode)
                        ? AppEssentials.colorsMap["appMainLightBlue"]
                        : AppEssentials.colorsMap["appMainBlue"]),
                errorStyle: TextStyle(fontSize: 10)),
            obscureText: true,
          ),
          TextField(
            controller: repPassController,
            decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.repPass,
                errorText: errorRepPass,
                labelStyle: TextStyle(
                    fontSize: 10,
                    color: (context.watch<MainAppProvider>().theme ==
                            AppEssentials.darkMode)
                        ? AppEssentials.colorsMap["appMainLightBlue"]
                        : AppEssentials.colorsMap["appMainBlue"]),
                errorStyle: TextStyle(fontSize: 10)),
            obscureText: true,
          ),
          ElevatedButton(
              onPressed: () {
                register(context);
              },
              child: Text(AppLocalizations.of(context)!.signUp))
        ],
      ),
    ));
  }

  ///Función de registro de usuario:
  ///Al rellenar los datos, empezará a hacer los controles de las siguientes condiciones:
  /// - No puede haber campos vacíos
  /// - Ni el nombre de usuario ni la contraseña pueden aparecer ya en la BD
  /// - El correo tiene que cumplir los caracteres del correo
  /// - La contraseña tiene que ser de, como mínimo, 8 caracteres
  /// - El texto de los campos de contraseña y repetición de contraseña deben ser iguales
  ///Una vez se tiene todo eso, se cierra el pop up
  void register(BuildContext context) async {
    bool resultSuccess = false;

    String? errorUnameText;
    String? errorPassText;
    String? errorEmailText;
    String? errorRepPassText;
    if (repPassController.text.isEmpty ||
        passController.text.isEmpty ||
        emailController.text.isEmpty ||
        unameController.text.isEmpty) {
      errorUnameText = (unameController.text.isEmpty)
          ? AppLocalizations.of(context)!.errorEmptyField
          : null;
      errorPassText = (passController.text.isEmpty)
          ? AppLocalizations.of(context)!.errorEmptyField
          : null;
      errorRepPassText = (repPassController.text.isEmpty)
          ? AppLocalizations.of(context)!.errorEmptyField
          : null;
      errorEmailText = (emailController.text.isEmpty)
          ? AppLocalizations.of(context)!.errorEmptyField
          : null;
    } else {
      if (AppEssentials.emailRegExp.hasMatch(emailController.text)) {
        User? u;
        u = await UserDAO().get(emailController.text);
        if (u != null) {
          errorEmailText = AppLocalizations.of(context)!.emailUnavaliable;
        } else {
          u = await UserDAO().get(unameController.text);
          if (u != null) {
            errorUnameText = AppLocalizations.of(context)!.unameUnavaliable;
          } else {
            if (passController.text.length < 8) {
              errorPassText = AppLocalizations.of(context)!.passwordNotValid;
            } else {
              if (repPassController.text != passController.text) {
                errorRepPassText = AppLocalizations.of(context)!.diffPasswords;
              } else {
                resultSuccess = true;
              }
            }
          }
        }
      } else {
        errorEmailText = AppLocalizations.of(context)!.emailNotValid;
      }
    }
    if (resultSuccess) {
      User u = User(
          uname: unameController.text,
          pass: crypto.sha256
              .convert(utf8.encode(passController.text))
              .toString(),
          email: emailController.text);
      await UserDAO().insert(u);
      Navigator.pop(context, u);
    } else {
      setState(() {
        errorUname = errorUnameText;
        errorPass = errorPassText;
        errorEmail = errorEmailText;
        errorRepPass = errorRepPassText;
      });
    }
  }
}

///Dialog de cambio de nombre de usuario
class ChangeUserNameContextDialog extends StatefulWidget {
  const ChangeUserNameContextDialog({super.key});

  @override
  State<ChangeUserNameContextDialog> createState() =>
      ChangeUserNameContextDialogState();
}

///Estado del dialog de cambio de nombre de usuario
///Aparecerá un pop up con dos textos: Uno para introducir un nombre de usuario nuevo y para confirmar con la contraseña, además de un botón para cambiar el nombre
class ChangeUserNameContextDialogState
    extends State<ChangeUserNameContextDialog> {
  TextEditingController unameController = TextEditingController();
  TextEditingController passController = TextEditingController();

  String? unameError;
  String? passError;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
          margin: EdgeInsets.all(10),
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 10,
            children: [
              TextField(
                controller: unameController,
                decoration: InputDecoration(
                    errorText: unameError,
                    labelText: AppLocalizations.of(context)!.newUserName,
                    labelStyle: TextStyle(
                        fontSize: 10,
                        color: (context.watch<MainAppProvider>().theme ==
                                AppEssentials.darkMode)
                            ? AppEssentials.colorsMap["appMainLightBlue"]
                            : AppEssentials.colorsMap["appMainBlue"]),
                    errorStyle: TextStyle(fontSize: 10)),
              ),
              TextField(
                obscureText: true,
                controller: passController,
                decoration: InputDecoration(
                    errorText: passError,
                    labelText: AppLocalizations.of(context)!.passConfirm,
                    labelStyle: TextStyle(
                        fontSize: 10,
                        color: (context.watch<MainAppProvider>().theme ==
                                AppEssentials.darkMode)
                            ? AppEssentials.colorsMap["appMainLightBlue"]
                            : AppEssentials.colorsMap["appMainBlue"]),
                    errorStyle: TextStyle(fontSize: 10)),
              ),
              Wrap(
                children: [
                  ElevatedButton(
                      onPressed: () {
                        changeName(context);
                      },
                      child: Text(AppLocalizations.of(context)!.userCName)),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context, null);
                      },
                      child: Text(AppLocalizations.of(context)!.cancel))
                ],
              )
            ],
          )),
    );
  }

  ///Función de cambio de nombre de usuario:
  ///Al rellenar los datos, empezará a hacer los controles de las siguientes condiciones:
  /// - Todos los campos deben estar rellenados
  /// - El nombre de usuario no es el mismo
  /// - El nombre de usuario no aparece ya en la base de datos
  /// - La contraseña está bien puesta
  ///Si pasa todos los controles, cierra el pop up y envía el nuevo nombre de usuario como señal positiva.
  void changeName(BuildContext context) async {
    bool allCorrect = false;
    String? errorNameText;
    String? errorPassText;

    if (unameController.text.isEmpty || passController.text.isEmpty) {
      errorNameText = (unameController.text.isEmpty)
          ? AppLocalizations.of(context)!.errorEmptyField
          : null;
      errorPassText = (passController.text.isEmpty)
          ? AppLocalizations.of(context)!.errorEmptyField
          : null;
    } else {
      if (unameController.text ==
          context.read<MainAppProvider>().thisUser!.uname) {
        errorNameText = AppLocalizations.of(context)!.unameUnavaliable;
      } else {
        User? u = await UserDAO().get(unameController.text);
        if (u != null) {
          errorNameText = AppLocalizations.of(context)!.unameUnavaliable;
        } else {
          if (crypto.sha256
                  .convert(utf8.encode(passController.text))
                  .toString() !=
              context.read<MainAppProvider>().thisUser!.pass) {
            errorPassText = AppLocalizations.of(context)!.errorWrongPass;
          } else {
            allCorrect = true;
          }
        }
      }
    }

    if (allCorrect) {
      Navigator.pop(context, unameController.text);
    } else {
      setState(() {
        unameError = errorNameText;
        passError = errorPassText;
      });
    }
  }
}

///Dialog de cambio de contraseña
class ChangePasswordContextDialog extends StatefulWidget {
  const ChangePasswordContextDialog({super.key});

  @override
  State<ChangePasswordContextDialog> createState() =>
      ChangePasswordContextDialogState();
}

///Estado del Dialog de cambio de contraseña:
///El usuario ve 3 campos de texto para cambiar la contraseña y un botón para confirmar el cambio
class ChangePasswordContextDialogState
    extends State<ChangePasswordContextDialog> {
  TextEditingController oldPassController = TextEditingController();
  TextEditingController newPassController = TextEditingController();
  TextEditingController repNewPassController = TextEditingController();

  String? errorOld;
  String? errorNew;
  String? errorRep;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        margin: EdgeInsets.all(10),
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 10,
          children: [
            TextField(
              controller: oldPassController,
              obscureText: true,
              decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.formerPassword,
                  errorText: errorOld,
                  labelStyle: TextStyle(
                      fontSize: 10,
                      color: (context.watch<MainAppProvider>().theme ==
                              AppEssentials.darkMode)
                          ? AppEssentials.colorsMap["appMainLightBlue"]
                          : AppEssentials.colorsMap["appMainBlue"]),
                  errorStyle: TextStyle(fontSize: 10)),
            ),
            TextField(
              controller: newPassController,
              obscureText: true,
              decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.newPassword,
                  errorText: errorNew,
                  labelStyle: TextStyle(
                      fontSize: 10,
                      color: (context.watch<MainAppProvider>().theme ==
                              AppEssentials.darkMode)
                          ? AppEssentials.colorsMap["appMainLightBlue"]
                          : AppEssentials.colorsMap["appMainBlue"]),
                  errorStyle: TextStyle(fontSize: 10)),
            ),
            TextField(
              obscureText: true,
              controller: repNewPassController,
              decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.repeatNewPass,
                  errorText: errorRep,
                  labelStyle: TextStyle(
                      fontSize: 10,
                      color: (context.watch<MainAppProvider>().theme ==
                              AppEssentials.darkMode)
                          ? AppEssentials.colorsMap["appMainLightBlue"]
                          : AppEssentials.colorsMap["appMainBlue"]),
                  errorStyle: TextStyle(fontSize: 10)),
            ),
            ElevatedButton(
                onPressed: () {
                  changePass(context);
                },
                child: Text(AppLocalizations.of(context)!.userCPass)),
            ElevatedButton(
                onPressed: () {
                  Navigator.pop(context, null);
                },
                child: Text(AppLocalizations.of(context)!.cancel))
          ],
        ),
      ),
    );
  }

  ///Función de cambio de contraseña:
  ///Al rellenar los datos, empezará a hacer los controles de las siguientes condiciones:
  /// - Todos los campos deben estar rellenados
  /// - La contraseña antigua tiene que estar puesta correctamente
  /// - La contraseña nueva no puede ser igual a la antigua
  /// - La contraseña nueva debe tener como minimo 8 caracteres
  /// - La contraseña nueva y el texto del campo de repetición de contraseña han de ser iguales
  ///Si todos los campos están correctamente rellenados, se envía la nueva contraseña como señal positiva y se cierra el pop up
  void changePass(BuildContext context) {
    bool allCorrect = false;
    String? errorOldText;
    String? errorNewText;
    String? errorRepText;

    if (oldPassController.text.isEmpty ||
        newPassController.text.isEmpty ||
        repNewPassController.text.isEmpty) {
      errorOldText = (oldPassController.text.isEmpty)
          ? AppLocalizations.of(context)!.errorEmptyField
          : null;
      errorNewText = (newPassController.text.isEmpty)
          ? AppLocalizations.of(context)!.errorEmptyField
          : null;
      errorRepText = (repNewPassController.text.isEmpty)
          ? AppLocalizations.of(context)!.errorEmptyField
          : null;
    } else {
      if (crypto.sha256
              .convert(utf8.encode(oldPassController.text))
              .toString() !=
          context.read<MainAppProvider>().thisUser!.pass) {
        errorOldText = AppLocalizations.of(context)!.errorWrongPass;
      } else {
        if (oldPassController.text == newPassController.text) {
          errorNewText = AppLocalizations.of(context)!.errorSamePass;
        } else {
          if (newPassController.text.length < 8) {
            errorNewText = AppLocalizations.of(context)!.passwordNotValid;
          } else {
            if (newPassController.text != repNewPassController.text) {
              errorRepText = AppLocalizations.of(context)!.diffPasswords;
            } else {
              allCorrect = true;
            }
          }
        }
      }
    }
    if (allCorrect) {
      Navigator.pop(
          context,
          crypto.sha256
              .convert(utf8.encode(newPassController.text))
              .toString());
    } else {
      setState(() {
        errorOld = errorOldText;
        errorNew = errorNewText;
        errorRep = errorRepText;
      });
    }
  }
}

///Dialog de cambio de url de imagen
class ImageUploadContextDialog extends StatefulWidget {
  const ImageUploadContextDialog({super.key});

  @override
  State<ImageUploadContextDialog> createState() =>
      ImageUploadContextDialogState();
}

///Estado del Dialog del cambio de url de imagen
///Aparece un pop up con un bloque de texto para introducir la URL de la imagen y un botón para aceptar
class ImageUploadContextDialogState extends State<ImageUploadContextDialog> {
  TextEditingController linkController = TextEditingController();
  String? errorTxt;
  @override
  Widget build(BuildContext context) {
    return Dialog(
        child: Container(
      margin: EdgeInsets.all(10),
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 10,
        alignment: WrapAlignment.center,
        children: [
          TextField(
            controller: linkController,
            decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.linkput,
                errorText: errorTxt,
                labelStyle: TextStyle(
                    fontSize: 10,
                    color: (context.watch<MainAppProvider>().theme ==
                            AppEssentials.darkMode)
                        ? AppEssentials.colorsMap["appMainLightBlue"]
                        : AppEssentials.colorsMap["appMainBlue"]),
                errorStyle: TextStyle(fontSize: 10)),
          ),
          ElevatedButton(
              onPressed: () {
                changeUserImage(context);
              },
              child: Text(AppLocalizations.of(context)!.loadImg))
        ],
      ),
    ));
  }

  ///Función de cambio de imagen
  ///Al rellenar los datos, empezará a hacer los controles de la siguiente condicion:
  /// - El campo del enlace debe estar relleno y no puede exceder los 255 caracteres
  ///Una vez completado
  void changeUserImage(BuildContext context) {
    if (linkController.text.isNotEmpty && linkController.text.length < 256) {
      Navigator.pop(context, linkController.text);
    } else {
      setState(() {
        errorTxt = (linkController.text.isEmpty)
            ? AppLocalizations.of(context)!.errorEmptyField
            : "${AppLocalizations.of(context)!.sizePassed} (1-254)";
      });
    }
  }
}
