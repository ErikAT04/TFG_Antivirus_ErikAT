import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:magik_antivirus/data_access/file_dao.dart';
import 'package:magik_antivirus/data_access/forbidden_folders_dao.dart';
import 'package:magik_antivirus/data_access/hash_dao.dart';
import 'package:magik_antivirus/model/file.dart';
import 'package:magik_antivirus/model/hash.dart';
import 'package:magik_antivirus/utils/app_essentials.dart';
import 'package:magik_antivirus/viewmodels/analysis_provider.dart';
import 'package:path/path.dart';
import 'package:cancelable_compute/cancelable_compute.dart' as cancelable;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:crypto/crypto.dart' as crypto;

class ScanIsolate {
  static cancelable.ComputeOperation? compute;
  static ReceivePort? receivePort;

  ///Función de comienzo del análisis
  ///
  ///Prepara el Isolate para el análisis de archivos
  ///
  ///Espera a recibir el mensaje del Isolate y, cuando lo recibe, llama a la función que pone los archivos en cuarentena.
  static void startAnalysis(String? customDir, BuildContext context) async {
    //Crea el puerto de recepción.
    receivePort = ReceivePort();

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
      receivePort!.sendPort,
    ];

    //Guarda la ruta de cada directorio al que no se puede acceder
    List<String> folders =
        (await ForbFolderDAO().list()).map((folder) => folder.route).toList();

    //Se guardan todos los elementos de la lista en los argumentos
    args.addAll(folders);

    //Se crea el Isolate con la función de escaneo y los argumentos
    compute = cancelable.compute(scanDirInThread, args);

    //Se crea el listener para el puerto de recepción
    receivePort!.listen((message) {
      Logger().d("Mensaje del Isolate: $message");
      setAllOnQuarantine(message).then((_) {
        //Cuando termina, se cierra el puerto de recepción y se cambia el estado del escaneo.
        context.read<AnalysisProvider>().isIsolateActive = false;
        context.read<AnalysisProvider>().setIsolateActive(false);
        receivePort!.close();
        receivePort = null;
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
    //Se guarda la lista de hashes en la variable, debido a que se tiene que volver a generar
    List<Hash> hashes = await HashDAO().getHashes();

    //Lista de archivos a meter en cuarentena UNA VEZ TERMINE EL ESCANEO
    List<Map<String, String>> files = [];

    //Se declara el directorio que se va a analizar
    Directory d = Directory(path);

    //Se guarda una lista unicamente con las hash_code de cada Hash
    List<String> hashCodes = hashes.map((hash) => hash.hash_code).toList();
    try {
      //Se escanea el directorio
      await scanDir(d, hashCodes, folders, files);
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
  ///Recibe por parámetros el directorio a escanear, la lista de hashes, la lista de rutas a directorios prohibidos y la lista de archivos a poner en cuarentena
  static Future<void> scanDir(Directory dir, List<String> hashList,
      List<String> folders, List<Map<String, String>> files) async {
    //Se comprueba si el directorio está en la lista de directorios prohibidos
    if (!folders.contains(dir.path)) {
      try {
        //Por cada archivo o directorio que haya en el directorio padre:
        await for (var f in dir.list(recursive: false)) {
          Logger().d("Escaneando: ${f.path}");
          //Si es un archivo, se escanea.
          if (f is File) {
            await scanFile(f, hashList, files);
          } else {
            //Si es un directorio, se reitera la función desde el nuevo directorio.
            await scanDir(f as Directory, hashList, folders, files);
          }
        }
      } catch (e) {}
    }
  }

  ///Función de escaneo de archivos
  ///
  ///Recibe un archivo, la lista de hashes y la lista de archivos a poner en cuarentena
  ///
  ///Se escanea el archivo, recogiendo los bytes y generando su hash.
  ///Si este hash coincide con alguna de las huellas digitales, será directamente considerado malware y se añadirá a la lista de cuarentena.
  static Future<void> scanFile(
      File f, List<String> hashList, List<Map<String, String>> files) async {
    try {
      Logger().d("Escaneando: ${f.path}");
      //Se leen los bytes del archivo.
      var bytes = await f.readAsBytes();
      //Se codifican los bytes en md5
      String s = crypto.md5.convert(bytes).toString();
      Logger().d("Hash: $s");
      //Si el hash aparece en la lista de la base de datos, se añade a la lista de archivos a poner en cuarentena.
      if (hashList.contains(s)) {
        Logger().d("Archivo ${f.path} es un virus");
        files.add({
          "path": f.path,
          "hash": s,
        });
      }
    } catch (e) {}
  }

  ///Función de puesta en cuarentena de archivos
  ///
  ///Recibe el path del archivo y el tipo de hash que tiene.
  ///Con ello, se crea un nuevo archivo en la carpeta de cuarentena y se guarda el "enlace" entre el archivo original y el nuevo archivo en la base de datos.
  static Future<void> putInQuarantine(String fpath, String hash_code) async {
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

    //En el supuesto caso de que el archivo ya exista, se reitera el proceso de creación del nuevo archivo en cuarentena, esperando que el nuevo nombre no se repita
    while (file.existsSync()) {
      pathSHA = crypto.sha256
          .convert(utf8.encode("${basename(f.path)} ${DateTime.now()}"))
          .toString();
      file = File(join(AppEssentials.quarantineDirectory.path, pathSHA));
    }

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
        malwareType: hash_code,
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
      for (var hash in AppEssentials.hashes) {
        if (line["hash"] == hash.hash_code) {
          type = hash.type;
        }
      }
      await putInQuarantine(line["path"]!, type);
    }
  }

  ///Función de cancelación del escaneo
  ///
  ///Si el Isolate de escaneo no ha sido cancelado, se cancela y se cierra el puerto de recepción.
  static void cancelScan(BuildContext context) {
    //Comprueba si el hilo sigue en ejecución, y si es así, se cancela y se cierra el puerto de recepción.
    if (compute != null && !compute!.isCanceled) {
      compute?.cancel(-1);
      compute = null;
      receivePort!.close();
      receivePort = null;
      //Se cambia el estado.
      context.read<AnalysisProvider>().setIsolateActive(false);
    }
    //Si se ha terminado el proceso de ejecución (el hilo no está activo), pero sigue estando la opción de cancelar, lo más seguro es que termine el proceso de escaneo de un momento a otro.
  }
}
