import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:magik_antivirus/viewmodels/user_data_provider.dart';


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
        children: [CircularProgressIndicator(), Text(context.watch<UserDataProvider>().loadingStatus)],
      )),
    );
  }
}
