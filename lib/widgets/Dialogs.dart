import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:magik_antivirus/DataAccess/UserDAO.dart';
import 'package:magik_antivirus/main.dart';
import 'package:magik_antivirus/model/User.dart';
import 'package:magik_antivirus/utils/AppEssentials.dart';
import 'package:provider/provider.dart';
import 'package:crypto/crypto.dart' as crypto;

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

class RegisterContextDialog extends StatefulWidget {
  const RegisterContextDialog({super.key});

  @override
  State<RegisterContextDialog> createState() => _RegisterContextDialogState();
}

class _RegisterContextDialogState extends State<RegisterContextDialog> {
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
              labelStyle: TextStyle(fontSize: 10, color: (context.watch<MainAppProvider>().theme == AppEssentials.darkMode)? AppEssentials.colorsMap["appMainLightBlue"]:AppEssentials.colorsMap["appMainBlue"]),
              errorStyle: TextStyle(fontSize: 10)
            ),
          ),
          TextField(
            controller: unameController,
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!.uname,
              errorText: errorUname,
              labelStyle: TextStyle(fontSize: 10, color: (context.watch<MainAppProvider>().theme == AppEssentials.darkMode)? AppEssentials.colorsMap["appMainLightBlue"]:AppEssentials.colorsMap["appMainBlue"]),
              errorStyle: TextStyle(fontSize: 10)
            ),
          ),
          TextField(
            controller: passController,
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!.pass,
              errorText: errorPass,
              labelStyle: TextStyle(fontSize: 10, color: (context.watch<MainAppProvider>().theme == AppEssentials.darkMode)? AppEssentials.colorsMap["appMainLightBlue"]:AppEssentials.colorsMap["appMainBlue"]),
              errorStyle: TextStyle(fontSize: 10)
            ),
            obscureText: true,
          ),
          TextField(
            controller: repPassController,
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!.repPass,
              errorText: errorRepPass,
              labelStyle: TextStyle(fontSize: 10, color: (context.watch<MainAppProvider>().theme == AppEssentials.darkMode)? AppEssentials.colorsMap["appMainLightBlue"]:AppEssentials.colorsMap["appMainBlue"]),
              errorStyle: TextStyle(fontSize: 10)
            ),
            obscureText: true,
          ),
          ElevatedButton(
              onPressed: () async {
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
                  if (AppEssentials.emailRegExp
                      .hasMatch(emailController.text)) {
                    User? u;
                    u = await UserDAO().get(emailController.text);
                    if (u != null) {
                      errorEmailText =
                          AppLocalizations.of(context)!.emailUnavaliable;
                    } else {
                      u = await UserDAO().get(unameController.text);
                      if (u != null) {
                        errorUnameText =
                            AppLocalizations.of(context)!.unameUnavaliable;
                      } else {
                        if (passController.text.length < 8) {
                          errorPassText =
                              AppLocalizations.of(context)!.passwordNotValid;
                        } else {
                          if (repPassController.text != passController.text) {
                            errorRepPassText =
                                AppLocalizations.of(context)!.diffPasswords;
                          } else {
                            resultSuccess = true;
                          }
                        }
                      }
                    }
                  } else {
                    errorEmailText =
                        AppLocalizations.of(context)!.emailNotValid;
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
              },
              child: Text(AppLocalizations.of(context)!.signUp))
        ],
      ),
    ));
  }
}

class ChangeUserNameContextDialog extends StatefulWidget {
  const ChangeUserNameContextDialog({super.key});

  @override
  State<ChangeUserNameContextDialog> createState() =>
      _ChangeUserNameContextDialogState();
}

