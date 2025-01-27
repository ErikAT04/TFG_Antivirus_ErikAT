import 'package:flutter/material.dart';
import 'package:magik_antivirus/model/File.dart';
import 'package:magik_antivirus/widgets/Dialogs.dart';
import 'package:magik_antivirus/DataAccess/FileDAO.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

///Vista del baúl de archivos en cuarentena
class AppVault extends StatefulWidget {
  const AppVault({super.key});

  @override
  State<AppVault> createState() => AppVaultState();
}

///Estado de la vista del baúl de archivos
class AppVaultState extends State<AppVault> {
  ///Lista de los archivos del sistema
  List<SysFile> list = [];

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
    return Center(
      child: Column(
        children: [
          ExcludeSemantics(
              child: Text(AppLocalizations.of(context)!.vaultDesc)),
          (list.length == 0)
              ? Text(AppLocalizations.of(context)!.noDataYet)
              : Expanded(
                  child: Semantics(
                      label: AppLocalizations.of(context)!.fileList,
                      child: ListView.builder(
                          itemCount: list.length,
                          itemBuilder: (context, index) {
                            SysFile file = list[index];
                            return GestureDetector(
                              onTap: () async {
                                await showDialog(
                                    context: context,
                                    builder: (context) =>
                                        FileContext(file: file));
                                setState(() {
                                  list = [];
                                });
                                loadList();
                              },
                              child: Card(
                                margin: EdgeInsets.all(5),
                                child: ListTile(
                                  leading: Icon(Icons.file_open),
                                  title: Text(file.name),
                                  subtitle: Text(file.route),
                                ),
                              ),
                            );
                          })),
                )
        ],
      ),
    );
  }

  ///Función de carga de la lista de archivos
  void loadList() async {
    List<SysFile> listres = await dao.list();
    setState(() {
      list = listres;
    });
  }
}
