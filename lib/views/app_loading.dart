import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:magik_antivirus/viewmodels/user_data_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

///Pantalla de carga de la aplicación al inicio de esta.
class AppLoadingView extends StatelessWidget {
  const AppLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          Text(switch (context.watch<UserDataProvider>().loadingStatus) {
            1 => AppLocalizations.of(context)!.loadingSigDB,
            2 => AppLocalizations.of(context)!.readingQuarantine,
            3 => AppLocalizations.of(context)!.finishingUp,
            int() => AppLocalizations.of(context)!.loadingLocDB,
          })
        ],
      )),
    );
  }
}
