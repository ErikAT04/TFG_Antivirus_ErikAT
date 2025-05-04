import 'package:flutter/material.dart';
import 'package:magik_antivirus/utils/app_essentials.dart';
import 'package:magik_antivirus/viewmodels/style_provider.dart';
import 'package:magik_antivirus/viewmodels/user_data_provider.dart';
import 'package:provider/provider.dart';
import 'package:magik_antivirus/widgets/app_drawer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:magik_antivirus/views/app_vault_view.dart';
import 'package:magik_antivirus/views/devices_view.dart';
import 'package:magik_antivirus/views/analysis_view.dart';

///Vista de la pantalla principal
class Mainview extends StatefulWidget {
  const Mainview({super.key});

  @override
  State<Mainview> createState() => MainviewState();
}

///Estado de la vista principal:
class MainviewState extends State<Mainview> {
  ///Indice de la pagina (Guía al menú de navegación inferior)
  int actualPage = 0;

  final _vaultKey = GlobalKey<AppVaultState>();

  AnalysisView aView = AnalysisView();

  ///En este caso, se precargan los distintos dispositivos y carpetas ocultas
  @override
  void initState() {
    super.initState();
    context
        .read<UserDataProvider>()
        .reloadFFolders(); //Precarga de los archivos prohibidos
  }

  ///El usuario verá de forma constante el título de la pestaña en la que se encuentra y una barra de navegación inferior con la que puede ir a distintas páginas de la aplicación.
  ///
  ///Dependiendo de qué pestaña esté seleccionada en el menú inferior, el contenido del cuerpo (body) de la vista será distinta.
  ///
  ///En la barra superior del menú principal, aparece un icono con la imagen del perfil del usuario. Si se pulsa ahí, aparecerá el Drawer.
  @override
  Widget build(BuildContext context) {
    var selectedFiles = context.watch<UserDataProvider>().selectedFiles;
    return Scaffold(
        appBar: AppBar(
          bottom: PreferredSize(
              preferredSize: Size.fromHeight(4),
              child: Container(
                color: context.watch<StyleProvider>().palette[
                    (context.watch<StyleProvider>().isLightModeActive)
                        ? "appMain"
                        : "appLight"],
                height: 1,
              )),
          title: (selectedFiles.isEmpty)
              ? ExcludeSemantics(
                  child: Text(switch (actualPage) {
                  0 => AppLocalizations.of(context)!.mainPage,
                  1 => AppLocalizations.of(context)!.vault,
                  2 => AppLocalizations.of(context)!.myDevices,
                  int() => throw UnimplementedError(),
                }))
              : ExcludeSemantics(
                  child: FittedBox(
                      fit: BoxFit.fitWidth,
                      child: Text(
                          "${selectedFiles.length} ${(selectedFiles.length > 1) ? AppLocalizations.of(context)!.filesSelected : AppLocalizations.of(context)!.fileSelected}"))),
          leading: (selectedFiles.isEmpty)
              ? Builder(builder: (context) {
                  return Row(children: [
                    SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      child: CircleAvatar(
                        backgroundImage:
                            (context.watch<UserDataProvider>().thisUser !=
                                        null &&
                                    context
                                            .watch<UserDataProvider>()
                                            .thisUser!
                                            .image !=
                                        null)
                                ? NetworkImage(context
                                    .watch<UserDataProvider>()
                                    .thisUser!
                                    .image!)
                                : null,
                      ),
                      onTap: () {
                        Scaffold.of(context).openDrawer();
                      },
                    ),
                  ]);
                })
              : IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    context.read<UserDataProvider>().removeAllFiles();
                  },
                ),
          actions: (selectedFiles.isEmpty)
              ? null
              : [
                  IconButton(
                    icon: Icon(Icons.replay),
                    onPressed: () async {
                      for (var file in selectedFiles) {
                        await AppEssentials.getOutOfQuarantine(file);
                        _vaultKey.currentState!.loadList();
                      }
                      context.read<UserDataProvider>().removeAllFiles();
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () async {
                      for (var file in selectedFiles) {
                        await AppEssentials.eraseFile(file);
                        _vaultKey.currentState!.loadList();
                      }
                      context.read<UserDataProvider>().removeAllFiles();
                    },
                  ),
                ],
        ),
        drawer: AppDrawer(),
        bottomNavigationBar: (MediaQuery.sizeOf(context).width > 720 ||
                MediaQuery.sizeOf(context).width < 300)
            ? null
            : BottomNavigationBar(
                items: [
                  BottomNavigationBarItem(
                      icon: Semantics(
                        child: Icon(Icons.home),
                        label: AppLocalizations.of(context)!.mainPage,
                        hint: AppLocalizations.of(context)!.mainPageContext,
                      ),
                      label: AppLocalizations.of(context)!.mainPage),
                  BottomNavigationBarItem(
                      icon: Semantics(
                        child: Icon(Icons.file_open),
                        label: AppLocalizations.of(context)!.vaultLow,
                        hint: AppLocalizations.of(context)!.vaultContext,
                      ),
                      label: AppLocalizations.of(context)!.vaultLow),
                  BottomNavigationBarItem(
                      icon: Semantics(
                        child: Icon(Icons.device_hub),
                        label: AppLocalizations.of(context)!.devicesLow,
                        hint: AppLocalizations.of(context)!.deviceContext,
                      ),
                      label: AppLocalizations.of(context)!.devicesLow)
                ],
                currentIndex: actualPage,
                onTap: (value) {
                  if (value != 1) {
                    context.read<UserDataProvider>().removeAllFiles();
                  }
                  setState(() {
                    actualPage = value;
                  });
                },
              ),
        body: Row(
          children: [
            (MediaQuery.sizeOf(context).width > 720 ||
                    MediaQuery.sizeOf(context).width < 300)
                ? NavigationRail(
                    extended: MediaQuery.sizeOf(context).width > 720,
                    destinations: [
                      NavigationRailDestination(
                          icon: Semantics(
                            child: Icon(Icons.home),
                            label: AppLocalizations.of(context)!.mainPage,
                            hint: AppLocalizations.of(context)!.mainPageContext,
                          ),
                          label: ExcludeSemantics(
                              child: Text(
                                  AppLocalizations.of(context)!.mainPage))),
                      NavigationRailDestination(
                          icon: Semantics(
                            child: Icon(Icons.file_open),
                            label: AppLocalizations.of(context)!.vaultLow,
                            hint: AppLocalizations.of(context)!.vaultContext,
                          ),
                          label: ExcludeSemantics(
                              child: Text(
                                  AppLocalizations.of(context)!.vaultLow))),
                      NavigationRailDestination(
                          icon: Semantics(
                            child: Icon(Icons.device_hub),
                            label: AppLocalizations.of(context)!.devicesLow,
                            hint: AppLocalizations.of(context)!.deviceContext,
                          ),
                          label: ExcludeSemantics(
                              child: Text(
                                  AppLocalizations.of(context)!.devicesLow)))
                    ],
                    selectedIndex: actualPage,
                    onDestinationSelected: (value) {
                      setState(() {
                        actualPage = value;
                      });
                    },
                  )
                : Padding(padding: EdgeInsets.all(0)),
            Expanded(
              child: switch (actualPage) {
                0 => aView,
                1 => AppVault(
                    key: _vaultKey,
                  ),
                2 => AppDevicesView(),
                int() => throw UnimplementedError(),
              },
            )
          ],
        ));
  }
}
