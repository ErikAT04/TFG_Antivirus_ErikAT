import 'dart:io';
import 'package:path/path.dart';
import 'package:logger/logger.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:magik_antivirus/model/User.dart';
import 'package:path_provider/path_provider.dart';
import 'package:magik_antivirus/model/Device.dart';
import 'package:magik_antivirus/utils/DBUtils.dart';
import 'package:magik_antivirus/views/MainView.dart';
import 'package:magik_antivirus/model/Signature.dart';
import 'package:magik_antivirus/views/LogInView.dart';
import 'package:magik_antivirus/model/ForbFolder.dart';
import 'package:magik_antivirus/DataAccess/UserDAO.dart';
import 'package:magik_antivirus/DataAccess/PrefsDAO.dart';
import 'package:magik_antivirus/utils/AppEssentials.dart';
import 'package:magik_antivirus/DataAccess/DeviceDAO.dart';
import 'package:magik_antivirus/DataAccess/MalwareDAO.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:magik_antivirus/DataAccess/ForbFolderDAO.dart';
import 'package:flutter_localizations/flutter_localizations.dart';



///Función principal - Inicio de la aplicación.
///
///Primero, comienza con la inicialización del binding de los widgets para evitar problemas.
///
///Después, carga las bases de datos, se accede a las propiedades y registra el dispositivo en la BD.
///
/// - Si salta un error porque no encuentra la tabla de las propiedades, inicia todas las tablas y reintenta esa acción.
/// 
///Una vez se han inicializado correctamente todas las acciones previas, se inicia la aplicación.
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await MySQLUtils.loadSQLDB();
  await SQLiteUtils.cargardb();
  Directory dir = Directory(join((Platform.isAndroid)?(await getApplicationDocumentsDirectory()).path:(await getLibraryDirectory()).path, "MagikAV", "MyFiles"));
  if(!dir.existsSync()){
    dir.createSync(recursive: true);
  }
  AppEssentials.quarantineDirectory = dir;
  try{
  await AppEssentials.getProperties();
  }catch(e){
    await SQLiteUtils.startDB();
    await AppEssentials.getProperties();
  }
  AppEssentials.registerThisDevice();
  runApp(ChangeNotifierProvider(
    create: (context) => MainAppProvider(),
    child: MainApp(),
  ));
}

///Clase de inicio de la app: Se inicia MaterialApp con la pagina principal en LogIn o Main dependiendo de si el usuario está iniciado
class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate
      ],
      supportedLocales: AppEssentials.listLocales,
      locale: context.watch<MainAppProvider>().language,
      theme: context.watch<MainAppProvider>().theme,
      home: (context.watch<MainAppProvider>().thisUser==null)?LogInView():Mainview(), //Si no se carga un usuario por defecto, se va al inicio de sesión.
    );
  }
}

///Provider de la aplicación, que guarda datos que van mutando a lo largo de la aplicación y se comparten entre varias vistas.
class MainAppProvider extends ChangeNotifier {
  ///Idioma de la aplicación, empezando en el idioma que haya guardado en las preferencias de la app
  Locale language = Locale(AppEssentials.chosenLocale);

  ///Tema de la aplicación, empezando con el tema guardado en las preferencias
  ThemeData theme = (AppEssentials.preferences.themeMode=="darkMode")?AppEssentials.darkMode:AppEssentials.lightMode;
  
  ///Usuario de la aplicación, empezando por el usuario guardado en las preferencias
  User? thisUser = AppEssentials.user;

  ///Lista de directorios prohibidos
  List<ForbFolder> fFoldersList = [];

  ///Lista de dispositivos
  List<Device> devList = [];

  ///Estado del "hilo"
  bool isIsolateActive = false;
  ///Mensaje de estado que ve el usuario
  String estado = "Espere unos segundos...";

