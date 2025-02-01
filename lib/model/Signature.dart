import 'package:magik_antivirus/model/api_content.dart';

class Signature implements APIContent{
  String type;
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