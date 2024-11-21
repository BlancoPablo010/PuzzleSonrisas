## Documentación del Sprint
# Sprint 1
  **Fecha de inicio**: 31 de Octubre
  **Fecha de finalización**: 3 de Noviembre

## Objetivos del Sprint
  - Crear la página principal del administrador-
  - Añadir las funcionalidades del administrador, como crear tareas, asignarlas, etc.

## Historias de Usuario
  1. **HU-03** Asignar tareas a estudiantes
    - **Descripción:** Como administrador del centro, quiero asignar tareas a los estudiantes para que puedan consultarlas y realizarlas de manera autónoma.
    - **Criterios de Aceptación:**
       - Dado que un alumno ha marcado una tarea como completada, cuando reviso la tarea y selecciono "aprobar", entonces la tarea se marca como aprobada en el perfil del alumno.
       - Dado que una tarea ha sido asignada, cuando el estudiante consulta su perfil, entonces debe visualizar la tarea asignada y tener la opción de marcarla como en proceso o completada.
  2. **HU-20** Aprobar tareas completadas
    - **Descripción:** Como administrador, quiero aprobar las tareas completadas por los alumnos, para asegurar que se hayan realizado correctamente.
    - **Criterios de Aceptación:**
      - Dado que un alumno ha marcado una tarea como completada, cuando reviso la tarea y selecciono "aprobar", entonces la tarea se marca como aprobada en el perfil del alumno.
      - Dado que estoy en la lista de tareas pendientes de aprobación, cuando rechazo una tarea, entonces la tarea permanece en el estado de no aprobada y el alumno recibe una notificación para realizarla nuevamente.

  3. **HU-21** Revisar tareas realizadas diariamente
    - **Descripción:** Como administrador, quiero revisar las tareas que ha realizado cada alumno diariamente.
    - **Criterios de Aceptación:**
      - Dado que estoy en la sección de revisión de tareas, cuando selecciono un alumno, entonces veo un listado de las tareas que ha realizado en el día.
      - Dado que estoy revisando las tareas de un alumno, cuando accedo a una tarea específica, entonces puedo ver los detalles y la fecha de finalización.
    
  4. **HU-24** Añadir un nuevo alumno
    - **Descripción:** Como administrador, quiero añadir un nuevo alumno a la aplicación para asignarles tareas.
    - **Criterios de Aceptación:**
      - Dado que estoy en la sección de gestión de alumnos, cuando añado la información de un nuevo alumno y guardo, entonces el alumno aparece en la lista de estudiantes.
      - Dado que añado un alumno sin completar todos los campos requeridos, cuando intento guardar la información, entonces la aplicación muestra un mensaje indicando que debo completar los campos obligatorios.

  5. **HU-25** Eliminar alumnos de la aplicación
    - **Descripción:** Como administrador, quiero poder eliminar alumnos de la aplicación para que no figuren más en el sistema.
    - **Criterios de Aceptación:**
      - Dado que estoy en la lista de alumnos, cuando selecciono un alumno y elijo "eliminar", entonces el alumno desaparece de la lista.
      - Dado que he eliminado a un alumno, cuando busco su perfil en el sistema, entonces no aparece en los resultados de búsqueda.
    
  6. **HU-26** Crear perfiles de estudiantes con contraseña adaptada
    - **Descripción:** Como administrador, quiero crear perfiles de estudiantes en el sistema, de forma que se les pueda asignar un tipo de contraseña (texto o imagen) según sus capacidades para el inicio de sesión.
    - **Criterios de Aceptación:**
      - Dado que estoy creando un perfil de estudiante, cuando selecciono el tipo de contraseña (texto o imagen), entonces el estudiante debe ver ese tipo de inicio de sesión al acceder.
      - Dado que el tipo de contraseña es de imagen, cuando el estudiante accede al sistema, entonces se le solicita una imagen como contraseña en lugar de texto.

  6. **HU-27** Poner fecha límite a una tarea asignada
    - **Descripción:** Como administrador, quiero poder poner fecha límite a una tarea asignada a un alumno.
    - **Criterios de Aceptación:**
      - Dado que estoy asignando una tarea a un alumno, cuando establezco una fecha límite y guardo la tarea, entonces el estudiante ve la fecha límite en la tarea asignada.
      - Dado que la fecha límite de una tarea ha pasado, cuando el alumno intenta marcar la tarea como completada, entonces recibe un aviso indicando que la tarea está fuera de plazo.
    
  7. **HU-28** Crear tareas secuenciales
    - **Descripción:** Como administrador, quiero crear tareas secuenciales (“por pasos”) para los alumnos, como puede ser usar el microondas, donde se indica paso a paso qué hacer.
    - **Criterios de Aceptación:**
      - Dado que estoy en la sección de creación de tareas, cuando selecciono la opción de "tarea secuencial" y añado varios pasos, entonces la tarea se guarda con los pasos definidos.
      - Dado que una tarea secuencial ha sido creada, cuando el alumno accede a la tarea, entonces ve los pasos de la tarea en el orden indicado.
    
  8. **HU-29** Modificar una tarea secuencial (Añadir pasos)
    - **Descripción:** Como administrador, quiero modificar una tarea secuencial (“por pasos”) para poder añadir más pasos.
    - **Criterios de Aceptación:**
      - Dado que estoy en la edición de una tarea secuencial, cuando selecciono la opción "añadir paso" y guardo la tarea, entonces el nuevo paso aparece al final de la lista de pasos de la tarea.
      - Dado que he añadido un paso nuevo a una tarea secuencial, cuando el alumno consulta la tarea, entonces el paso añadido aparece en el orden correcto.

  9. **HU-30** Modificar una tarea secuencial (Eliminar pasos)
    - **Descripción:** Como administrador, quiero modificar una tarea secuencial (“por pasos”) para poder eliminar pasos de la tarea.
    - **Criterios de Aceptación:**
      - Dado que estoy en la edición de una tarea secuencial, cuando selecciono un paso y elijo la opción de "eliminar", entonces el paso se borra de la secuencia.
      - Dado que he eliminado un paso, cuando el alumno consulta la tarea, entonces el paso eliminado ya no aparece en la lista de pasos.
        
  10. **HU-32** Acceso a la aplicación
    - **Descripción:** Como administrador, quiero acceder a la aplicación para realizar las diferentes gestiones.
    - **Criterios de Aceptación:**
      - Dado que soy un administrador con credenciales válidas, cuando ingreso mi usuario y contraseña en la pantalla de inicio de sesión, entonces accedo a la interfaz de administración de la aplicación.
      - Dado que intento acceder sin credenciales válidas, cuando ingreso un usuario o contraseña incorrecta, entonces recibo un mensaje de error y no puedo acceder a la aplicación.

## Retrospectiva
  ### Aspectos Negativos
  - Mala comunicación y organicación del equipo.
  - Mala planificación de las Historias de Usuario.
  - No mostar el avance con el cliente/profesor semanalmente.
    

## Notas Adicionales
  Hemos decidido realizar las siguientes modificaciones de cara a la siguiente iteración para que el trabajo salga adelante sin dificultades:
     - Organizar el equipo por trabajo, no por Historias de Usuario, asignando el trabajo por tareas no por Historias de Usuario. Dividiéndonos en 3 equipos: diseño, organización y desarrollo.
     - Asistencia a clase más frecuente, para realizar correctamente el proyecto cumpliendo las expectativas del cliente/profesor.
     - Estimar mejor las Historias de Usuario, con lo aprendido de la primera iteración hemos reestructurado algunas historias de usuario para que se adapten mejor a nuestro estilo de trabajo.
     - Realizar reuniones con mayor frecuencia.
     - Mayor enfoque en las Historias de Usuario prioritarias.

  La Historia de Usuario 11 la realizará el colegio y la 18 hemos decidido realizarla en posteriores iteraciones.
