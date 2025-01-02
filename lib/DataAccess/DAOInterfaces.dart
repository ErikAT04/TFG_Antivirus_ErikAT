
///Interfaz creada para el manejo de todas las clases DAO
///
///Aunque cada una de ellas tenga sus métodos con sus distintas formas de operar (Sobre todo dependiendo del origen), todas ellas acaban recibiendo por parámetro un valor y devolviendo otro.
///
///Para dejar más libertad, las clases genéricas T y V permiten dar un valor distinto a las clases, siendo T la clase objetivo y V otro valor a decidir por el usuario.
abstract class DAOInterface<T, V>{
  ///Función de creación en BD
  Future<bool> insert(T item) async{
    return true;
  }
  ///Función de actualización en BD
  Future<bool> update(T item) async{
    return true;
  }
  ///Función de obtención en BD
  Future<T?> get(V value) async{
    return null;
  }
  ///Función de listado en BD
  Future<List<T>> list() async{
    return List.empty();
  }
  ///Función de borrado en BD
  Future<bool> delete(T item) async{
    return true;
  }
}