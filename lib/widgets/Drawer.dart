import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import 'package:magik_antivirus/main.dart';
import 'package:magik_antivirus/utils/AppEssentials.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class AppDrawer extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    bool modoClaro = (context.watch<MainAppProvider>().theme==AppEssentials.lightMode);
    return Drawer(
        child: Column(
          children: [
            GestureDetector(
              onTap: () {},
              child: DrawerHeader(
                margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(
                              "https://i.redd.it/happy-birthday-kinich-v0-elooz82x370e1.jpg?width=3000&format=pjpg&auto=webp&s=2f4218a8a48cc9adb4d0ce52f1ce7894f584c7b5"),
                    ),
                    Expanded(child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Usuario de prueba"),
                        Text("usu@usu.com")
                      ],
                    ),),
                    
                    Text(">")
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () {},
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
                title: Text(AppLocalizations.of(context)!.appVer, style: TextStyle(color: (AppEssentials.colorsMap[(modoClaro)?"appMainBlue":"appMainLightBlue"]),),),
              ),
            ),
          ],
        ),
      );
  }

}