class _ChangeUserNameContextDialogState
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
                    labelStyle: TextStyle(fontSize: 10, color: (context.watch<MainAppProvider>().theme == AppEssentials.darkMode)? AppEssentials.colorsMap["appMainLightBlue"]:AppEssentials.colorsMap["appMainBlue"]),
                    errorStyle: TextStyle(fontSize: 10)),
              ),
              TextField(
                obscureText: true,
                controller: passController,
                decoration: InputDecoration(
                    errorText: passError,
                    labelText: AppLocalizations.of(context)!.passConfirm,
                    labelStyle: TextStyle(fontSize: 10, color: (context.watch<MainAppProvider>().theme == AppEssentials.darkMode)? AppEssentials.colorsMap["appMainLightBlue"]:AppEssentials.colorsMap["appMainBlue"]),
                    errorStyle: TextStyle(fontSize: 10)),
              ),
              Wrap(
                children: [
                  ElevatedButton(
                      onPressed: () async {
                        bool allCorrect = false;
                        String? errorNameText;
                        String? errorPassText;

                        if (unameController.text.isEmpty ||
                            passController.text.isEmpty) {
                          errorNameText = (unameController.text.isEmpty)
                              ? AppLocalizations.of(context)!.errorEmptyField
                              : null;
                          errorPassText = (passController.text.isEmpty)
                              ? AppLocalizations.of(context)!.errorEmptyField
                              : null;
                        } else {
                          if (unameController.text ==
                              context.read<MainAppProvider>().thisUser!.uname) {
                            errorNameText =
                                AppLocalizations.of(context)!.unameUnavaliable;
                          } else {
                            User? u = await UserDAO().get(unameController.text);
                            if (u != null) {
                              errorNameText = AppLocalizations.of(context)!
                                  .unameUnavaliable;
                            } else {
                              if (crypto.sha256
                                      .convert(utf8.encode(passController.text))
                                      .toString() !=
                                  context
                                      .read<MainAppProvider>()
                                      .thisUser!
                                      .pass) {
                                errorPassText = AppLocalizations.of(context)!
                                    .errorWrongPass;
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
}

class ChangePasswordContextDialog extends StatefulWidget {
  const ChangePasswordContextDialog({super.key});

  @override
  State<ChangePasswordContextDialog> createState() =>
      _ChangePasswordContextDialogState();
}

class _ChangePasswordContextDialogState
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
                  labelStyle: TextStyle(fontSize: 10, color: (context.watch<MainAppProvider>().theme == AppEssentials.darkMode)? AppEssentials.colorsMap["appMainLightBlue"]:AppEssentials.colorsMap["appMainBlue"]),
                  errorStyle: TextStyle(fontSize: 10)),
            ),
            TextField(
              controller: newPassController,
              obscureText: true,
              decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.newPassword,
                  errorText: errorNew,
                  labelStyle: TextStyle(fontSize: 10, color: (context.watch<MainAppProvider>().theme == AppEssentials.darkMode)? AppEssentials.colorsMap["appMainLightBlue"]:AppEssentials.colorsMap["appMainBlue"]),
                  errorStyle: TextStyle(fontSize: 10)),
            ),
            TextField(
              obscureText: true,
              controller: repNewPassController,
              decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.repeatNewPass,
                  errorText: errorRep,
                  labelStyle: TextStyle(fontSize: 10, color: (context.watch<MainAppProvider>().theme == AppEssentials.darkMode)? AppEssentials.colorsMap["appMainLightBlue"]:AppEssentials.colorsMap["appMainBlue"]),
                  errorStyle: TextStyle(fontSize: 10)),
            ),
            ElevatedButton(
                onPressed: () {
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
                      errorOldText =
                          AppLocalizations.of(context)!.errorWrongPass;
                    } else {
                      if (oldPassController.text == newPassController.text) {
                        errorNewText =
                            AppLocalizations.of(context)!.errorSamePass;
                      } else {
                        if (newPassController.text.length < 8) {
                          errorNewText =
                              AppLocalizations.of(context)!.passwordNotValid;
                        } else {
                          if (newPassController.text !=
                              repNewPassController.text) {
                            errorRepText =
                                AppLocalizations.of(context)!.diffPasswords;
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
                            .convert(utf8.encode(newPassController.text)).toString());
                  } else {
                    setState(() {
                      errorOld = errorOldText;
                      errorNew = errorNewText;
                      errorRep = errorRepText;
                    });
                  }
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
}

class ImageUploadContextDialog extends StatefulWidget {
  const ImageUploadContextDialog({super.key});

  @override
  State<ImageUploadContextDialog> createState() => _ImageUploadContextDialogState();
}

class _ImageUploadContextDialogState extends State<ImageUploadContextDialog> {
  TextEditingController linkController = TextEditingController();
  String? errorTxt;
  @override
  Widget build(BuildContext context) {
    return Dialog(
                      child:Container(
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
                              labelStyle: TextStyle(fontSize: 10, color: (context.watch<MainAppProvider>().theme == AppEssentials.darkMode)? AppEssentials.colorsMap["appMainLightBlue"]:AppEssentials.colorsMap["appMainBlue"]),
                              errorStyle: TextStyle(fontSize: 10)
                            ),
                          ),
                          ElevatedButton(onPressed: (){
                            if(linkController.text.length>0 && linkController.text.length<256){
                              Navigator.pop(context, linkController.text);
                            } else {
                              setState(() {
                                errorTxt = "${AppLocalizations.of(context)!.sizePassed} (1-254)";
                              });
                            }
                          }, child: Text(AppLocalizations.of(context)!.loadImg))
                        ],
                      ),
                    ));
  }
}