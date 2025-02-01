import 'package:flutter/material.dart';
import 'package:magik_antivirus/utils/app_essentials.dart';

///Provider encargado de controlar los idiomas
class LanguageNotifier extends ChangeNotifier {
  ///Idioma de la aplicación, empezando en el idioma que haya guardado en las preferencias de la app
  Locale language = Locale(AppEssentials.chosenLocale);

  ///Función que sirve para cambiar el idioma de la aplicación
  ///
  ///Además de cambiar el idioma, guarda en las preferencias el idioma elegido
  void changeLang(String lang) {
    language = Locale(lang);
    notifyListeners();
    AppEssentials.changeLang(lang);
  }
}
