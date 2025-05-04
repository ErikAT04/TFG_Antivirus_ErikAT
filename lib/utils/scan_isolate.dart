import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:magik_antivirus/data_access/file_dao.dart';
import 'package:magik_antivirus/data_access/forbidden_folders_dao.dart';
import 'package:magik_antivirus/data_access/signature_dao.dart';
import 'package:magik_antivirus/model/file.dart';
import 'package:magik_antivirus/model/signature.dart';
import 'package:magik_antivirus/utils/app_essentials.dart';
import 'package:magik_antivirus/viewmodels/analysis_provider.dart';
import 'package:path/path.dart';
import 'package:cancelable_compute/cancelable_compute.dart' as cancelable;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:crypto/crypto.dart' as crypto;

class ScanIsolate {
  static cancelable.ComputeOperation? compute;

  ///Función de comienzo del análisis
  ///
  ///Prepara el Isolate para el análisis de archivos
  ///
  ///Espera a recibir el mensaje del Isolate y, cuando lo recibe, llama a la función que pone los archivos en cuarentena.
  static void startAnalysis(String? customDir, BuildContext context) async {
    //Crea el puerto de recepción.
    final receivePort = ReceivePort();

    //Directorio Principal del dispositivo.
    //Dependiendo del dispositivo, el directorio raíz puede ser uno u otro:
    //- Android: /storage/emulated/0
    //- Linux y MacOS: /
    //- Windows: C:\ (En Dart se utiliza \ para el escapeo de caracteres, asi que para mostrar una sola barra se usa \\)
    String mainDirectory = customDir ??
        ((Platform.isAndroid)
            ? "/storage/emulated/0"
            : (Platform.isWindows)
                ? "C:\\"
                : "/");

    //Guarda en argumentos el puerto de envío y el enlace al directorio a analizar (Por defecto el directorio raíz)
    List<dynamic> args = [
      mainDirectory,
      receivePort.sendPort,
    ];

    //Guarda la ruta de cada directorio al que no se puede acceder
    List<String> folders =
        (await ForbFolderDAO().list()).map((folder) => folder.route).toList();

    //Se guardan todos los elementos de la lista en los argumentos
    args.addAll(folders);

    //Se crea el Isolate con la función de escaneo y los argumentos
    compute = cancelable.compute(scanDirInThread, args);

    //Se crea el listener para el puerto de recepción
    receivePort.listen((message) {
      Logger().d("Mensaje del Isolate: $message");
      setAllOnQuarantine(message).then((_) {
        //Cuando termina, se cierra el puerto de recepción y se cambia el estado del escaneo.
        context.read<AnalysisProvider>().isIsolateActive = false;
        context.read<AnalysisProvider>().setIsolateActive(false);
        receivePort.close();
      });
    });
  }

  ///Función que se ejecuta en los Isolates para iniciar el escaneo de directorios
  ///
  ///Recibe el path del directorio, y el SendPort para enviar mensajes entre hilos.
  ///
  ///Aquí hay que tener en cuenta que, cuando se genera un Isolate, todo lo que no se pase como argumento se declara en 0,
  ///por lo que hay que pasar los argumentos necesarios para que funcione correctamente y lo que no se pase se tiene que volver a generar.
  static void scanDirInThread(List<dynamic> args) async {
    //Guarda en variables los argumentos
    String path = args[0];
    SendPort sendPort = args[1];
    //Los directorios son todos los argumentos que van de la posición 2 en adelante
    List<String> folders = args.sublist(2).cast<String>();
    //Se guarda la lista de firmas en la variable, debido a que se tiene que volver a generar
    List<Signature> sigs = await SignatureDAO().getSigs();

    //Lista de archivos a meter en cuarentena UNA VEZ TERMINE EL ESCANEO
    List<Map<String, String>> files = [];

    //Se declara el directorio que se va a analizar
    Directory d = Directory(path);

    //Se guarda una lista unicamente con las firmas de cada Signature
    List<String> signatures = sigs.map((sig) => sig.signature).toList();
    try {
      //Se escanea el directorio
      await scanDir(d, signatures, folders, files);
    } catch (e) {
      sendPort.send("Error: $e");
    }
    sendPort.send(files);
  }

