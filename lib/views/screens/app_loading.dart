import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:magik_antivirus/viewmodel/style_provider.dart';

import 'package:provider/provider.dart';
import 'package:magik_antivirus/viewmodel/user_data_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

///Pantalla de carga de la aplicación al inicio de esta.
class AppLoadingView extends StatelessWidget {
  const AppLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    if (context.watch<UserDataProvider>().loadingStatus == -1) {
      return Scaffold(
          body: Padding(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(child: Icon(Icons.error, size: 100)),
            Text(
              AppLocalizations.of(context)!.errorLoading,
              textAlign: TextAlign.center,
            ),
            Text(AppLocalizations.of(context)!.tryAgainLater),
          ],
        ),
        padding: EdgeInsets.all(30),
      ));
    }
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset("assets/m_av.svg",
              width: 300,
              color: context.watch<StyleProvider>().palette[
                  (context.watch<StyleProvider>().isLightModeActive)
                      ? "appMain"
                      : "appLight"]),
          SizedBox(height: MediaQuery.of(context).size.height * 0.05),
          CircularProgressIndicator(),
          Text(switch (context.watch<UserDataProvider>().loadingStatus) {
            1 => AppLocalizations.of(context)!.loadingHashDB,
            2 => AppLocalizations.of(context)!.readingQuarantine,
            3 => AppLocalizations.of(context)!.finishingUp,
            int() => AppLocalizations.of(context)!.loadingLocDB,
          })
        ],
      )),
    );
  }
}
