import 'package:magik_antivirus/viewmodels/analysis_provider.dart';
import 'package:magik_antivirus/viewmodels/language_provider.dart';
import 'package:magik_antivirus/viewmodels/user_data_provider.dart';
import 'package:magik_antivirus/viewmodels/style_provider.dart';
import 'package:magik_antivirus/views/app_loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:magik_antivirus/views/main_view.dart';
import 'package:magik_antivirus/views/login_view.dart';
import 'package:magik_antivirus/utils/app_essentials.dart';
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
  WidgetsFlutterBinding.ensureInitialized();
  await AppEssentials.getProperties();
  UserDataProvider provider = UserDataProvider();
  provider.loadAssets();
  runApp(MultiProvider(
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
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate
      ],
      supportedLocales: [
        Locale('es'),
        Locale('en'),
        Locale('de'),
        Locale('fr')
      ],
      locale: //Controlar el lenguaje formato Locale('codigo')
          context.watch<LanguageNotifier>().language,
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
