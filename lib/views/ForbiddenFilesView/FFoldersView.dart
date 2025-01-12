import 'package:fluttertoast/fluttertoast.dart';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:magik_antivirus/main.dart';
import 'package:file_picker/file_picker.dart';
import 'package:magik_antivirus/model/ForbFolder.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:magik_antivirus/DataAccess/ForbFolderDAO.dart';

///Vista de las carpetas prohibidas.
class ForbFoldersView extends StatelessWidget {
  const ForbFoldersView({super.key});

  ///Se carga una lista con todas las carpetas por las que, por el motivo que sea, no interesa que el programa pase.
  ///
  ///Las carpetas aparecen listadas según cuándo se añadieron (van por un id auto incrementado).
  ///
  ///El usuario puede borrar las carpetas de la lista dando al icono de borrar en el tile de la carpeta.
  @override
  Widget build(BuildContext context) {
    List<ForbFolder> ffolders = context.watch<MainAppProvider>().fFoldersList;
    return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.drawerFFolders),
        ),
        body: Center(
          child: Column(
            children: [
              ExcludeSemantics(child: Text(AppLocalizations.of(context)!.fFoldersInfo)),
              Semantics(
                label: AppLocalizations.of(context)!.fFoldersAddFolder,
                hint: AppLocalizations.of(context)!.ffolderBttContext,
                child: ElevatedButton(
                  onPressed: () {
                    addFolder(context);
                  },
                  child: Text(AppLocalizations.of(context)!.fFoldersAddFolder)),),
              ExcludeSemantics(child:Text(AppLocalizations.of(context)!.fFoldersFolder)),
              Expanded(
                  child: Semantics(
                    label: AppLocalizations.of(context)!.ffolderList,
                    hint: AppLocalizations.of(context)!.ffolderList,
                    child: ListView.builder(
                      itemCount: ffolders.length,
                      itemBuilder: (context, index) {
                        ForbFolder folder = ffolders[index];
                        return MergeSemantics( child: ListTile(
                          leading: Icon(Icons.folder),
                          title: Text(folder.name),
                          subtitle: Text(folder.route),
                          trailing: GestureDetector(
                              child: Icon(Icons.delete),
                              onTap: () {
                                context
                                    .read<MainAppProvider>()
                                    .deleteThisFolder(folder);
                              }),
                        ));
                      })))
            ],
          ),
        ));
  }

  ///Función de adición de carpetas
  ///
  ///Abre un menú contextual de selección de directorios.
  ///
  ///Si se elige un archivo, se añade a la bd
  void addFolder(BuildContext context) async {
    String? dirPath = await FilePicker.platform.getDirectoryPath();
    if (dirPath != null) {
      bool b = false;

      for(ForbFolder fb in context.read<MainAppProvider>().fFoldersList){
        if(fb.route == dirPath){
          b = true;
        }
      }
      if(b){
        Fluttertoast.showToast(msg: AppLocalizations.of(context)!.fFoldersAlreadyError);
      } else{
      await ForbFolderDAO()
          .insert(ForbFolder(name: basename(dirPath), route: dirPath));
      context.read<MainAppProvider>().reloadFFolders();
      }
    }
  }
}
