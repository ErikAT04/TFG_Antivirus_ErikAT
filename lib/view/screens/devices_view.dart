import 'package:flutter/material.dart';
import 'package:magik_antivirus/model/utils/app_essentials.dart';
import 'package:magik_antivirus/viewmodel/style_provider.dart';
import 'package:magik_antivirus/viewmodel/user_data_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:magik_antivirus/model/data_classes/device.dart';
import 'package:magik_antivirus/model/data_access/device_dao.dart';
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
  bool loading = true;

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
    return (loading)
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Semantics(
            label: AppLocalizations.of(context)!.devlist,
            child: (devs.isEmpty)
                ? Center(
                    child: Padding(
                    child: Text(
                      AppLocalizations.of(context)!.errorLoading,
                      textAlign: TextAlign.center,
                    ),
                    padding: EdgeInsets.all(10),
                  )) //Técnicamente siempre debería haber al menos un dispositivo: el dispositivo local.
                : ListView.builder(
                    itemCount: devs.length,
                    itemBuilder: (context, index) {
                      Device dev = devs[index];
                      return GestureDetector(
                          onLongPress: () {
                            if (dev.id! != AppEssentials.dev!.id!) {
                              showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                        title: FittedBox(
                                            fit: BoxFit.fitWidth,
                                            child: Text(
                                                ("${AppLocalizations.of(context)!.unlinkDevice}"))),
                                        content: Text(AppLocalizations.of(
                                                context)!
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
                                                style: (!modoClaro)
                                                    ? TextStyle(
                                                        color: context
                                                            .read<
                                                                StyleProvider>()
                                                            .palette["white"])
                                                    : null,
                                              )),
                                          TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: Text(
                                                  AppLocalizations.of(context)!
                                                      .cancel,
                                                  style: TextStyle(
                                                      color: (modoClaro)
                                                          ? null
                                                          : context
                                                              .read<
                                                                  StyleProvider>()
                                                              .palette["white"])))
                                        ],
                                      ));
                            }
                          },
                          child: Card(
                              margin: EdgeInsets.all(10),
                              child: Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      color: context
                                              .watch<StyleProvider>()
                                              .palette[
                                          (modoClaro) ? "white" : "appMain"],
                                      border: Border.all(
                                          color: context
                                                  .watch<StyleProvider>()
                                                  .palette[
                                              (modoClaro)
                                                  ? "appMain"
                                                  : "appLight"]!,
                                          width: 3),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                                          .palette[
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
                                                        .palette[
                                                    (modoClaro)
                                                        ? "appMain"
                                                        : "appLight"]),
                                            "ios" => Icon(Icons.apple,
                                                size: 100,
                                                color: context
                                                        .watch<StyleProvider>()
                                                        .palette[
                                                    (modoClaro)
                                                        ? "appMain"
                                                        : "appLight"]),
                                            "macos" => SvgPicture.asset(
                                                "assets/icons/macos.svg",
                                                width: 100,
                                                height: 100,
                                                color: context
                                                        .watch<StyleProvider>()
                                                        .palette[
                                                    (modoClaro)
                                                        ? "appMain"
                                                        : "appLight"]),
                                            "linux" => SvgPicture.asset(
                                                "assets/icons/linux.svg",
                                                width: 100,
                                                height: 100,
                                                color: context
                                                        .watch<StyleProvider>()
                                                        .palette[
                                                    (modoClaro)
                                                        ? "appMain"
                                                        : "appLight"]),
                                            "windows" => SvgPicture.asset(
                                                "assets/icons/windows.svg",
                                                width: 100,
                                                height: 100,
                                                color: context
                                                        .watch<StyleProvider>()
                                                        .palette[
                                                    (modoClaro)
                                                        ? "appMain"
                                                        : "appLight"]),
                                            String() =>
                                              throw UnimplementedError(),
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
    List<Device> auxList = (await AppEssentials.getDevicesList(
        context.read<UserDataProvider>().thisUser!));
    setState(() {
      devs = auxList;
      loading = false;
    });
  }
}
