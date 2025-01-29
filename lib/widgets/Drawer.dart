import 'package:flutter/material.dart';
import 'package:magik_antivirus/viewmodels/MainAppProvider.dart';
import 'package:magik_antivirus/viewmodels/StyleProvider.dart';
import 'package:magik_antivirus/views/AboutView.dart';
import 'package:provider/provider.dart';
import 'package:country_flags/country_flags.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:magik_antivirus/views/UserConfigView/UserView.dart';
import 'package:magik_antivirus/views/ForbiddenFilesView/FFoldersView.dart';

///Drawer de la aplicación
///
///En la barra superior del menú principal, aparece un icono con la imagen del perfil del usuario. Si se pulsa ahí, aparecerá el Drawer con distintos widgets:
///
/// -	El primero es la cabecera del Drawer, que muestra la foto de perfil del usuario, su nombre y su correo. Si el usuario pulsa en el widget, accederá al menú de usuario
///
/// -	El segundo apartado es un tile con la imagen y el texto de carpetas prohibidas. Si se pulsa, el programa navegará hacia la vista de carpetas prohibidas
///
/// -	El tercero es un tile con una imagen y un texto de 'Traducir', al final del tile aparecerá un DropDown que mostrará distintos idiomas a traducir. Cuando el usuario elija un idioma, todos los textos del programa cambiarán al idioma elegido
///
/// -	El cuarto es un tile para cambiar el modo de claro a oscuro y viceversa. Con el switch que hay al final del tile, el usuario puede alternar entre los modos claro y oscuro
///
/// -	El quinto es un tile que, si el usuario lo pulsa, accederá a una ventana con toda la información de la versión actual del programa
class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool modoClaro = context.watch<StyleProvider>().isLightModeActive;
    return Drawer(
        child: SingleChildScrollView(
      child: Column(
        children: [
          Semantics(
            label: AppLocalizations.of(context)!.userTile,
            hint: AppLocalizations.of(context)!.userContext,
            child: GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => UserView()));
              },
              child: DrawerHeader(
                margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: (context
                                      .watch<MainAppProvider>()
                                      .thisUser !=
                                  null &&
                              context
                                      .watch<MainAppProvider>()
                                      .thisUser!
                                      .image !=
                                  null)
                          ? NetworkImage(
                              context.watch<MainAppProvider>().thisUser!.image!)
                          : null,
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text((context.watch<MainAppProvider>().thisUser !=
                                  null)
                              ? context
                                  .watch<MainAppProvider>()
                                  .thisUser!
                                  .username
                              : "No user"),
                          Text((context.watch<MainAppProvider>().thisUser !=
                                  null)
                              ? context.watch<MainAppProvider>().thisUser!.email
                              : "No user")
                        ],
                      ),
                    ),
                    Text(">")
                  ],
                ),
              ),
            ),
          ),
          Semantics(
            label: AppLocalizations.of(context)!.drawerFFolders,
            hint: AppLocalizations.of(context)!.ffoldersContext,
            child: GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ForbFoldersView()));
              },
              child: ListTile(
                leading: Icon(Icons.folder,
                    color: context
                        .watch<StyleProvider>()
                        .colorsMap[(modoClaro) ? "appMain" : "appLight"]),
                title: Text(
                  AppLocalizations.of(context)!.drawerFFolders,
                  style: TextStyle(
                    color: (context
                        .watch<StyleProvider>()
                        .colorsMap[(modoClaro) ? "appMain" : "appLight"]),
                  ),
                ),
              ),
            ),
          ),
          Semantics(
            label: AppLocalizations.of(context)!.drawerTranslate,
            hint: AppLocalizations.of(context)!.translate,
            child: ListTile(
              leading: Icon(Icons.translate,
                  color: context
                      .watch<StyleProvider>()
                      .colorsMap[(modoClaro) ? "appMain" : "appLight"]),
              title: Text(
                AppLocalizations.of(context)!.drawerTranslate,
                style: TextStyle(
                  color: (context
                      .watch<StyleProvider>()
                      .colorsMap[(modoClaro) ? "appMain" : "appLight"]),
                ),
              ),
              trailing: DropdownButton(
                  items: [
                    DropdownMenuItem(
                      child: CountryFlag.fromCountryCode("ES"),
                      value: "es",
                    ),
                    DropdownMenuItem(
                      child: CountryFlag.fromCountryCode("US"),
                      value: "en",
                    ),
                    DropdownMenuItem(
                      child: CountryFlag.fromCountryCode("DE"),
                      value: "de",
                    ),
                    DropdownMenuItem(
                      child: CountryFlag.fromCountryCode("FR"),
                      value: "fr",
                    )
                  ],
                  value: context.watch<MainAppProvider>().language.languageCode,
                  onChanged: (value) {
                    context.read<MainAppProvider>().changeLang(value!);
                  }),
            ),
          ),
          Semantics(
            label: AppLocalizations.of(context)!.drawerDarkMode,
            hint: AppLocalizations.of(context)!.darkModeContext,
            child: ListTile(
              leading: Icon(Icons.dark_mode,
                  color: context
                      .watch<StyleProvider>()
                      .colorsMap[(modoClaro) ? "appMain" : "appLight"]),
              title: Text(
                AppLocalizations.of(context)!.drawerDarkMode,
                style: TextStyle(
                  color: (context
                      .watch<StyleProvider>()
                      .colorsMap[(modoClaro) ? "appMain" : "appLight"]),
                ),
              ),
              trailing: Switch(
                  value: !context.watch<StyleProvider>().isLightModeActive,
                  onChanged: (value) {
                    context.read<StyleProvider>().changeThemeMode();
                  }),
            ),
          ),
          Semantics(
            label: AppLocalizations.of(context)!.drawerAppVer,
            hint: AppLocalizations.of(context)!.drawerAppVerContext,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AboutView(
                              language: context
                                  .watch<MainAppProvider>()
                                  .language
                                  .languageCode,
                            )));
              },
              child: ListTile(
                leading: Icon(Icons.info,
                    color: context
                        .watch<StyleProvider>()
                        .colorsMap[(modoClaro) ? "appMain" : "appLight"]),
                title: Text(
                  AppLocalizations.of(context)!.appVer,
                  style: TextStyle(
                    color: (context
                        .watch<StyleProvider>()
                        .colorsMap[(modoClaro) ? "appMain" : "appLight"]),
                  ),
                ),
              ),
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.brush,
              color: context
                  .watch<StyleProvider>()
                  .colorsMap[(modoClaro) ? "appMain" : "appLight"],
            ),
            title: Text("Prueba: Cambiar Color"),
            trailing: DropdownButton<Color>(
                items: [
                  DropdownMenuItem(
                    child: Container(
                        width: 20,
                        height: 20,
                        color: Color.fromARGB(255, 14, 54, 111)),
                    value: Color.fromARGB(255, 14, 54, 111),
                  ),
                  DropdownMenuItem(
                    child: Container(
                        width: 20,
                        height: 20,
                        color: Color.fromARGB(255, 14, 111, 14)),
                    value: Color.fromARGB(255, 14, 111, 14),
                  ),
                  DropdownMenuItem(
                    child: Container(
                        width: 20,
                        height: 20,
                        color: Color.fromARGB(255, 199, 199, 61)),
                    value: Color.fromARGB(255, 199, 199, 61),
                  ),
                  DropdownMenuItem(
                    child: Container(
                        width: 20,
                        height: 20,
                        color: Color.fromARGB(255, 0, 0, 0)),
                    value: Color.fromARGB(255, 0, 0, 0),
                  ),
                  DropdownMenuItem(
                    child: Container(
                        width: 20,
                        height: 20,
                        color: Color.fromARGB(255, 111, 17, 14)),
                    value: Color.fromARGB(255, 111, 17, 14),
                  ),
                  DropdownMenuItem(
                    child: Container(
                        width: 20,
                        height: 20,
                        color: Color.fromARGB(255, 14, 111, 111)),
                    value: Color.fromARGB(255, 14, 111, 111),
                  ),
                  DropdownMenuItem(
                    child: Container(
                        width: 20,
                        height: 20,
                        color: Color.fromARGB(255, 88, 14, 111)),
                    value: Color.fromARGB(255, 88, 14, 111),
                  ),
                ],
                onChanged: (value) {
                  context.read<StyleProvider>().changeThemeColor(value!);
                },
                value: context.watch<StyleProvider>().mainColor),
          ),
        ],
      ),
    ));
  }
}
