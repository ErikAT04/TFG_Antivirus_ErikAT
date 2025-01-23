///Clase de Usuario: Guarda la información de inicio de sesión
class User {
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

  ///Mapeo de objeto a JSON
  Map<String, dynamic> toJson() {
    return {
      "email": this.email,
      "username": this.username,
      "passwd": this.passwd,
      "image": this.image
    };
  }
}
