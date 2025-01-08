import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:magik_antivirus/main.dart';
import 'package:country_flags/country_flags.dart';
import 'package:magik_antivirus/utils/AppEssentials.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:magik_antivirus/views/UserConfigView/UserView.dart';
import 'package:magik_antivirus/views/ForbiddenFilesView/FFoldersView.dart';

///Drawer de la aplicación
///En la barra superior del menú principal, aparece un icono con la imagen del perfil del usuario. Si se pulsa ahí, aparecerá el Drawer con distintos widgets:
/// -	El primero es la cabecera del Drawer, que muestra la foto de perfil del usuario, su nombre y su correo. Si el usuario pulsa en el widget, accederá al menú de usuario
/// -	El segundo apartado es un tile con la imagen y el texto de carpetas prohibidas. Si se pulsa, el programa navegará hacia la vista de carpetas prohibidas
/// -	El tercero es un tile con una imagen y un texto de “Traducir”, al final del tile aparecerá un DropDown que mostrará distintos idiomas a traducir. Cuando el usuario elija un idioma, todos los textos del programa cambiarán al idioma elegido
/// -	El cuarto es un tile para cambiar el modo de claro a oscuro y viceversa. Con el switch que hay al final del tile, el usuario puede alternar entre los modos claro y oscuro
/// -	El quinto es un tile que, si el usuario lo pulsa, accederá a una ventana con toda la información de la versión actual del programa

class AppDrawer extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    bool modoClaro = (context.watch<MainAppProvider>().theme==AppEssentials.lightMode);
    return Drawer(
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>UserView()));
              },
              child: DrawerHeader(
                margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
              backgroundImage: (context.watch<MainAppProvider>().thisUser!=null && context.watch<MainAppProvider>().thisUser!.userIMGData!=null)?NetworkImage(context.watch<MainAppProvider>().thisUser!.userIMGData!):null,),
                    Expanded(child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text((context.watch<MainAppProvider>().thisUser!=null)?context.watch<MainAppProvider>().thisUser!.uname:"No user"),
                        Text((context.watch<MainAppProvider>().thisUser!=null)?context.watch<MainAppProvider>().thisUser!.email:"No user")
                      ],
                    ),),
                    
                    Text(">")
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>ForbFoldersView()));
              },
              child: ListTile(
                leading: Icon(Icons.folder, color: AppEssentials.colorsMap[(modoClaro)?"appMainBlue":"appMainLightBlue"]),
                title: Text(AppLocalizations.of(context)!.drawerFFolders , style: TextStyle(color: (AppEssentials.colorsMap[(modoClaro)?"appMainBlue":"appMainLightBlue"]),),),
              ),
            ),
            ListTile(
              leading: Icon(Icons.translate, color: AppEssentials.colorsMap[(modoClaro)?"appMainBlue":"appMainLightBlue"]),
              title: Text(AppLocalizations.of(context)!.drawerTranslate, style: TextStyle(color: (AppEssentials.colorsMap[(modoClaro)?"appMainBlue":"appMainLightBlue"]),),),
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
            ListTile(
              leading: Icon(Icons.dark_mode, color: AppEssentials.colorsMap[(modoClaro)?"appMainBlue":"appMainLightBlue"]),
              title: Text(AppLocalizations.of(context)!.drawerDarkMode, style: TextStyle(color: (AppEssentials.colorsMap[(modoClaro)?"appMainBlue":"appMainLightBlue"]),),),
              trailing: Switch(
                  value: context.watch<MainAppProvider>().theme ==
                      AppEssentials.darkMode,
                  onChanged: (value) {
                    context.read<MainAppProvider>().changeTheme(value);
                  }),
            ),
            GestureDetector(
              onTap: () {},
              child: ListTile(
                leading: Icon(Icons.info, color: AppEssentials.colorsMap[(modoClaro)?"appMainBlue":"appMainLightBlue"]),
                title: Text("${AppLocalizations.of(context)!.appVer} (WIP)", style: TextStyle(color: (AppEssentials.colorsMap[(modoClaro)?"appMainBlue":"appMainLightBlue"]),),),
              ),
            ),
          ],
        ),
      );
  }

}