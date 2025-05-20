import 'dart:convert' as convert;
import 'package:magik_antivirus/model/utils/database_utils.dart';
import 'package:magik_antivirus/model/data_classes/hash.dart';

///Clase de acceso a datos de las firmas
///
///La información de esta se hace por medio de un servicio API REST conectado a una base de datos de MySQL, ya que se guarda en un servidor en red que gestiona a cada usuario y sus dispositivos
class HashDAO {
  ///Función de listado de firmas
  ///
  ///Devuelve una lista de firmas de la base de datos
  Future<List<Hash>> getHashes() async {
    List<Hash> hashes = [];
    var uri = Uri.http(APIReaderUtils.apiRESTLink, "api/hashes/");
    var body = await APIReaderUtils.getData(uri);
    if (body != "noBody") {
      var json = convert.jsonDecode(body);
      for (var line in json) {
        hashes.add(Hash(type: line["type"]!, hash_code: line["hash"]!));
      }
    }
    return hashes;
  }
}
