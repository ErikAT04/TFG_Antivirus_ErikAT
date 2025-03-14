# Magik Antivirus - Proyecto de Desarrollo de Aplicaciones Multiplataforma 
Trabajo de fin de grado de Erik Amo, basado en el Análisis de Malware por medio de la **detección basada en firmas**.

[Enlace a la documentación de la aplicación](https://erikat04.github.io/magik_antivirus_documentation/)

## Objetivos del proyecto
- Aprender a manipular archivos de los distintos sistemas operativos, creándolos, editándolos y borrándolos
- Ser capaz de desplegar una aplicación que, con una única versión de código, pueda operar correctamente en Android, iOS, MacOS, Windows y Linux.
- Poder conectar una aplicación con una base de datos por medio de un servicio API, haciendo a través de ésta todas las operaciones CRUD necesarias.
- Gestionar los datos de usuario, así como sus dispositivos conectados y sus preferencias en la aplicación de forma local.
- Optimizar los recursos de un proceso con tanto peso como es el análisis de ficheros de un sistema operativo.

## Teoría de la Detección basada en Firmas
La detección basada en firmas es un método de identificación de malware *conocido* más utilizado. Reitero el *conocido*, ya que este método no sirve para amenazas desconocidas, sino para otras ya analizadas previamente por otros sistemas.

Una firma es un patrón que identifica un código malicioso. Normalmente esa firma es el código interno de los ficheros infectados encriptado (Como es el caso de las firmas de esta aplicación). Cuando se registra una nueva firma un malware, esta es guardada en una base de datos de *firmas conocidas*, donde los servicios de protección recogerán esa firma para analizar otros archivos en busca de coincidencias.

La detección basada en firmas tiene como ventaja la rápida identificación de malware conocido, pero tiene la desventaja de que, ante un malware desconocido por la base de datos, no va a poder detectar el software malicioso.
## Teoría de APIs
Los servicios Web son aplicaciones que permiten la comunicación con distintos dispositivos electrónicos en red.  Esto se hace por el protocolo HTTP: Un protocolo de transferencia de archivos de hipertexto por la red. Se basa en que el cliente hace una **petición** (un mensaje para hacer alguna instrucción en red) al servidor, y este devuelve una respuesta en forma de código.
- El rango de 200 a 299 sirve para marcar que la petición ha sido aceptada por el servidor
- El rango de 300 a 399 marca un error en la autorización del servicio
- El rango de 400 a 499 sirve para marcar un error en la petición
- Más allá de 500, la respuesta marca un error interno del servidor

Las APIs son un contrato que permite a los desarrolladores interactuar con una aplicación. Una RESTful API es una API que se adapta al uso que le quiera dar el desarrollador. Esta se forma de EndPoints, puntos de interacción cliente-servidor, donde el cliente realiza una petición de obtención o manipulación de datos y el servidor le devuelve información en formato JSON
## Herramientas y Entornos
Para el desarrollo de este trabajo, he utilizado lo siguiente:
- **Lenguaje de Programación de la Aplicación - DART:** Un lenguaje de programación tipado y open source que permite la programación JIT y permite cierta portabilidad con todos los dispositivos.
  Dentro de DART, se encuentra su framework más conocido para el desarrollo de interfaces, ***Flutter***. Se caracteriza por ser un framework open source y con la posibilidad de instalar dependencias fácilmente para optimizar la creación de código, además de utilizar por defecto los Widgets de Material UI para generar sus interfaces gráficas.
  Las dependencias utilizadas para este proyecto son las siguientes:
	- **Country-Flags:** Dependencia utilizada de forma estética en el menú de hamburguesa (Drawer) para, a la hora de cambiar el idioma, mostrar las banderas de éstos
	- **SQFlite:** Para acceder a la base de datos local, SQFlite (Dispositivos móviles) y SQFlite_commons_ffi (Dispositivos de sobremesa) permite generar bases de datos en un archivo local y manipular sus datos de forma sencilla.
	- **Flutter_SVG:** Permite utilizar archivos de vectores (SVG) como iconos
	- **Provider:** Añade la funcionalidad MVVM a Flutter, pudiendo crear ViewModels que facilitan la actualización de estado de las vistas
	- **INTL - l10n:** Facilita la ***internacionalización*** de la aplicación.
	- **Path_Provider:** Dependencia que permite acceder a distintos directorios de diferentes sistemas operativos utilizando una misma línea de código
	- **Logger:** Durante el desarrollo de la aplicación, el usuario puede hacer comentarios de líneas de código para que aparezcan en la línea de comandos cuando se recorra su respectivo bloque 
	- **Crypto:** Quizá una de las dependencias más importantes para esta aplicación, permite encriptar un archivo en todo tipo de métodos de encripción. Se utiliza para la encripción de contraseñas de usuario en sha256 y la encripción del código de los ficheros en base64.
	- **Flutter_Markdown:** Permite utilizar el widget Markdown para leer un bloque de texto en dicho lenguaje de marcas y aplicar su texto al contenedor. Se utiliza en las ventanas de las versiones de la aplicación.
	- **File_Picker:** Permite al usuario elegir archivos de su sistema operativo, independientemente de cuál sea éste.
	- **Device_Info_Plus:** Saca información del dispositivo que está ejecutando la aplicación actualmente, información a la que Flutter de forma normal le cuesta acceder (dirección MAC, el identificador del dispositivo...)
	- **Background_Service:** Permite ejecutar acciones de la aplicación mientras ésta está en segundo plano.
	- **Shared_Preferences:** Guarda datos de la aplicación cuando esta se cierra, pudiendo acceder a ellos de vuelta cuando se vuelva a abrir. 
- **Lenguaje de Programación de la API - Python:** Un lenguaje tan anárquico como rápido y sencillo de programar, con una curva de aprendizaje muy tranquila y con gran capacidad de realizar tareas de todo tipo gracias a sus amplias librerías.
  Dependencias utilizadas:
	- **FastAPI:** Permite al usuario generar una API, configurando sus distintos endpoints por medio de funciones. 
	- **MySQL Connector:** Conector a la base de datos de MySQL
	- **SQLAlchemy:** ORM de las bases de datos SQL. Por medio de objetos en Python se puede editar información en la base de datos.
	- **PyJWT:** Seguridad de APIs con Python. Genera JWTs (JSON Web Tokens), tokens que permiten acceder a los endpoints bloqueados por autenticación.
	- **Uvicorn:** Permite probar la API en el host local.
	- **Python-Jose:** Encripción de datos con Python, utilizado para la encripción SHA256.
- **Entorno de Desarrollo - Visual Studio Code** Entorno de desarrollo que permite trabajar con múltiples lenguajes de programación y con gran variedad de extensiones que permiten facilitar la programación en cualquier lenguaje.
- **Base de datos Local - SQLite:** Gestor de Bases de Datos Relacionales que permite guardar toda su información en un archivo local. Muy ágil para guardar datos de forma local en dispositivos móviles y de escritorio
- **Base de datos 'En red' - MySQL:** Gestor de Bases de Datos Relacionales de Oracle que permite su acceso desde dispositivos de forma remota, bastante útil para acceder a bases de datos en red.

## Estructura del Proyecto
Las carpetas con todos los ficheros del proyecto están organizados de la siguiente forma:
- **Data Access**: Son los ficheros con todas las clases que realizan operaciones CRUD a una base de datos, algunas de ellas a través de un servicio API. Todas ellas implementan una interfaz DAO para marcar sus recursos principales:
```dart
abstract class DAOInterface<T, V>{ //T es el objeto a obtener y V es el tipo de su identificador en la base de datos
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
```
- **L10n**: Carpeta que contiene los archivos de traducción de la aplicación. Todos ellos se forman por conjuntos de pares clave valor, donde las claves son iguales en todos los ficheros y el valor es un texto traducido al idioma deseado.
- **Model**: Contiene las clases de datos principales de la aplicación.
- **Views**: Guarda las pantallas de la aplicación.
- **ViewModels**: El punto medio entre la vista y los modelos: Guarda recursos compartidos y persistentes por toda la aplicación y que, por medio de listeners, monitorea los datos que se ven en las diferentes pantallas.
- **Utils**: Guarda dos clases con información para el correcto funcionamiento de la aplicación.
  - *Database Utils*: Guarda dos clases con métodos estáticos para acceder a las distintas bases de datos: 
    - ***APIUtils***: Guarda las funciones CRUD esenciales de la API, además de la URL principal para acceder a ésta.
    - ***SQLiteUtils***: Tiene un atributo para acceder a la base de datos y una función para iniciar la base de datos al principio de la aplicación
  - *App Essentials*: Consta de diferentes funciones y atributos estáticos los cuales, en su mayoría, se ejecutan al principio de la aplicación y sirven para iniciar correctamente los proveedores ViewModel.
- **Widgets**: Hay recursos que aparecen instanciados en varias ocasiones o que, por legibilidad de código, se separan de sus respectivas pantallas. Por ello, esta carpeta guarda las clases de recursos.