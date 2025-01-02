import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:magik_antivirus/main.dart';
import 'package:magik_antivirus/utils/AppEssentials.dart';
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
              backgroundImage: NetworkImage(
                      "https://i.redd.it/happy-birthday-kinich-v0-elooz82x370e1.jpg?width=3000&format=pjpg&auto=webp&s=2f4218a8a48cc9adb4d0ce52f1ce7894f584c7b5")),
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
