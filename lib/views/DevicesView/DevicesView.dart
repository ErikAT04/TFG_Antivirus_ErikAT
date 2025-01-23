import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:magik_antivirus/main.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:magik_antivirus/model/Device.dart';
import 'package:magik_antivirus/DataAccess/DeviceDAO.dart';
import 'package:magik_antivirus/utils/StyleEssentials.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

///Vista de dispostivos
class AppDevicesView extends StatefulWidget {
  const AppDevicesView({super.key});

  @override
  State<AppDevicesView> createState() => AppDevicesViewState();
}

///Estado de la vista de dispositivos
class AppDevicesViewState extends State<AppDevicesView> {
  List<Device> devs = []; //Lista de dispositivos

  ///Inicio del estado
  ///
  ///Carga la lista de dispositivos de la base de datos de MySQL
  @override
  void initState() {
    super.initState();
    loadList();
  }

  ///Muestra al usuario todos los dispositivos que tiene vinculados a su cuenta.
  ///
  ///Puede ver el tipo de sistema operativo que tiene, el nombre del dispositivo y tanto la fecha de su último escaneo como la fecha de registro en esta cuenta
  @override
  Widget build(BuildContext context) {
    bool modoClaro =
        context.watch<MainAppProvider>().theme == StyleEssentials.lightMode;
    return (devs.length == 0)
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Semantics(
            label: AppLocalizations.of(context)!.devlist,
            child: ListView.builder(
                itemCount: devs.length,
                itemBuilder: (context, index) {
                  Device dev = devs[index];
                  return Card(
                      margin: EdgeInsets.all(10),
                      child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: StyleEssentials.colorsMap[
                                  (modoClaro) ? "white" : "appMainBlue"],
                              border: Border.all(
                                  color: StyleEssentials.colorsMap[(modoClaro)
                                      ? "appMainBlue"
                                      : "appMainLightBlue"]!,
                                  width: 3),
                              borderRadius: BorderRadius.circular(10)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(dev.dev_name,
                                        style: TextStyle(
                                            color: StyleEssentials.colorsMap[
                                                (modoClaro)
                                                    ? "appMainBlue"
                                                    : "appMainLightBlue"],
                                            fontSize: 40),
                                        overflow: TextOverflow.ellipsis),
                                  ),
                                  switch (dev.dev_type) {
                                    "android" => Icon(Icons.android,
                                        size: 100,
                                        color: StyleEssentials.colorsMap[
                                            (modoClaro)
                                                ? "appMainBlue"
                                                : "appMainLightBlue"]),
                                    "ios" => Icon(Icons.apple,
                                        size: 100,
                                        color: StyleEssentials.colorsMap[
                                            (modoClaro)
                                                ? "appMainBlue"
                                                : "appMainLightBlue"]),
                                    "macos" => SvgPicture.asset(
                                        "assets/icons/macos.svg",
                                        width: 100,
                                        height: 100,
                                        color: StyleEssentials.colorsMap[
                                            (modoClaro)
                                                ? "appMainBlue"
                                                : "appMainLightBlue"]),
                                    "linux" => SvgPicture.asset(
                                        "assets/icons/linux.svg",
                                        width: 100,
                                        height: 100,
                                        color: StyleEssentials.colorsMap[
                                            (modoClaro)
                                                ? "appMainBlue"
                                                : "appMainLightBlue"]),
                                    "windows" => SvgPicture.asset(
                                        "assets/icons/windows.svg",
                                        width: 100,
                                        height: 100,
                                        color: StyleEssentials.colorsMap[
                                            (modoClaro)
                                                ? "appMainBlue"
                                                : "appMainLightBlue"]),
                                    String() => throw UnimplementedError(),
                                  }
                                ],
                              ),
                              Text(dev.dev_type),
                              Text(
                                "${AppLocalizations.of(context)!.lastAnalysis} ${dev.last_scan}",
                              ),
                              Text(
                                  "${AppLocalizations.of(context)!.regDate} ${dev.join_in}")
                            ],
                          )));
                }),
          );
  }

  void loadList() async {
    List<Device> auxList = await DeviceDAO().list();
    setState(() {
      devs = auxList;
    });
  }
}
