import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:magik_antivirus/main.dart';
import 'package:magik_antivirus/model/ForbFolder.dart';
import 'package:provider/provider.dart';


class ForbFoldersView extends StatelessWidget {
  const ForbFoldersView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.drawerFFolders),
      ),
      body: Center(child:Column(
        children: [
          Text(AppLocalizations.of(context)!.fFoldersInfo),
          ElevatedButton(onPressed: (){}, child: Text(AppLocalizations.of(context)!.fFoldersAddFolder)),
          Text(AppLocalizations.of(context)!.fFoldersFolder),
          Expanded(
            child: ListView.builder(
              itemCount: context.watch<MainAppProvider>().fFoldersList.length,
              itemBuilder: (context, index){
                ForbFolder folder = context.watch<MainAppProvider>().fFoldersList[index];
                return ListTile(
                  leading: Icon(Icons.folder),
                  title: Text(folder.name),
                  subtitle: Text(folder.name),
                  trailing: GestureDetector(
                    child: Icon(Icons.delete),
                    onTap: (){
                      context.read<MainAppProvider>().deleteThisFolder(folder);
                    }
                  ),
                );
              }))
        ], 
      ),
      )
    );
  }
}