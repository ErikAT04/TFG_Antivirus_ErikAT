import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:magik_antivirus/DataAccess/ForbFolderDAO.dart';
import 'package:magik_antivirus/main.dart';
import 'package:magik_antivirus/model/ForbFolder.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart';


class ForbFoldersView extends StatelessWidget {
  const ForbFoldersView({super.key});

  @override
  Widget build(BuildContext context) {
    List<ForbFolder> ffolders = context.watch<MainAppProvider>().fFoldersList;
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.drawerFFolders),
      ),
      body: Center(child:Column(
        children: [
          Text(AppLocalizations.of(context)!.fFoldersInfo),
          ElevatedButton(onPressed: () async{
            String? dirPath = await FilePicker.platform.getDirectoryPath();
            if(dirPath!=null){
              await ForbFolderDAO().insert(ForbFolder(name: basename(dirPath), route: dirPath));
              context.read<MainAppProvider>().reloadFFolders();
            }
          }, child: Text(AppLocalizations.of(context)!.fFoldersAddFolder)),
          Text(AppLocalizations.of(context)!.fFoldersFolder),
          Expanded(
            child: ListView.builder(
              itemCount: ffolders.length,
              itemBuilder: (context, index){
                ForbFolder folder = ffolders[index];
                return ListTile(
                  leading: Icon(Icons.folder),
                  title: Text(folder.name),
                  subtitle: Text(folder.route),
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