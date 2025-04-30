import 'package:magik_antivirus/model/api_content.dart';

///Clase de Usuario: Guarda la información de inicio de sesión
class User implements APIContent{
  ///Nombre de usuario
  String username;

  ///Contraseña
  String passwd;

  ///Correo electrónico
  String email;

  ///String que guarda la dirección a la foto de perfil
  String? image;

  ///Constructor
  User(
      {required this.username,
      required this.passwd,
      required this.email,
      this.image});
  
  @override
  Map<String, String?> toAPI() {
    return {
      "email": email,
      "username": username,
      "passwd": passwd,
      "image": image
    };
  }
  
  @override
  void toItem(Map<String, String> map) {
    email = map["email"]!;
    passwd = map["passwd"]!;
    image = map["image"];
    username = map["username"]!;
  }
}
