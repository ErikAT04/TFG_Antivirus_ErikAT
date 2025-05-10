## Versión Actual (0.5) - 08/05/2025
**Nuevas Adiciones**:
- Ahora se puede *cerrar sesión de forma remota*. Si no tienes acceso a uno de tus dispositivos y quieres cerrar sesión, sólo tendrás que entrar desde otro dispositivo, mantener pulsado en el que quieras cerrar sesión y pulsar en la opción `Desvincular`.
- El análisis se puede *cancelar* dando al botón `Cancelar` en la pantalla de análisis.
- Se ha añadido la opción de **analizar a partir de un directorio**: El usuario ahora puede elegir qué carpeta analizar dando al botón de `Analizar una carpeta`. ¡Así no tiene que esperar todo el proceso de análisis hasta llegar a su carpeta deseada!.

**Arreglos**:
- Se ha implementado **programación paralela** para que el análisis sea totalmente independiente de la aplicación.

## Antiguas versiones
### Versión 0.4 - 02/02/2025
**Nuevas Adiciones**:
- Se ha añadido la opción de **cambiar de color** a la interfaz. *"Que solo hubiera un color parecía algo aburrido, asi que ahora el usuario puede elegir entre 14 opciones distintas: 7 colores alternando modo claro y oscuro"*.

**Arreglos**:
- Las funciones en red deberían funcionar a sin problema alguno actualmente.


### Versión 0.3 - 23/01/2025
**Nuevas Adiciones**:
- Se ha implementado el **análisis de archivos**, probado en Windows y Android.
- El usuario también puede **restaurar los archivos en cuarentena**\
*"Me parecía raro que el usuario pudiera ver los archivos eliminados pero no pudiera hacer nada a respecto, por lo que ahora puede restaurarlos bajo su propio riesgo"*
- Cuando el equipo detecta un archivo con un virus, envía una notificación a la pantalla del usuario para avisar que ha puesto en cuarentena dicho fichero

**Arreglos**
- Se ha cambiado el acceso de los usuarios y dispositivos\
*"Encontramos varios problemas con las bases de datos, por lo que, de momento, se trabajará con un servicio API para que los usuarios puedan acceder a sus cuentas y dispositivos"*

Para hacer las pruebas que se vean necesarias, se proporciona una emulación de un archivo malicioso [aquí](google.es)

Se lamenta la posible mala experiencia en el análisis de ficheros, aún hace falta mejorar ciertos aspectos.

### Versión 0.2 - 15/01/2025
**Nuevas adiciones**:
- Se ha añadido el apartado de "Versión de Aplicación"
- Se ha implementado funciones de accesibilidad del usuario
- Se ha implementado en la pantalla principal un cambio en el menú de navegación:
	- Si la pantalla es del tamaño de un móvil, se verá en la parte inferior
	- Si la pantalla es excesivamente pequeña o más grande que la de un móvil, se verá en el lado izquierdo.
	- Análisis en progreso: Añadido recorrido en segundo plano con MacOS\
**Arreglos**:
- El usuario ya no puede introducir más de una vez un archivo prohibido

### Versión 0.1 - 05/01/2025
***Inicio de la Aplicación***\
**Nuevas adiciones***:
- Se ha implementado el funcionamiento de las bases de datos local y en red
- Se ha implementado el inicio de sesión y registro
- Se puede añadir y quitar las carpetas prohibidas del equipo
- Se puede cambiar la foto de perfil del usuario dando a la foto en su respectivo menú
- Botones funcionales, se puede cambiar de nombre de usuario, contraseña, etc.
- Análisis en progreso: El botón de momento recorre los ficheros de Android y Windows, sin analizar por falta de API o Recurso de detección de huellas.
- Se guardan las preferencias del usuario en una base de datos local para que carguen nada más abrir la aplicación.
- El usuario puede ver los dispositivos vinculados a su cuenta
- Concepto de lista de archivos en cuarentena creado. No se sabe su resultado actual debido a que no función de análisis
- Añadido modos claro y oscuro y soporte de idiomas.
