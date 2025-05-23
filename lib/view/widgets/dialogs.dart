import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:magik_antivirus/viewmodel/style_provider.dart';
import 'package:magik_antivirus/viewmodel/user_data_provider.dart';
import 'package:provider/provider.dart';
import 'package:crypto/crypto.dart' as crypto;
import 'package:magik_antivirus/model/data_classes/file.dart';
import 'package:magik_antivirus/model/data_classes/user.dart';
import 'package:magik_antivirus/model/data_access/user_dao.dart';
import 'package:magik_antivirus/model/utils/app_essentials.dart';
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
        child: Container(
      padding: EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        spacing: 5,
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
    ));
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

  ///Booleana que indica si está cargando el registro
  bool isLoading = false;

  ///El usuario verá un pop up con 4 bloques de texto a rellenar y un botón de registro.
  @override
  Widget build(BuildContext context) {
    return Dialog(
        child: Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(5),
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
                    label: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(AppLocalizations.of(context)!.email)),
                    errorText: errorEmail,
                    labelStyle: TextStyle(
                        color: (context
                                .watch<StyleProvider>()
                                .isLightModeActive)
                            ? context.watch<StyleProvider>().palette["appMain"]
                            : context
                                .watch<StyleProvider>()
                                .palette["appLight"]),
                    errorStyle: TextStyle(fontSize: 10)),
              )),
          Padding(padding: EdgeInsets.all(10)),
          Semantics(
            label: AppLocalizations.of(context)!.uname,
            hint: AppLocalizations.of(context)!.unameContext,
            child: TextField(
              controller: unameController,
              decoration: InputDecoration(
                  label: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(AppLocalizations.of(context)!.uname)),
                  errorText: errorUname,
                  labelStyle: TextStyle(
                      color: (context.watch<StyleProvider>().isLightModeActive)
                          ? context.watch<StyleProvider>().palette["appMain"]
                          : context.watch<StyleProvider>().palette["appLight"]),
                  errorStyle: TextStyle(fontSize: 10)),
            ),
          ),
          Padding(padding: EdgeInsets.all(10)),
          Semantics(
            label: AppLocalizations.of(context)!.pass,
            hint: AppLocalizations.of(context)!.passContext,
            child: TextField(
              controller: passController,
              decoration: InputDecoration(
                  label: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(AppLocalizations.of(context)!.pass)),
                  errorText: errorPass,
                  labelStyle: TextStyle(
                      color: (context.watch<StyleProvider>().isLightModeActive)
                          ? context.watch<StyleProvider>().palette["appMain"]
                          : context.watch<StyleProvider>().palette["appLight"]),
                  errorStyle: TextStyle(fontSize: 10)),
              obscureText: true,
            ),
          ),
          Padding(padding: EdgeInsets.all(10)),
          Semantics(
              label: AppLocalizations.of(context)!.repPass,
              hint: AppLocalizations.of(context)!.repPassContext,
              child: TextField(
                controller: repPassController,
                decoration: InputDecoration(
                    label: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(AppLocalizations.of(context)!.repPass)),
                    errorText: errorRepPass,
                    labelStyle: TextStyle(
                        color: (context
                                .watch<StyleProvider>()
                                .isLightModeActive)
                            ? context.watch<StyleProvider>().palette["appMain"]
                            : context
                                .watch<StyleProvider>()
                                .palette["appLight"]),
                    errorStyle: TextStyle(fontSize: 10)),
                obscureText: true,
              )),
          Padding(padding: EdgeInsets.all(10)),
          Semantics(
            label: AppLocalizations.of(context)!.signUp,
            hint: AppLocalizations.of(context)!.registerContext,
            child: Center(
                child: ElevatedButton(
                    onPressed: () {
                      if (isLoading) return;
                      register(context);
                    },
                    child: (isLoading)
                        ? CircularProgressIndicator()
                        : Text(AppLocalizations.of(context)!.signUp))),
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
    setState(() {
      errorUname = null;
      errorPass = null;
      errorEmail = null;
      errorRepPass = null;
      isLoading = true;
    });

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
          username: unameController.text,
          passwd: crypto.sha256
              .convert(utf8.encode(passController.text))
              .toString(),
          image:
              "https://media.istockphoto.com/id/1147544807/es/vector/no-imagen-en-miniatura-gr%C3%A1fico-vectorial.jpg?s=612x612&w=0&k=20&c=Bb7KlSXJXh3oSDlyFjIaCiB9llfXsgS7mHFZs6qUgVk=", //Placeholder
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
    setState(() {
      isLoading = false;
    });
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

  //Booleana que indica si está cargando el cambio de nombre
  bool isLoading = false;

  ///Aparecerá un pop up con dos textos: Uno para introducir un nombre de usuario nuevo y para confirmar con la contraseña, además de un botón para cambiar el nombre
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
          margin: EdgeInsets.all(10),
          child: Column(
            spacing: 10,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Semantics(
                label: AppLocalizations.of(context)!.newUserName,
                hint: AppLocalizations.of(context)!.unameContext,
                child: TextField(
                  controller: unameController,
                  decoration: InputDecoration(
                      errorText: unameError,
                      label: FittedBox(
                          fit: BoxFit.scaleDown,
                          child:
                              Text(AppLocalizations.of(context)!.newUserName)),
                      labelStyle: TextStyle(
                          color:
                              (context.watch<StyleProvider>().isLightModeActive)
                                  ? context
                                      .watch<StyleProvider>()
                                      .palette["appMain"]
                                  : context
                                      .watch<StyleProvider>()
                                      .palette["appLight"]),
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
                      label: FittedBox(
                          fit: BoxFit.scaleDown,
                          child:
                              Text(AppLocalizations.of(context)!.passConfirm)),
                      labelStyle: TextStyle(
                          color:
                              (context.watch<StyleProvider>().isLightModeActive)
                                  ? context
                                      .watch<StyleProvider>()
                                      .palette["appMain"]
                                  : context
                                      .watch<StyleProvider>()
                                      .palette["appLight"]),
                      errorStyle: TextStyle(fontSize: 10)),
                ),
              ),
              Semantics(
                label: AppLocalizations.of(context)!.userCName,
                hint: AppLocalizations.of(context)!.userCNameContext,
                child: ElevatedButton(
                    onPressed: () {
                      if (isLoading) return;
                      changeName(context);
                    },
                    child: (isLoading)
                        ? CircularProgressIndicator()
                        : Text(AppLocalizations.of(context)!.userCName)),
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
    setState(() {
      unameError = null;
      passError = null;
      isLoading = true;
    });
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
          context.read<UserDataProvider>().thisUser!.username) {
        errorNameText = AppLocalizations.of(context)!.unameUnavaliable;
      } else {
        User? u = await UserDAO().get(unameController.text);
        if (u != null) {
          errorNameText = AppLocalizations.of(context)!.unameUnavaliable;
        } else {
          if (crypto.sha256
                  .convert(utf8.encode(passController.text))
                  .toString() !=
              context.read<UserDataProvider>().thisUser!.passwd) {
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
    setState(() {
      isLoading = false;
    });
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

  ///Booleana que indica si está cargando el cambio de contraseña
  bool isLoading = false;

  ///El usuario ve 3 campos de texto para cambiar la contraseña y un botón para confirmar el cambio
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        margin: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          spacing: 10,
          children: [
            Semantics(
              label: AppLocalizations.of(context)!.formerPassword,
              child: TextField(
                controller: oldPassController,
                obscureText: true,
                decoration: InputDecoration(
                    label: FittedBox(
                        fit: BoxFit.scaleDown,
                        child:
                            Text(AppLocalizations.of(context)!.formerPassword)),
                    errorText: errorOld,
                    labelStyle: TextStyle(
                        color: (context
                                .watch<StyleProvider>()
                                .isLightModeActive)
                            ? context.watch<StyleProvider>().palette["appMain"]
                            : context
                                .watch<StyleProvider>()
                                .palette["appLight"]),
                    errorStyle: TextStyle(fontSize: 10)),
              ),
            ),
            Semantics(
              label: AppLocalizations.of(context)!.newPassword,
              child: TextField(
                controller: newPassController,
                obscureText: true,
                decoration: InputDecoration(
                    label: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(AppLocalizations.of(context)!.newPassword)),
                    errorText: errorNew,
                    labelStyle: TextStyle(
                        color: (context
                                .watch<StyleProvider>()
                                .isLightModeActive)
                            ? context.watch<StyleProvider>().palette["appMain"]
                            : context
                                .watch<StyleProvider>()
                                .palette["appLight"]),
                    errorStyle: TextStyle(fontSize: 10)),
              ),
            ),
            Semantics(
              label: AppLocalizations.of(context)!.repeatNewPass,
              child: TextField(
                obscureText: true,
                controller: repNewPassController,
                decoration: InputDecoration(
                    label: FittedBox(
                        fit: BoxFit.scaleDown,
                        child:
                            Text(AppLocalizations.of(context)!.repeatNewPass)),
                    errorText: errorRep,
                    labelStyle: TextStyle(
                        color: (context.watch<StyleProvider>().isLightModeActive
                            ? context.watch<StyleProvider>().palette["appMain"]
                            : context
                                .watch<StyleProvider>()
                                .palette["appLight"])),
                    errorStyle: TextStyle(fontSize: 10)),
              ),
            ),
            Semantics(
              label: AppLocalizations.of(context)!.userCPass,
              hint: AppLocalizations.of(context)!.userCPassContext,
              child: ElevatedButton(
                  onPressed: () {
                    if (isLoading) return;
                    changePass(context);
                  },
                  child: (isLoading)
                      ? CircularProgressIndicator()
                      : Text(AppLocalizations.of(context)!.userCPass)),
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
    setState(() {
      errorOld = null;
      errorNew = null;
      errorRep = null;
      isLoading = true;
    });
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
          context.read<UserDataProvider>().thisUser!.passwd) {
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
      setState(() {
        isLoading = false;
      });
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

  ///Booleana que indica si está cargando el cambio de imagen
  bool isLoading = false;

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
                  label: FittedBox(
                    child: Text(AppLocalizations.of(context)!.linkput),
                    fit: BoxFit.scaleDown,
                  ),
                  errorText: errorTxt,
                  labelStyle: TextStyle(
                      color: (context.watch<StyleProvider>().isLightModeActive)
                          ? context.watch<StyleProvider>().palette["appMain"]
                          : context.watch<StyleProvider>().palette["appLight"]),
                  errorStyle: TextStyle(fontSize: 10)),
            ),
          ),
          Semantics(
              label: AppLocalizations.of(context)!.loadImg,
              child: ElevatedButton(
                  onPressed: () {
                    if (isLoading) return;
                    changeUserImage(context);
                  },
                  child: (isLoading)
                      ? CircularProgressIndicator()
                      : Text(AppLocalizations.of(context)!.loadImg)))
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
    setState(() {
      errorTxt = null;
      isLoading = true;
    });
    if (linkController.text.isNotEmpty && linkController.text.length < 256) {
      Navigator.pop(context, linkController.text);
    } else {
      setState(() {
        errorTxt = (linkController.text.isEmpty)
            ? AppLocalizations.of(context)!.errorEmptyField
            : "${AppLocalizations.of(context)!.sizePassed} (1-254)";
      });
    }
    setState(() {
      isLoading = false;
    });
  }
}

///Dialogo del contexto de ficheros
class FileContext extends StatelessWidget {
  ///Archivo que recibe por parámetro
  final QuarantinedFile file;

  ///Constructor
  ///
  ///Recibe el archivo por parámetro
  FileContext({super.key, required this.file});

  ///Muestra los distintos datos del fichero, junto un botón para borrar el archivo y otro para restaurarlo.
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(file.name),
                Expanded(
                    child: Padding(
                  padding: EdgeInsets.all(1),
                )),
                Icon(
                  Icons.file_open,
                  size: 30,
                )
              ],
            ),
            Text(
              "${AppLocalizations.of(context)!.fileRoute} ${file.route}",
              softWrap: true,
            ),
            Text(
              "${AppLocalizations.of(context)!.malType} ${file.malwareType}",
              softWrap: true,
            ),
            Text(
              "${AppLocalizations.of(context)!.confDate} ${file.quarantineDate.year}-${(file.quarantineDate.month < 10) ? "0${file.quarantineDate.month}" : file.quarantineDate.month}-${(file.quarantineDate.day < 10) ? "0${file.quarantineDate.day}" : file.quarantineDate.day}",
              softWrap: true,
            ),
            Center(
              child: ElevatedButton(
                  onPressed: () {
                    restoreFile(context, file);
                  },
                  child: Text(AppLocalizations.of(context)!.restFile)),
            ),
            Center(
                child: ElevatedButton(
                    onPressed: () {
                      eraseFile(context, file);
                    },
                    child: Text(AppLocalizations.of(context)!.eraseFile)))
          ],
        ),
      ),
    );
  }

  ///Función de borrado permanente del archivo
  void eraseFile(BuildContext context, QuarantinedFile file) async {
    await AppEssentials.eraseFile(file);
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.fileErased)));
    Navigator.pop(context, true);
  }

  ///Función de restauración de archivos
  void restoreFile(BuildContext context, QuarantinedFile file) async {
    await AppEssentials.getOutOfQuarantine(file);
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.fileRestored)));
    Navigator.pop(context, true);
  }
}
