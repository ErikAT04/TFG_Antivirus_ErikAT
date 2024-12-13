import 'dart:io';
import 'dart:convert';
import 'package:path/path.dart' as p;
import 'package:magik_antivirus/model/User.dart';


/// App Essentials: El contenido del pc
class AppEssentials {
  static String chosenLang = "esEs";
  static Map<String, Map<String, String>> mapaLenguaje = {
    "esES":mapConvert(jsonDecode(File(p.join("lib", "Files", "Language", "esES.json")).readAsStringSync())),
    "enEN":mapConvert(jsonDecode(File(p.join("lib", "Files", "Language", "enEN.json")).readAsStringSync())),
    "deDE":mapConvert(jsonDecode(File(p.join("lib", "Files", "Language", "deDE.json")).readAsStringSync())),
    "frFR":mapConvert(jsonDecode(File(p.join("lib", "Files", "Language", "frFR.json")).readAsStringSync()))
  };
  static User? user;

  static File properties = File(p.join("lib", "Files", "properties.json"));

  static Map<String, String> propertyMap = mapConvert(jsonDecode(properties.readAsStringSync()));

  static void changeLang(String lang){
    propertyMap["chosenLang"] = lang;
    properties.writeAsStringSync(jsonEncode(propertyMap));
  }

  static String getLang(){
    return propertyMap["chosenLang"]!;
  }

  static Map<String, String> mapConvert(Map<String, dynamic> lm){
    Map<String, String> map = lm.map((key, value)=>MapEntry(key, value.toString()));
    return map;
  }
}