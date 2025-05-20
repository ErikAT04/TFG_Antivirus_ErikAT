import 'package:flutter/material.dart';
import 'package:magik_antivirus/model/data_classes/file.dart';
import 'package:magik_antivirus/viewmodel/user_data_provider.dart';
import 'package:magik_antivirus/views/widgets/dialogs.dart';
import 'package:magik_antivirus/model/data_access/file_dao.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

///Vista del baúl de archivos en cuarentena
class AppVault extends StatefulWidget {
  const AppVault({super.key});

  @override
  State<AppVault> createState() => AppVaultState();
}

///Estado de la vista del baúl de archivos
class AppVaultState extends State<AppVault> {
  ///Lista de los archivos del sistema
  List<QuarantinedFile> list = [];

  ///Objeto de Acceso a Datos de SysFile
  FileDAO dao = FileDAO();

  @override
  void initState() {
    super.initState();
    loadList();
  }

  ///El usuario verá una lista de ficheros con nombre y ruta. Estos ficheros son los que, tras analizar el equipo, no han pasado por los requisitos de seguridad del programa y, para proteger al usuario, los ha puesto en cuarentena.
  ///
  ///Si el usuario pulsa sobre uno de ellos, aparecerá un pop up con información del archivo, como la ruta en la que se encontraba, el malware detectado y otros. Si pulsa al botón de Restaurar archivo, este desaparecerá de la lista y el programa lo sacará de su cuarentena.
  @override
  Widget build(BuildContext context) {
    List<QuarantinedFile> selectedFiles =
        context.watch<UserDataProvider>().selectedFiles;
    return Expanded(
        child: Center(
      child: (list.isEmpty)
          ? Text(AppLocalizations.of(context)!.noDataYet)
          : Semantics(
              label: AppLocalizations.of(context)!.fileList,
              child: ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    QuarantinedFile file = list[index];
                    return GestureDetector(
                      onLongPress: () {
                        if (selectedFiles.isEmpty) {
                          context.read<UserDataProvider>().addIntoFiles(file);
                        }
                      },
                      onTap: () async {
                        if (selectedFiles.isEmpty) {
                          await showDialog(
                              context: context,
                              builder: (context) => FileContext(file: file));
                          setState(() {
                            list = [];
                          });
                          loadList();
                        }
                      },
                      child: Card(
                        margin: EdgeInsets.all(5),
                        child: ListTile(
                          leading: (selectedFiles.isEmpty)
                              ? Icon(Icons.file_open)
                              : Checkbox(
                                  value: (selectedFiles.contains(file)),
                                  onChanged: (val) {
                                    if (val!) {
                                      context
                                          .read<UserDataProvider>()
                                          .addIntoFiles(file);
                                    } else {
                                      context
                                          .read<UserDataProvider>()
                                          .removeFromFiles(file);
                                    }
                                  }),
                          title: Text(file.name),
                          subtitle: Text(file.route),
                        ),
                      ),
                    );
                  })),
    ));
  }

  ///Función de carga de la lista de archivos
  void loadList() async {
    List<QuarantinedFile> listres = await dao.list();
    setState(() {
      list = listres;
    });
  }
}
