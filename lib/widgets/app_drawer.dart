import 'package:flutter/material.dart';
import 'dropdown_color_menu_item.dart';
import 'package:provider/provider.dart';
import 'package:country_flags/country_flags.dart';
import 'package:magik_antivirus/views/about_app_view.dart';
import 'package:magik_antivirus/views/user_data_view.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:magik_antivirus/viewmodels/style_provider.dart';
import 'package:magik_antivirus/viewmodels/language_provider.dart';
import 'package:magik_antivirus/views/forbidden_folders_view.dart';
import 'package:magik_antivirus/viewmodels/user_data_provider.dart';
import 'package:magik_antivirus/widgets/dropdown_color_menu_item.dart';


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
                      backgroundImage:
                          (context.watch<UserDataProvider>().thisUser != null &&
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
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text((context.watch<UserDataProvider>().thisUser !=
                                  null)
                              ? context
                                  .watch<UserDataProvider>()
                                  .thisUser!
                                  .username
                              : "No user"),
                          Text((context.watch<UserDataProvider>().thisUser !=
                                  null)
                              ? context
                                  .watch<UserDataProvider>()
                                  .thisUser!
                                  .email
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
                  value:
                      context.watch<LanguageNotifier>().language.languageCode,
                  onChanged: (value) {
                    context.read<LanguageNotifier>().changeLang(value!);
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
            label: AppLocalizations.of(context)!.changeColor,
            hint: AppLocalizations.of(context)!.changeColorContext,
            child: ListTile(
            leading: Icon(
              Icons.brush,
              color: context
                  .watch<StyleProvider>()
                  .colorsMap[(modoClaro) ? "appMain" : "appLight"],
            ),
            title: Text(AppLocalizations.of(context)!.changeColor),
            trailing: DropdownButton<Color>(
                items: [
                  DropDownColorItem(color: Color.fromARGB(255, 14, 54, 111)),
                  DropDownColorItem(color: Color.fromARGB(255, 14, 111, 14)),
                  DropDownColorItem(color: Color.fromARGB(255, 199, 199, 61)),
                  DropDownColorItem(color: Color.fromARGB(255, 0, 0, 0)),
                  DropDownColorItem(color: Color.fromARGB(255, 111, 17, 14)),
                  DropDownColorItem(color: Color.fromARGB(255, 14, 111, 111)),
                  DropDownColorItem(color: Color.fromARGB(255, 88, 14, 111)),
                ],
                onChanged: (value) {
                  context.read<StyleProvider>().changeThemeColor(value!);
                },
                value: context.watch<StyleProvider>().mainColor),
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
                                  .watch<LanguageNotifier>()
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
          )
        ],
      ),
    ));
  }
}
