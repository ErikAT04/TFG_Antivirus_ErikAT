import 'package:magik_antivirus/model/ApiContent.dart';

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

  User(
      {required this.username,
      required this.passwd,
      required this.email,
      this.image});
  
  @override
  Map<String, String?> toAPI() {
    return {
      "email": this.email,
      "username": this.username,
      "passwd": this.passwd,
      "image": this.image
    };
  }
  
  @override
  void toItem(Map<String, String> map) {
    this.email = map["email"]!;
    this.passwd = map["passwd"]!;
    this.image = map["image"];
    this.username = map["username"]!;
  }
}
