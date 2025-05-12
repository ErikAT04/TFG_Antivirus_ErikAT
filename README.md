# Magik Antivirus 
Proyecto de fin de grado de Desarrollo de Aplicaciones Multiplataforma:<br> Aplicación de protección ante malware basado en la **detección basada en huellas**.

<img alt="Tiempo de Código:" src="https://img.shields.io/endpoint?url=https://wakapi.dev/api/compat/shields/v1/ByErikAT/interval:any/project:tfg_antivirus_erikat&label=Tiempo%20Utilizado&color=blue">

[Enlace a la memoria del proyecto final](Amo_Toquero_Erik_Memoria_ProyectoFinal_DAM25.pdf)

[Enlace al manual de usuario de la aplicación](Amo_Toquero_Erik_Manual_ProyectoFinal_DAM25.pdf)

[Enlace al repositorio de la API](https://github.com/ErikAT04/TFG_Antivirus_ErikAT_API)

[Enlace a la documentación de la aplicación](https://erikat04.github.io/magik_antivirus_documentation/)


<hr>

## Herramientas utilizadas
- **Python** y su framework de servicios web **FastAPI**.
- **Dart** y su framework de desarrollo de interfaces **Flutter**.
- **MySQL** como gestor de bases de datos relacionales en red.
- **FreeDB** como servicio web de hosting de la base de datos.
- **SQLite** como gestor de bases de datos locales.
- **Vercel** como servicio web de hosting de la API.

## Funciones de la Aplicación
- Gestión de cuentas de usuarios.
  - Inicio y cierre de sesión.
  - Imágenes de perfil.
  - Cambio de contraseña.
  - Cambio de usuario.
  - Borrado de cuenta.
- Protección basada en huellas.
  - Acceso a base de datos de huellas.
  - Análisis recursivo de ficheros.
  - Recorrido en segundo plano.
  - Puesta en cuarentena.
- Modificación de Permisos.
  - Denegación de acceso a ficheros por parte del usuario.
  - Restauración o eliminación de archivos en cuarentena.
- Personalización del usuario.
  - Modos claro y oscuro.
  - Personalización de paleta de colores principal.
  - Cambio de idioma.
- QoL (Quality of Life).
  - Acerca de la Aplicación.
  - Selección múltiple de archivos en cuarentena.
  - Parar el recorrido en segundo plano.
  - Inicio de sesión automático.
  - Cierre de sesión remoto, desde cualquier dispositivo vinculado a la cuenta.

## Detección basada en Huellas
La huella de un archivo es su identificador principal. Se consigue mediante la encripción de todo su código interno, normalmente siguiendo la función hash SHA256 o MD5.

La detección basada en huellas se basa en el almacenamiento de huellas de archivos maléficos en una base de datos, y el recorrido de los archivos del equipo para encontrar alguna huella coincidente. Si se encuentra alguna, el programa considera el archivo como un malware y, dependiendo de la configuración, lo pone en cuarentena o lo elimina directamente.

Frente a otros métodos de detección, la detección basada en huellas tiene la ventaja de ser más rápida. Su principal problema es su vulnerabilidad, debido a que si el archivo se edita, por muy poco que sea, su huella cambia y se pierde la detección. Además, una huella teóricamente sirve para un solo archivo, por lo que se podrán detectar tantos archivos maliciosos como haya registrados en la base de datos. 