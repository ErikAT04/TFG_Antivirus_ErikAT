import 'package:magik_antivirus/viewmodel/analysis_provider.dart';
import 'package:magik_antivirus/viewmodel/language_provider.dart';
import 'package:magik_antivirus/viewmodel/user_data_provider.dart';
import 'package:magik_antivirus/viewmodel/style_provider.dart';
import 'package:magik_antivirus/view/screens/app_loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:magik_antivirus/view/screens/main_view.dart';
import 'package:magik_antivirus/view/screens/login_view.dart';
import 'package:magik_antivirus/model/utils/app_essentials.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); //Asegura que los widgets se inicializan correctamente
  await AppEssentials
      .getPreferences(); // Carga las preferencias del usuario en la aplicación.
  UserDataProvider provider = UserDataProvider();
  provider
      .loadAssets(); //Comienza la carga de todos los datos de la aplicación.
  runApp(MultiProvider(
    //Inicia la interfaz gráfica.
    providers: [
      ChangeNotifierProvider(create: (context) => provider),
      ChangeNotifierProvider(create: (context) => StyleProvider()),
      ChangeNotifierProvider(
        create: (context) => AnalysisProvider(),
      ),
      ChangeNotifierProvider(create: (context) => LanguageNotifier())
    ],
    child: MainApp(),
  ));
}

///Clase de inicio de la app: Se inicia MaterialApp con la pagina principal en LogIn o Main dependiendo de si el usuario está iniciado
class MainApp extends StatelessWidget {
  const MainApp({super.key});

  ///Inicia el contexto y, con él:
  /// - Delegates: Definen los recursos que utilizan las localizaciones
  /// - Locales soportados: Definen los idiomas que se pueden usar
  /// - Locale: Idioma actual, controlado en un provider
  /// - Theme: Tema actual, controlado en un provider
  /// - Home: Inicio de la aplicación, variando entre Login y pantalla principal dependiendo de si hay una sesión iniciada previamente.
  @override
  Widget build(BuildContext context) {
    Provider.debugCheckInvalidValueType = null;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate
      ],
      supportedLocales: const [
        Locale('es'),
        Locale('en'),
        Locale('de'),
        Locale('fr')
      ],
      locale: context.watch<LanguageNotifier>().language,
      theme: context.watch<StyleProvider>().isLightModeActive
          ? context.watch<StyleProvider>().lightMode
          : context.watch<StyleProvider>().darkMode,
      home: !(context.watch<UserDataProvider>().assetsLoaded)
          ? AppLoadingView()
          : (context.watch<UserDataProvider>().thisUser == null)
              ? LogInView()
              : Mainview(), //Si no se carga un usuario por defecto, se va al inicio de sesión.
    );
  }
}
