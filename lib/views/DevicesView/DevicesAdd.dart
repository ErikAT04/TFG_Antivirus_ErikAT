import 'dart:io';

import 'package:flutter/material.dart';
import 'package:magik_antivirus/model/Device.dart';
import 'package:magik_antivirus/utils/AppEssentials.dart';

class DevicesAdd extends StatefulWidget {
  const DevicesAdd({super.key});

  @override
  State<DevicesAdd> createState() => _DevicesAddState();
}

class _DevicesAddState extends State<DevicesAdd> {
  TextEditingController devNameController = TextEditingController();
  String dev = (Platform.operatingSystem).capitalize();
  @override
  Widget build(BuildContext context) {
    
    String? errorText;
    return Scaffold(
      appBar: AppBar(
        title: Text("Añadir Dispositivos (Just ES Lang)"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
              "Esta opción sólo existirá en el modo de prueba, y será automatizada en la versión definitiva"),
          TextField(
              controller: devNameController,
              decoration: InputDecoration(
                  labelText: "Escribe el nombre", errorText: errorText)),
          DropdownButton(
              value: dev,
              items: [
                DropdownMenuItem(
                  child: Text("Android"),
                  value: "Android",
                ),
                DropdownMenuItem(
                  child: Text("iOS"),
                  value: "Ios",
                ),
                DropdownMenuItem(child: Text("MacOS"), value: "Macos"),
                DropdownMenuItem(child: Text("Linux"), value: "Linux"),
                DropdownMenuItem(child: Text("Windows"), value: "Windows"),
              ],
              onChanged: (value) {
                setState(() {
                  dev = value!;
                });
              }),
          ElevatedButton(
              onPressed: () {
                if (devNameController.text.isEmpty) {
                  setState(() {
                    errorText = "El campo no puede estar vacío";
                  });
                } else {
                  Navigator.pop(
                      context,
                      Device(
                          name: devNameController.text,
                          type: dev,
                          join_in: DateTime.now(),
                          last_scan: DateTime.now()));
                }
              },
              child: Icon(Icons.add))
        ],
      ),
    );
  }
}
