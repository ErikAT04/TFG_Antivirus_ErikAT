import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:magik_antivirus/main.dart';
import 'package:magik_antivirus/model/Device.dart';
import 'package:magik_antivirus/utils/AppEssentials.dart';
import 'package:magik_antivirus/views/DevicesView/DevicesAdd.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';


class AppDevicesView extends StatefulWidget {
  const AppDevicesView({super.key});

  @override
  State<AppDevicesView> createState() => _AppDevicesViewState();
}

class _AppDevicesViewState extends State<AppDevicesView> {
  List<Device> myDevices = [];
  @override
  Widget build(BuildContext context) {
    bool modoClaro = context.watch<MainAppProvider>().theme == AppEssentials.lightMode;
    return Column(
      children: [
        ElevatedButton(onPressed: () async{
          Device? dev = await Navigator.push(context, MaterialPageRoute(builder: (context)=>DevicesAdd()));
          if (dev!=null){
            setState(() {
              myDevices.add(dev);
            });
          }
        }, child: Icon(Icons.add)),
        Expanded(child: ListView.builder(
          itemCount: myDevices.length,
          itemBuilder: (context, index){
            Device dev = myDevices[index];
            return Card(
              margin: EdgeInsets.all(10),
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppEssentials.colorsMap[(modoClaro)?"white":"appMainBlue"],
                  border: Border.all(color: AppEssentials.colorsMap[(modoClaro)?"appMainBlue":"appMainLightBlue"]!, width: 3),
                  borderRadius: BorderRadius.circular(10)
                ),
                child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(child: Text(dev.name, style: TextStyle(color: AppEssentials.colorsMap[(modoClaro)?"appMainBlue":"appMainLightBlue"], fontSize: 40), overflow: TextOverflow.ellipsis),),
                      switch(dev.type){
                        "Android" => Icon(Icons.android, size: 100, color: AppEssentials.colorsMap[(modoClaro)?"appMainBlue":"appMainLightBlue"]),
                        "Ios" => Icon(Icons.apple, size: 100,color: AppEssentials.colorsMap[(modoClaro)?"appMainBlue":"appMainLightBlue"]),
                        "Macos" => SvgPicture.asset("assets/icons/macos.svg", width: 100, height: 100,color: AppEssentials.colorsMap[(modoClaro)?"appMainBlue":"appMainLightBlue"]),
                        "Linux" => SvgPicture.asset("assets/icons/linux.svg", width: 100, height: 100,color: AppEssentials.colorsMap[(modoClaro)?"appMainBlue":"appMainLightBlue"]),
                        "Windows" => SvgPicture.asset("assets/icons/windows.svg", width: 100, height: 100,color: AppEssentials.colorsMap[(modoClaro)?"appMainBlue":"appMainLightBlue"]),
                        String() => throw UnimplementedError(),
                      }
                    ],
                  ),
                  Text(dev.type),
                  Text("${AppLocalizations.of(context)!.lastAnalysis} ${dev.last_scan}",),
                  Text("${AppLocalizations.of(context)!.regDate} ${dev.join_in}")
                ],
              ),
              ),
            );
          }))
      ],
    );
  }
}