import 'dart:convert' as convert;
import 'package:magik_antivirus/utils/DBUtils.dart';
import 'package:magik_antivirus/model/Signature.dart';

class SignatureDAO {
  Future<List<Signature>> getSigs() async {
    List<Signature> sigs = [];
    var uri = Uri.http(APIReaderUtils.apiRESTLink, "api/signatures/");
    var body = await APIReaderUtils.getData(uri);
    if (body != "noBody") {
      var json = convert.jsonDecode(body);
      for (var line in json) {
        print(line);
        sigs.add(Signature(type: line["type"]!, signature: line["signature"]!));
      }
    }
    return sigs;
  }
}
