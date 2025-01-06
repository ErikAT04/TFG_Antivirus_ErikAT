import 'dart:convert';

import 'package:crypto/crypto.dart' as crypto;
import 'package:flutter/material.dart';
import 'package:magik_antivirus/DataAccess/DeviceDAO.dart';
import 'package:magik_antivirus/DataAccess/UserDAO.dart';
import 'package:magik_antivirus/model/User.dart';
import 'package:magik_antivirus/utils/AppEssentials.dart';
import 'package:magik_antivirus/views/MainView.dart';
import 'package:magik_antivirus/widgets/Dialogs.dart';
import 'package:provider/provider.dart';
import 'package:magik_antivirus/main.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LogInView extends StatefulWidget {
  const LogInView({super.key});

  @override
  State<LogInView> createState() => LogInViewState();
}

class LogInViewState extends State<LogInView> {
  TextEditingController passController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  String? passErrorText;
  String? emailErrorText;

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
                    onPressed: () async {
                      User? user;
                      String? passError = null;
                      String? emailError = null;
                      bool completedSuccesfully = false;

                      if (passController.text.isEmpty ||
                          emailController.text.isEmpty) {
                        passError = (passController.text.isEmpty)
                            ? AppLocalizations.of(context)!.errorEmptyField
                            : null;
                        emailError = (emailController.text.isEmpty)
                            ? AppLocalizations.of(context)!.errorEmptyField
                            : null;
                      } else {
                        user = await UserDAO().get(emailController.text);
                        if (user == null) {
                          emailError =
                              AppLocalizations.of(context)!.errorNotFound;
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
                            passError =
                                AppLocalizations.of(context)!.errorWrongPass;
                          }
                        }
                      }
                      if (completedSuccesfully) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Mainview()));
                      } else {
                        setState(() {
                          passErrorText = passError;
                          emailErrorText = emailError;
                        });
                      }
                    },
                    child: Text(AppLocalizations.of(context)!.logIn)),
                Padding(padding: EdgeInsets.all(5)),
                ElevatedButton(
                    onPressed: () async {
                      User? u = await showDialog<User>(
                          context: context,
                          builder: (context) => RegisterContextDialog());
                      if (u != null) {
                        AppEssentials.dev!.user = u.email;
                        await DeviceDAO().update(AppEssentials.dev!);
                        context.read<MainAppProvider>().changeUser(u);
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Mainview()));
                      }
                    },
                    child: Text(AppLocalizations.of(context)!.signUp)),
                Padding(padding: EdgeInsets.all(5)),
              ],
            ),
          ),
        ]));
  }
}
