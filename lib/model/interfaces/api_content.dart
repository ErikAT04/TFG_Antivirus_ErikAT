///Interfaz de contenido de las APIs
///
///Viendo que me daba problemas hacer operaciones REST con la librería convert, decidí hacer una interfaz para convertir toda la información de los objetos en mapas y viceversa.
abstract class APIContent{
  ///Función de paso de objeto a mapa
  Map<String, String?> toAPI(){
  return <String, String?>{};
  }
  ///Función de paso de mapa a objeto
  void toItem(Map<String, String> map){
  }
}