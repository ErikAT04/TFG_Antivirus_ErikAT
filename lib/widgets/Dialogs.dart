import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:magik_antivirus/main.dart';
import 'package:crypto/crypto.dart' as crypto;
import 'package:magik_antivirus/model/User.dart';
import 'package:magik_antivirus/DataAccess/UserDAO.dart';
import 'package:magik_antivirus/utils/AppEssentials.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

///Dialog de borrado de cuenta.
class EraseContextDialog extends StatelessWidget {
  ///El usuario verá un mensaje diciendo las consecuencias de borrar la cuenta, un botón de cancelar y uno de aceptas
  ///
  ///Si el usuario pulsa aceptar, se cierra y manda una señal afirmativa
  ///
  ///Si el usuario pulsa cancelar, se cierra y manda una señal negativa
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Wrap(
        alignment: WrapAlignment.center,
        children: [
          ExcludeSemantics(
            child: Text(
              AppLocalizations.of(context)!.userAskErase,
              softWrap: true,
            ),
          ),
          Semantics(
              label: AppLocalizations.of(context)!.userErase,
              hint: AppLocalizations.of(context)!.confirmContext,
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  child: Text(AppLocalizations.of(context)!.userErase))),
          Semantics(
              label: AppLocalizations.of(context)!.cancel,
              hint: AppLocalizations.of(context)!.cancelContext,
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  child: Text(AppLocalizations.of(context)!.cancel))),
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
class RegisterContextDialogState extends State<RegisterContextDialog> {
  ///Controller del texto del nombre de usuario
  TextEditingController unameController = TextEditingController();

  ///Controller del texto del email
  TextEditingController emailController = TextEditingController();

  ///Controller del texto de la contraseña
  TextEditingController passController = TextEditingController();

  ///Controller del campo para repetir la contraseña
  TextEditingController repPassController = TextEditingController();

  ///String nullable del error del nombre
  String? errorUname;

  ///String nullable del error del email
  String? errorEmail;

  ///String nullable del error de la contraseña
  String? errorPass;

  ///String nullable del error de la repetición de la contraseña
  String? errorRepPass;