  ///Función de escaneo de directorios:
  ///
  ///Mira si el File que está mirando es un directorio y si su acceso está o no prohibido
  ///
  ///Si es un archivo, imprime su path (esto es solo de prueba de momento)
  ///
  ///Si es un directorio y tiene acceso a él, llama otra vez a su función, esta vez desde este nuevo directorio
  ///
  ///Recibe por parámetros el directorio a escanear, la lista de firmas, la lista de rutas a directorios prohibidos y la lista de archivos a poner en cuarentena
  static Future<void> scanDir(Directory dir, List<String> signatures,
      List<String> folders, List<Map<String, String>> files) async {
    //Se comprueba si el directorio está en la lista de directorios prohibidos
    if (!folders.contains(dir.path)) {
      try {
        //Por cada archivo o directorio que haya en el directorio padre:
        await for (var f in dir.list(recursive: false)) {
          Logger().d("Escaneando: ${f.path}");
          //Si es un archivo, se escanea.
          if (f is File) {
            await scanFile(f, signatures, files);
          } else
          //Si es un directorio, se reitera la función desde el nuevo directorio.
          if (f is Directory) {
            await scanDir(f, signatures, folders, files);
          }
        }
      } catch (e) {}
    }
  }

  ///Función de escaneo de archivos
  ///
  ///Recibe un archivo, la lista de firmas y la lista de archivos a poner en cuarentena
  ///
  ///Se escanea el archivo, recogiendo los bytes y generando su hash.
  ///Si este hash coincide con alguna de las firmas, será directamente considerado malware y se añadirá a la lista de cuarentena.
  static Future<void> scanFile(
      File f, List<String> signatures, List<Map<String, String>> files) async {
    try {
      Logger().d("Escaneando: ${f.path}");
      //Se leen los bytes del archivo.
      var bytes = await f.readAsBytes();
      //Se codifican los bytes en md5
      String s = crypto.md5.convert(bytes).toString();
      Logger().d("Hash: $s");
      //Si el hash aparece en la lista de firmas, se añade a la lista de archivos a poner en cuarentena.
      if (signatures.contains(s)) {
        Logger().d("Archivo ${f.path} es un virus");
        files.add({
          "path": f.path,
          "sig": s,
        });
      }
    } catch (e) {}
  }

  ///Función de puesta en cuarentena de archivos
  ///
  ///Recibe el path del archivo y el tipo de firma que tiene.
  ///Con ello, se crea un nuevo archivo en la carpeta de cuarentena y se guarda el "enlace" entre el archivo original y el nuevo archivo en la base de datos.
  static Future<void> putInQuarantine(String fpath, String sig) async {
    //Se declara el archivo a poner en cuarentena
    File f = File(fpath);

    //Se declara el directorio de cuarentena
    Directory dir = Directory(join(
        (await getApplicationDocumentsDirectory()).path, "MagikAV", "MyFiles"));

    //Si no existe el directorio, se crea.
    if (!dir.existsSync()) {
      dir.createSync(recursive: true);
    }

    Logger().d("Encriptando el path del archivo");
    //Se encripta el nombre (basename de la ruta) del archivo. Se usará como nuevo nombre del archivo en cuarentena.
    String pathSHA = crypto.sha256
        .convert(utf8.encode("${basename(f.path)} ${DateTime.now()}"))
        .toString();

    Logger().d("Creando el archivo en cuarentena");
    //Se crea el archivo en cuarentena, con su ruta (directorio de archivos en cuarentena) y nombre
    File file = File(join(AppEssentials.quarantineDirectory.path, pathSHA));

    //Se leen los bytes del archivo original, se codifican en base64 y se escriben en el nuevo archivo.
    var fileInside = await f.readAsBytes();
    file = await file.writeAsString(base64Encode(fileInside));
    await file.create();

    //Se crea el objeto SysFile que va a ser guardado en la BD
    QuarantinedFile sysFile = QuarantinedFile(
        name: basename(f.path),
        route: f.path,
        newName: pathSHA,
        newRoute: file.path,
        malwareType: sig,
        quarantineDate: DateTime.now());

    Logger().d("Guardando el archivo en la BD");
    await FileDAO().insert(sysFile);

    Logger().d("Archivo ${f.path} puesto en cuarentena");
    //Se borra el archivo original
    await f.delete();

    Logger().w("Archivo ${f.path} puesto en cuarentena");
  }

  ///Función de puesta en cuarentena de todos los archivos
  ///
  ///Recibe la lista de archivos a poner en cuarentena sacada del Isolate y llama a la función de poner en cuarentena en cada uno de ellos.
  ///Está hecho con el fin de recoger todas las funciones futuras en una sola y permitir que, una vez termine este último paso, se cierre el puerto de recepción y se cambie el estado del escaneo.
  static Future<void> setAllOnQuarantine(
      List<Map<String, String>> message) async {
    for (var line in message) {
      String type = "";
      for (var sig in AppEssentials.sigs) {
        if (line["sig"] == sig.signature) {
          type = sig.type;
        }
      }
      await putInQuarantine(line["path"]!, type);
    }
  }

  static void cancelScan(BuildContext context) {
    compute?.cancel(-1);
    compute = null;
    context.read<AnalysisProvider>().setIsolateActive(false);
  }
}
