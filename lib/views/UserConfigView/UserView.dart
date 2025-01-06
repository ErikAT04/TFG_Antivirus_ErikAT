
import 'package:flutter/material.dart';
import 'package:magik_antivirus/DataAccess/UserDAO.dart';
import 'package:magik_antivirus/main.dart';
import 'package:magik_antivirus/model/User.dart';
import 'package:magik_antivirus/utils/AppEssentials.dart';
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
        title: Text(u.uname),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(10),
            color: AppEssentials.colorsMap["appMainLightBlue"],
            child:Row(
              spacing: 10,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              GestureDetector(
                child: CircleAvatar(
                    backgroundImage: (u.userIMGData!=null)?NetworkImage(u.userIMGData!):null,
                    radius: 60,
                  ), 
                onTap:() async{
                  String? res = await showDialog(context: context, builder: (context)=>ImageUploadContextDialog());

                  if(res!=null){
                    u.userIMGData = res;
                    await UserDAO().update(u);
                    context.read<MainAppProvider>().changeUser(u);
                  }
                }
              ),
              Expanded(child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(u.uname, style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                  Text(u.email),
                  Text("${AppLocalizations.of(context)!.userNumDevices} ${context.watch<MainAppProvider>().devList.length}"),
                ],
              ))
            ],
          ),
          ),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(onPressed: () async{
                String? newName = await showDialog<String>(context: context, builder: (context)=>ChangeUserNameContextDialog());
                if(newName!=null){
                  context.read<MainAppProvider>().thisUser!.uname = newName;
                  await UserDAO().update(context.read<MainAppProvider>().thisUser!);
                }
              }, child: Text(AppLocalizations.of(context)!.userCName)),
              ElevatedButton(onPressed: ()async{
                String? newPass = await showDialog<String>(context: context, builder: (context)=>ChangePasswordContextDialog());
                if(newPass!=null){
                  context.read<MainAppProvider>().thisUser!.pass = newPass;
                  await UserDAO().update(context.read<MainAppProvider>().thisUser!);
                }
              }, child: Text(AppLocalizations.of(context)!.userCPass)),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(onPressed: (){
                Navigator.pop(context);
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LogInView()));
                context.read<MainAppProvider>().logout();
              }, child: Text(AppLocalizations.of(context)!.userLOut)),
              ElevatedButton(onPressed: () async{
                bool? res = await showDialog<bool>(context: context, builder: (context) => EraseContextDialog());
                if(res!=null && res){
                  Navigator.pop(context);
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LogInView()));
                  context.read<MainAppProvider>().erase();
                }
              }, child: Text(AppLocalizations.of(context)!.userErase)),
            ],
          )
        ],
      ),
    );
  }
}

