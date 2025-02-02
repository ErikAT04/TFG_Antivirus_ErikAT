import 'dart:convert' as convert;
import 'package:logger/logger.dart';
import 'package:magik_antivirus/utils/database_utils.dart';
import 'package:magik_antivirus/model/signature.dart';
///Clase de acceso a datos de las firmas
///
///La información de esta se hace por medio de un servicio API REST conectado a una base de datos de MySQL, ya que se guarda en un servidor en red que gestiona a cada usuario y sus dispositivos
class SignatureDAO {

  ///Función de listado de firmas
  ///
  ///Devuelve una lista de firmas de la base de datos
  Future<List<Signature>> getSigs() async {
    List<Signature> sigs = [];
    var uri = Uri.https(APIReaderUtils.apiRESTLink, "api/signatures/");
    var body = await APIReaderUtils.getData(uri);
    if (body != "noBody") {
      var json = convert.jsonDecode(body);
      Logger().i(json);
      for (var line in json) {
        sigs.add(Signature(type: line["type"]!, signature: line["signature"]!));
      }
    }
    return sigs;
  }
}
