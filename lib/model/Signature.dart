import 'package:magik_antivirus/model/api_content.dart';

///Clase de Firma
///
///Sirve para guardar las distintas firmas de malware de una base de datos
class Signature implements APIContent{
  ///Tipo de malware (virus, trojan, worm...)
  String type;
  ///Firma: El código encriptado del malware
  String signature;

  Signature({required this.type, required this.signature});
  
  @override
  Map<String, String> toAPI() {
    return {
      "type" : this.type,
      "signature" : this.signature
    };
  }
  
  @override
  void toItem(Map<String, String> map) {
    this.type = map["type"]!;
    this.signature = map["signature"]!;
  }
}