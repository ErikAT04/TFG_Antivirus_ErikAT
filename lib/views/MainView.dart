import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:magik_antivirus/main.dart';
import 'package:magik_antivirus/model/Device.dart';
import 'package:magik_antivirus/views/AppVaultView/VaultView.dart';
import 'package:magik_antivirus/views/DevicesView/DevicesView.dart';
import 'package:magik_antivirus/views/ScannerView/AnalysisView.dart';
import 'package:magik_antivirus/widgets/Drawer.dart';
import 'package:provider/provider.dart';

class Mainview extends StatefulWidget {
  const Mainview({super.key});

  @override
  State<Mainview> createState() => _MainviewState();
}

class _MainviewState extends State<Mainview> {

  int actualPage = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child:Text(switch (actualPage) {
          0 => AppLocalizations.of(context)!.mainPage,
          1 => AppLocalizations.of(context)!.vault,
          2 => AppLocalizations.of(context)!.myDevices,
          int() => throw UnimplementedError(),
        })),
        leading: Builder(builder: (context) {
          return Row(
            children: [
              SizedBox(width: 10,),
              GestureDetector(
            child: CircleAvatar(
              backgroundImage: (context.watch<MainAppProvider>().thisUser!=null && context.watch<MainAppProvider>().thisUser!.userIMGData!=null)?NetworkImage(context.watch<MainAppProvider>().thisUser!.userIMGData!):null,),
            onTap: () {
              Scaffold.of(context).openDrawer();
            },
          ),
          ]
          );
        }),
      ),
      drawer: AppDrawer(),
      bottomNavigationBar: BottomNavigationBar(items: [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: AppLocalizations.of(context)!.mainPage),
        BottomNavigationBarItem(icon: Icon(Icons.file_open), label: AppLocalizations.of(context)!.vaultLow),
        BottomNavigationBarItem(icon: Icon(Icons.device_hub), label: AppLocalizations.of(context)!.devicesLow)
      ],
      currentIndex: actualPage,
      onTap: (value){
        setState(() {
          actualPage = value;
        });
      },),
      body: switch(actualPage){
        0 => AnalysisView(),
        1 => AppVault(),
        2 => AppDevicesView(),
        int() => throw UnimplementedError(),
      },
    );
  }
}