  ///El usuario verá un pop up con 4 bloques de texto a rellenar y un botón de registro.
  @override
  Widget build(BuildContext context) {
    return Dialog(
        child: Container(
      margin: EdgeInsets.all(10),
      child: Wrap(
        spacing: 10,
        alignment: WrapAlignment.center,
        children: [
          Semantics(
              label: AppLocalizations.of(context)!.email,
              hint: AppLocalizations.of(context)!.emailContext,
              child: TextField(
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
              )),
          Semantics(
            label: AppLocalizations.of(context)!.uname,
            hint: AppLocalizations.of(context)!.unameContext,
            child: TextField(
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
          ),
          Semantics(
            label: AppLocalizations.of(context)!.pass,
            hint: AppLocalizations.of(context)!.passContext,
            child: TextField(
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
          ),
          Semantics(
              label: AppLocalizations.of(context)!.repPass,
              hint: AppLocalizations.of(context)!.repPassContext,
              child: TextField(
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
              )),
          Semantics(
            label: AppLocalizations.of(context)!.signUp,
            hint: AppLocalizations.of(context)!.registerContext,
            child: ElevatedButton(
                onPressed: () {
                  register(context);
                },
                child: Text(AppLocalizations.of(context)!.signUp)),
          )
        ],
      ),
    ));
  }

  ///Función de registro de usuario:
  ///
  ///Al rellenar los datos, empezará a hacer los controles de las siguientes condiciones:
  ///
  /// - No puede haber campos vacíos
  ///
  /// - Ni el nombre de usuario ni la contraseña pueden aparecer ya en la BD
  ///
  /// - El correo tiene que cumplir los caracteres del correo
  ///
  /// - La contraseña tiene que ser de, como mínimo, 8 caracteres
  ///
  /// - El texto de los campos de contraseña y repetición de contraseña deben ser iguales
  ///
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
class ChangeUserNameContextDialogState
    extends State<ChangeUserNameContextDialog> {
  ///Controller del texto del nombre de usuario
  TextEditingController unameController = TextEditingController();

  ///Controller del texto de la contraseña
  TextEditingController passController = TextEditingController();

  ///String nullable del error de nombre de usuario
  String? unameError;

  ///String nullable del error de contraseña
  String? passError;

  ///Aparecerá un pop up con dos textos: Uno para introducir un nombre de usuario nuevo y para confirmar con la contraseña, además de un botón para cambiar el nombre
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
          margin: EdgeInsets.all(10),
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 10,
            children: [
              Semantics(
                label: AppLocalizations.of(context)!.newUserName,
                hint: AppLocalizations.of(context)!.unameContext,
                child: TextField(
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
              ),
              Semantics(
                label: AppLocalizations.of(context)!.passConfirm,
                hint: AppLocalizations.of(context)!.passContext,
                child: TextField(
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
              ),
              Wrap(
                children: [
                  Semantics(
                    label: AppLocalizations.of(context)!.userCName,
                    hint: AppLocalizations.of(context)!.userCNameContext,
                    child: ElevatedButton(
                        onPressed: () {
                          changeName(context);
                        },
                        child: Text(AppLocalizations.of(context)!.userCName)),
                  ),
                  Semantics(
                    label: AppLocalizations.of(context)!.cancel,
                    hint: AppLocalizations.of(context)!.cancelContext,
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context, null);
                        },
                        child: Text(AppLocalizations.of(context)!.cancel)),
                  )
                ],
              )
            ],
          )),
    );
  }

  ///Función de cambio de nombre de usuario:
  ///
  ///Al rellenar los datos, empezará a hacer los controles de las siguientes condiciones:
  ///
  /// - Todos los campos deben estar rellenados
  ///
  /// - El nombre de usuario no es el mismo
  ///
  /// - El nombre de usuario no aparece ya en la base de datos
  ///
  /// - La contraseña está bien puesta
  ///
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
class ChangePasswordContextDialogState
    extends State<ChangePasswordContextDialog> {
  ///Controller del texto de la antigua contraseña
  TextEditingController oldPassController = TextEditingController();

  ///Controller del texto de la nueva contraseña
  TextEditingController newPassController = TextEditingController();

  ///Controller del texto de la repetición de la nueva contraseña
  TextEditingController repNewPassController = TextEditingController();

  ///String nullable del error de la antigua contraseña
  String? errorOld;

  ///String nullable del error de la nueva contraseña
  String? errorNew;

  ///String nullable del error de la repetición de la nueva contraseña
  String? errorRep;

  ///El usuario ve 3 campos de texto para cambiar la contraseña y un botón para confirmar el cambio
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        margin: EdgeInsets.all(10),
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 10,
          children: [
            Semantics(
              label: AppLocalizations.of(context)!.formerPassword,
              child: TextField(
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
            ),
            Semantics(
              label: AppLocalizations.of(context)!.newPassword,
              child: TextField(
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
            ),
            Semantics(
              label: AppLocalizations.of(context)!.repeatNewPass,
              child: TextField(
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
            ),
            Semantics(
              label: AppLocalizations.of(context)!.userCPass,
              hint: AppLocalizations.of(context)!.userCPassContext,
              child: ElevatedButton(
                  onPressed: () {
                    changePass(context);
                  },
                  child: Text(AppLocalizations.of(context)!.userCPass)),
            ),
            Semantics(
                label: AppLocalizations.of(context)!.cancel,
                hint: AppLocalizations.of(context)!.cancelContext,
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context, null);
                    },
                    child: Text(AppLocalizations.of(context)!.cancel)))
          ],
        ),
      ),
    );
  }

  ///Función de cambio de contraseña:
  ///
  ///Al rellenar los datos, empezará a hacer los controles de las siguientes condiciones:
  ///
  /// - Todos los campos deben estar rellenados
  ///
  /// - La contraseña antigua tiene que estar puesta correctamente
  ///
  /// - La contraseña nueva no puede ser igual a la antigua
  ///
  /// - La contraseña nueva debe tener como minimo 8 caracteres
  ///
  /// - La contraseña nueva y el texto del campo de repetición de contraseña han de ser iguales
  ///
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
class ImageUploadContextDialogState extends State<ImageUploadContextDialog> {
  ///Controller del bloque de texto del enlace
  TextEditingController linkController = TextEditingController();

  ///String nullable del error del bloque de texto
  String? errorTxt;

  ///Aparece un pop up con un bloque de texto para introducir la URL de la imagen y un botón para aceptar
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
          Semantics(
            label: AppLocalizations.of(context)!.linkput,
            child: TextField(
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
          ),
          Semantics(
              label: AppLocalizations.of(context)!.loadImg,
              child: ElevatedButton(
                  onPressed: () {
                    changeUserImage(context);
                  },
                  child: Text(AppLocalizations.of(context)!.loadImg)))
        ],
      ),
    ));
  }

  ///Función de cambio de imagen
  ///
  ///Al rellenar los datos, empezará a hacer los controles de la siguiente condicion:
  ///
  /// - El campo del enlace debe estar relleno y no puede exceder los 255 caracteres
  ///
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
