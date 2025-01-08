///Clase de Usuario: Guarda la información de inicio de sesión
class User {
  ///Nombre de usuario
  String uname;
  ///Contraseña
  String pass;
  ///Correo electrónico
  String email;
  ///String que guarda la dirección a la foto de perfil
  String? userIMGData;

  User({required this.uname, required this.pass, required this.email, this.userIMGData});
}