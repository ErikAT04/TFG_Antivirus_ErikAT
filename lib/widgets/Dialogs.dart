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
      child: Wrap(
        
        alignment: WrapAlignment.center,
        children: [
          TextField(
            controller: emailController,
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!.email,
              errorText: errorEmail,
            ),
          ),
          TextField(
            controller: unameController,
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!.uname,
              errorText: errorUname,
            ),
          ),
          TextField(
            controller: passController,
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!.pass,
              errorText: errorPass,
            ),
            obscureText: true,
          ),
          TextField(
            controller: repPassController,
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!.repPass,
              errorText: errorRepPass,
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
    );
  }
}
