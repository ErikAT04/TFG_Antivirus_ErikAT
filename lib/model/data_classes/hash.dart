import 'package:magik_antivirus/model/interfaces/api_content.dart';

///Clase de Firma
///
///Sirve para guardar las distintas firmas de malware de una base de datos
class Hash implements APIContent {
  ///Tipo de malware (virus, trojan, worm...)
  String type;

  ///Firma: El código encriptado del malware
  String hash_code;

  //Constructor
  Hash({required this.type, required this.hash_code});

  @override
  Map<String, String> toAPI() {
    return {"type": type, "hash": hash_code};
  }

  @override
  void toItem(Map<String, String> map) {
    type = map["type"]!;
    hash_code = map["hash"]!;
  }
}
