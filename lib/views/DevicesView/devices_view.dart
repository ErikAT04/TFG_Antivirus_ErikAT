import 'package:flutter/material.dart';
import 'package:magik_antivirus/viewmodels/style_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:magik_antivirus/model/device.dart';
import 'package:magik_antivirus/DataAccess/device_dao.dart';
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
        context.watch<StyleProvider>().isLightModeActive;
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
                              color: context.watch<StyleProvider>().colorsMap[
                                  (modoClaro) ? "white" : "appMain"],
                              border: Border.all(
                                  color: context.watch<StyleProvider>().colorsMap[(modoClaro)
                                      ? "appMain"
                                      : "appLight"]!,
                                  width: 3),
                              borderRadius: BorderRadius.circular(10)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(dev.dev_name, textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: context.watch<StyleProvider>().colorsMap[
                                                (modoClaro)
                                                    ? "appMain"
                                                    : "appLight"],
                                            fontSize: 25), softWrap: true,),
                                  ),
                                  switch (dev.dev_type) {
                                    "android" => Icon(Icons.android,
                                        size: 100,
                                        color: context.watch<StyleProvider>().colorsMap[
                                            (modoClaro)
                                                ? "appMain"
                                                : "appLight"]),
                                    "ios" => Icon(Icons.apple,
                                        size: 100,
                                        color: context.watch<StyleProvider>().colorsMap[
                                            (modoClaro)
                                                ? "appMain"
                                                : "appLight"]),
                                    "macos" => SvgPicture.asset(
                                        "assets/icons/macos.svg",
                                        width: 100,
                                        height: 100,
                                        color: context.watch<StyleProvider>().colorsMap[
                                            (modoClaro)
                                                ? "appMain"
                                                : "appLight"]),
                                    "linux" => SvgPicture.asset(
                                        "assets/icons/linux.svg",
                                        width: 100,
                                        height: 100,
                                        color: context.watch<StyleProvider>().colorsMap[
                                            (modoClaro)
                                                ? "appMain"
                                                : "appLight"]),
                                    "windows" => SvgPicture.asset(
                                        "assets/icons/windows.svg",
                                        width: 100,
                                        height: 100,
                                        color: context.watch<StyleProvider>().colorsMap[
                                            (modoClaro)
                                                ? "appMain"
                                                : "appLight"]),
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