  ///Función de análisis de archivosç
  ///
  ///En esta versión de prueba, comienza con pedir el permiso de acceder a los ficheros al usuario si fuera necesario
  ///
  ///Si este acepta, recorrerá los archivos del dispositivo.
  ///
  ///Al estar en el notifier y ser una función asíncrona, es posible hacer otras tareas en el equipo mientras esta se lleva a cabo
  void analizarArchivos()async{
    isIsolateActive = true;
    notifyListeners();
    // Verificar el estado del permiso
    if (await Permission.manageExternalStorage.status.isGranted) {
      List<Signature> sigs = await SignatureDAO().getSigs();
      //Prueba de que cargan los ficheros
      for(var sig in sigs){
        print(sig);
      }
      // Permiso ya concedido
      Logger().d("Permiso concedido");
      await AppEssentials.pruebaAnalisisArchivos();
      AppEssentials.dev!.last_scan = DateTime.now();
      await DeviceDAO().update(AppEssentials.dev!);
    } else {
      // Solicitar permiso
      print("Solicitando permiso de almacenamiento...");
      if (await Permission.manageExternalStorage.request().isGranted) {
        // Permiso concedido
        Logger().d("Permiso concedido");
        await AppEssentials.pruebaAnalisisArchivos();
        AppEssentials.dev!.last_scan = DateTime.now();
        await DeviceDAO().update(AppEssentials.dev!);
      } else {
        // Permiso denegado
        Logger().d("Permiso denegado");
      }
    }
    isIsolateActive = false;
    notifyListeners();
  }

  ///Función que sirve para cambiar el idioma de la aplicación
  ///
  ///Además de cambiar el idioma, guarda en las preferencias el idioma elegido
  void changeLang(String lang) {
    language = Locale(lang);
    notifyListeners();
    AppEssentials.changeLang(lang);
  }
  
  ///Función que sirve para cambiar el tema de la aplicación
  ///
  ///Además de cambiar el tema, guarda en las preferencias el tema actual
  void changeTheme(bool val){
    theme = val?AppEssentials.darkMode:AppEssentials.lightMode;
    AppEssentials.changeTheme(val);
    notifyListeners();
  }

  ///Función de cambio de usuario
  ///
  ///Además, guarda el email de usuario y una booleana que marca que se inicie sesión de forma automática 
  void changeUser(User user) {
    this.thisUser = user;
    AppEssentials.putUser(user);
    notifyListeners();
  }

  ///Función de borrado de directorios prohibidos
  ///
  ///Borra el archivo tanto de la lista actual como de la base de datos local
  void deleteThisFolder(ForbFolder folder) async {
    fFoldersList.remove(folder);
    await ForbFolderDAO().delete(folder);
    notifyListeners();
  }

  ///Función de cierre de sesión
  ///
  ///Además de cerrar sesión poniendo al usuario nulo, desmarca la booleana de auto registro y quita el usuario del dispositivo (Por si se va a usar más tarde)
  void logout() async{
    thisUser = null;
    AppEssentials.preferences.isUserRegistered = false;
    await PrefsDAO().update(AppEssentials.preferences);
    AppEssentials.dev!.user = null;
    await DeviceDAO().update(AppEssentials.dev!);
    notifyListeners();
  }

  ///Función de borrado de cuenta
  ///
  ///Se borra al usuario de la base de datos en red y luego se procede como en el cierre de sesión
  void erase() async{
    User u = thisUser!;
    //Todos los dispositivos asignados a este usuario tendrán un usuario nulo al borrar el usuario. 
    for(Device d in devList){
      d.user = null;
      await DeviceDAO().update(d);
    }
    logout();
    await UserDAO().delete(u);
  }

  ///Función de obtención de la lista de dispositivos del usuario
  void getDevicesList() async{
    devList = [];
    List<Device> auxList = await DeviceDAO().list();
    for(Device device in auxList){
      if(device.user == thisUser!.email){
        devList.add(device);
      }
    }
    notifyListeners();
  }

  ///Función de recarga de los directorios prohibidos
  void reloadFFolders() async{
    fFoldersList = await ForbFolderDAO().list();
    notifyListeners();
  }
}