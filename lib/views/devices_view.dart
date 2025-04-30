import 'package:flutter/material.dart';
import 'package:magik_antivirus/utils/app_essentials.dart';
import 'package:magik_antivirus/viewmodels/style_provider.dart';
import 'package:magik_antivirus/viewmodels/user_data_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:magik_antivirus/model/device.dart';
import 'package:magik_antivirus/data_access/device_dao.dart';
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
    bool modoClaro = context.watch<StyleProvider>().isLightModeActive;
    return (devs.isEmpty)
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Semantics(
            label: AppLocalizations.of(context)!.devlist,
            child: ListView.builder(
                itemCount: devs.length,
                itemBuilder: (context, index) {
                  Device dev = devs[index];
                  return GestureDetector(
                      onLongPress: () {
                        if (dev.id! != AppEssentials.dev!.id!) {
                          showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                    shape: (context
                                            .read<StyleProvider>()
                                            .isLightModeActive)
                                        ? RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          )
                                        : null,
                                    title: FittedBox(
                                        fit: BoxFit.fitWidth,
                                        child: Text(
                                            ("${AppLocalizations.of(context)!.unlinkDevice}"))),
                                    content: Text(AppLocalizations.of(context)!
                                        .unlinkDeviceContext(dev.devName)),
                                    actions: [
                                      TextButton(
                                          onPressed: () async {
                                            dev.user = null;
                                            await DeviceDAO().update(dev);
                                            loadList();
                                            Navigator.pop(context);
                                          },
                                          child: Text(
                                            AppLocalizations.of(context)!
                                                .unlink,
                                            style: TextStyle(
                                                color: context
                                                    .read<StyleProvider>()
                                                    .colorsMap["white"]),
                                          )),
                                      TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text(
                                              AppLocalizations.of(context)!
                                                  .cancel,
                                              style: TextStyle(
                                                  color: context
                                                      .read<StyleProvider>()
                                                      .colorsMap["white"])))
                                    ],
                                  ));
                        }
                      },
                      child: Card(
                          margin: EdgeInsets.all(10),
                          child: Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  color:
                                      context.watch<StyleProvider>().colorsMap[
                                          (modoClaro) ? "white" : "appMain"],
                                  border: Border.all(
                                      color: context
                                              .watch<StyleProvider>()
                                              .colorsMap[
                                          (modoClaro)
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
                                        child: Text(
                                          dev.devName,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: context
                                                      .watch<StyleProvider>()
                                                      .colorsMap[
                                                  (modoClaro)
                                                      ? "appMain"
                                                      : "appLight"],
                                              fontSize: 25),
                                          softWrap: true,
                                        ),
                                      ),
                                      switch (dev.devType) {
                                        "android" => Icon(Icons.android,
                                            size: 100,
                                            color: context
                                                    .watch<StyleProvider>()
                                                    .colorsMap[
                                                (modoClaro)
                                                    ? "appMain"
                                                    : "appLight"]),
                                        "ios" => Icon(Icons.apple,
                                            size: 100,
                                            color: context
                                                    .watch<StyleProvider>()
                                                    .colorsMap[
                                                (modoClaro)
                                                    ? "appMain"
                                                    : "appLight"]),
                                        "macos" => SvgPicture.asset(
                                            "assets/icons/macos.svg",
                                            width: 100,
                                            height: 100,
                                            color: context
                                                    .watch<StyleProvider>()
                                                    .colorsMap[
                                                (modoClaro)
                                                    ? "appMain"
                                                    : "appLight"]),
                                        "linux" => SvgPicture.asset(
                                            "assets/icons/linux.svg",
                                            width: 100,
                                            height: 100,
                                            color: context
                                                    .watch<StyleProvider>()
                                                    .colorsMap[
                                                (modoClaro)
                                                    ? "appMain"
                                                    : "appLight"]),
                                        "windows" => SvgPicture.asset(
                                            "assets/icons/windows.svg",
                                            width: 100,
                                            height: 100,
                                            color: context
                                                    .watch<StyleProvider>()
                                                    .colorsMap[
                                                (modoClaro)
                                                    ? "appMain"
                                                    : "appLight"]),
                                        String() => throw UnimplementedError(),
                                      }
                                    ],
                                  ),
                                  Text(dev.devType),
                                  Text(
                                    "${AppLocalizations.of(context)!.lastAnalysis} ${dev.lastScan}",
                                  ),
                                  Text(
                                      "${AppLocalizations.of(context)!.regDate} ${dev.joinIn}")
                                ],
                              ))));
                }),
          );
  }

  void loadList() async {
    List<Device> auxList = (await DeviceDAO().list());
    auxList.retainWhere((element) =>
        element.user == context.read<UserDataProvider>().thisUser!.email);
    setState(() {
      devs = auxList;
    });
  }
}
