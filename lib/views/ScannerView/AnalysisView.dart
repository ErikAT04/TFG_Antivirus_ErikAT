import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:magik_antivirus/utils/AppEssentials.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:logger/logger.dart';

class AnalysisView extends StatefulWidget {
  const AnalysisView({super.key});

  @override
  State<AnalysisView> createState() => _AnalysisViewState();
}

class _AnalysisViewState extends State<AnalysisView> {
  bool isActive = false;
  String state = "Prueba: Espere 3 segundos";
  @override
  Widget build(BuildContext context) {
    if(!isActive){
      return Center(
      child: Container(
        width: 150,
        height: 150,
        child: ElevatedButton(
          onPressed: () async {
            setState(() {
              isActive = true;
            });

            // Verificar el estado del permiso
            if (await Permission.manageExternalStorage.status.isGranted) {
              // Permiso ya concedido
              Logger().d("Permiso concedido");
              await AppEssentials.pruebaAnalisisArchivos();
            } else {
              // Solicitar permiso
              print("Solicitando permiso de almacenamiento...");
              if (await Permission.manageExternalStorage.request().isGranted) {
                // Permiso concedido
                Logger().d("Permiso concedido");
                await AppEssentials.pruebaAnalisisArchivos();
              } else {
                // Permiso denegado
                Logger().d("Permiso denegado");
              }
            }

            setState(() {
              isActive = false;
            });
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.shield, size: 30),
              Text('Analizar'), // Cambia esto según tu localización
            ],
          ),
        ),
      ),
    );
    } else {
      return Center(
        child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          Text(state)
        ],
      ),
      );
    }
  }
}