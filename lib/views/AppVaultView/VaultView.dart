import 'package:flutter/material.dart';
import 'package:magik_antivirus/DataAccess/FileDAO.dart';
import 'package:magik_antivirus/model/File.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AppVault extends StatefulWidget {
  const AppVault({super.key});

  @override
  State<AppVault> createState() => _AppVaultState();
}

class _AppVaultState extends State<AppVault> {
  List<SysFile> list = [];

  FileDAO dao = FileDAO();

  @override
  void initState() {
    super.initState();
    loadList();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
      children: [
        Text(AppLocalizations.of(context)!.vaultDesc),
        (list.length==0)?
        Text("No data yet"):
        Expanded(
          child: ListView.builder(
            itemCount: list.length,
            itemBuilder: (context, index){
              SysFile file = list[index];
              return GestureDetector(
                onTap: (){},
                child: Card(
                  margin: EdgeInsets.all(5),
                  child: ListTile(
                    leading: Icon(Icons.file_open),
                    title: Text(file.name),
                    subtitle: Text(file.route),
                  ),
                ),
              );
            })
        )
      ],
    ),
    );
  }
  
  void loadList() async{
    List<SysFile> listres = await dao.list();
    setState(() {
      list = listres;
    });
  }
}