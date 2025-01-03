import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:magik_antivirus/DataAccess/UserDAO.dart';
import 'package:magik_antivirus/main.dart';
import 'package:magik_antivirus/model/User.dart';
import 'package:magik_antivirus/views/LogInView.dart';
import 'package:magik_antivirus/widgets/Dialogs.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class UserView extends StatelessWidget {
  const UserView({super.key});

  @override
  Widget build(BuildContext context) {
    User u = context.watch<MainAppProvider>().thisUser!;
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text(u.uname)),
      ),
      body: Column(
        children: [
          Stack(
            children: [
              Container(
              ),
              GestureDetector(
                child: Positioned(child: CircleAvatar(
                  backgroundImage: (u.userIMGData!=null)?NetworkImage(u.userIMGData!):null,
                )),
                onTap:() async{
                  String? res = await showDialog(context: context, builder: (context){
                    TextEditingController linkController = TextEditingController();
                    return Dialog(
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        children: [
                          TextField(
                            controller: linkController,
                          ),
                          ElevatedButton(onPressed: (){
                            if(linkController.text.length>0 && linkController.text.length<256){
                              Navigator.pop(context, linkController.text);
                            }
                          }, child: Text(""))
                        ],
                      ),
                    );
                  });

                  if(res!=null){
                    u.userIMGData = res;
                    await UserDAO().update(u);
                    context.read<MainAppProvider>().changeUser(u);
                  }
                }
              )
            ],
          ),
          Text(u.uname),
          Text(u.email),
          Text("${AppLocalizations.of(context)!.userNumDevices}: ${context.watch<MainAppProvider>().devList.length}"),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(onPressed: (){}, child: Text(AppLocalizations.of(context)!.userCName)),
              ElevatedButton(onPressed: (){}, child: Text(AppLocalizations.of(context)!.userCPass)),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(onPressed: (){
                context.read<MainAppProvider>().logout();
                Navigator.pop(context);
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LogInView()));
              }, child: Text(AppLocalizations.of(context)!.userLOut)),
              ElevatedButton(onPressed: () async{
                bool? res = await showDialog<bool>(context: context, builder: (context) => EraseContextDialog());
                if(res!=null && res){
                  context.read<MainAppProvider>().erase();
                  Navigator.pop(context);
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LogInView()));
                }
              }, child: Text(AppLocalizations.of(context)!.userErase)),
            ],
          )
        ],
      ),
    );
  }
}