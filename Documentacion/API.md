# Documentación de la API Puzzle de Sonrisas

Esta API permite la gestión de usuarios, tareas, materiales y peticiones de materiales a través de un servidor implementado con Flask y Flask-CORS.

La API está alojada en un servidor de Azure y puede ser accedida mediante el siguiente enlace: [https://puzzle-sonrisas-1-app-cceabja8g7d6huav.westeurope-01.azurewebsites.net](https://puzzle-sonrisas-1-app-cceabja8g7d6huav.westeurope-01.azurewebsites.net).

---

## Ejecución
Puedes realizar pruebas y consumir sus servicios utilizando la URL base proporcionada.

Para operaciones protegidas, asegúrate de incluir el token JWT en los encabezados de la solicitud como:

```http
Authorization: Bearer <tu_token>
```

Para ello deberás tener una cuenta registrada en la api, una vez hecho esto recibirás el token de autenticación JWT que podrás incluir en los encabezados.

---

## Base de Datos

Optamos por utilizar una base de datos no relacional (MongoDB) debido a la flexibilidad y el cómodo manejo de datos en formato JSON, ideal para nuestro caso de uso. Esta decisión nos permite manejar conexiones de manera eficiente y adaptarnos fácilmente a cambios en los datos.

Para acceder a la base de datos, disponemos de una terminal en Azure que permite ejecutar consultas como find, realizar actualizaciones o eliminar colecciones utilizando comandos de MongoDB. Esto facilita la administración directa de los datos almacenados en el sistema.

## Endpoints de la API

### Autenticación

#### Registro de usuario

**POST** `/register`

- **Descripción:** Registra un nuevo usuario en el sistema.
- **Cuerpo de la solicitud:**
  ```json
  {
    "usuario": "nombre_usuario",
    "password": "contraseña",
    "rol": "rol_usuario"  // Administrador, Alumno, Profesor
  }
  ```
- **Respuestas:**
  - **201:** Usuario registrado con éxito.
  - **409:** El usuario ya existe.

#### Inicio de sesión

**POST** `/login`

- **Descripción:** Permite a los usuarios iniciar sesión y obtener un token de acceso.
- **Cuerpo de la solicitud:**
  ```json
  {
    "usuario": "nombre_usuario",
    "password": "contraseña"
  }
  ```
- **Respuestas:**
  - **200:** Token de acceso y datos del usuario.
  - **401:** Credenciales inválidas.

#### Inicio de sesión de alumnos

**POST** `/loginAlumno`

- **Descripción:** Inicia sesión exclusivamente para usuarios con rol de "Alumno".
- **Cuerpo de la solicitud:** Igual que `/login`.
- **Respuestas:** Igual que `/login`.

---

### Usuarios

#### Crear alumno

**POST** `/alumno`

- **Descripción:** Crea un nuevo usuario con rol de "Alumno".
- **Cuerpo de la solicitud:**
  ```json
  {
    "usuario": "nombre_usuario",
    "password": "contraseña",
    "nombre": "nombre",
    "apellidos": "apellidos",
    "preferencia": "preferencias_personales"
  }
  ```
- **Respuestas:**
  - **201:** Alumno creado con éxito.
  - **400:** Falta un campo obligatorio.

#### Obtener lista de alumnos

**GET** `/alumnos`

- **Descripción:** Devuelve la lista de usuarios con rol de "Alumno".
- **Respuestas:**
  - **200:** Lista de alumnos.

#### Eliminar alumno

**DELETE** `/alumnos/<usuario>`

- **Descripción:** Elimina un usuario con rol de "Alumno".
- **Respuestas:**
  - **200:** Alumno eliminado con éxito.
  - **404:** Alumno no encontrado.

---

### Tareas

#### Crear tarea

**POST** `/tarea`

- **Descripción:** Crea una nueva tarea.
- **Cuerpo de la solicitud:**
  ```json
  {
    "titulo": "título_tarea",
    "numero_pasos": 3,
    "pasos": [
      { "numero_paso": 1, "accion": "Descripción del paso", "imagen": "url_imagen" },
      { "numero_paso": 2, "accion": "Descripción del paso", "imagen": "url_imagen" },
      { "numero_paso": 3, "accion": "Descripción del paso", "imagen": "url_imagen" }
    ]
  }
  ```
- **Respuestas:**
  - **201:** Tarea creada con éxito.
  - **400:** Error en los datos proporcionados.

#### Obtener lista de tareas

**GET** `/tareas`

- **Descripción:** Devuelve la lista de todas las tareas.
- **Respuestas:**
  - **200:** Lista de tareas.

#### Eliminar tarea

**DELETE** `/tareas/<id>`

- **Descripción:** Elimina una tarea por su ID.
- **Respuestas:**
  - **200:** Tarea eliminada con éxito.
  - **404:** Tarea no encontrada.

---

### Materiales

#### Crear material

**POST** `/material`

- **Descripción:** Crea un nuevo material.
- **Cuerpo de la solicitud:**
  ```json
  {
    "titulo": "título_material",
    "imagen": "url_imagen"
  }
  ```
- **Respuestas:**
  - **201:** Material creado con éxito.
  - **400:** Falta un campo obligatorio.

#### Obtener lista de materiales

**GET** `/materiales`

- **Descripción:** Devuelve la lista de materiales.
- **Respuestas:**
  - **200:** Lista de materiales.

#### Eliminar material

**DELETE** `/materiales/<id>`

- **Descripción:** Elimina un material por su ID.
- **Respuestas:**
  - **200:** Material eliminado con éxito.
  - **404:** Material no encontrado.

---

### Peticiones de Materiales

#### Crear petición de material

**POST** `/peticion_material`

- **Descripción:** Crea una nueva petición de material.
- **Cuerpo de la solicitud:**
  ```json
  {
    "titulo": "título_petición",
    "materiales": ["material1", "material2"],
    "profesor": "id_profesor",
    "fecha": "yyyy-mm-dd"
  }
  ```
- **Respuestas:**
  - **201:** Petición creada.
  - **400:** Falta un campo obligatorio.

#### Obtener lista de peticiones

**GET** `/peticiones`

- **Descripción:** Devuelve la lista de peticiones de materiales.
- **Respuestas:**
  - **200:** Lista de peticiones.

#### Eliminar petición

**DELETE** `/peticiones/<id>`

- **Descripción:** Elimina una petición por su ID.
- **Respuestas:**
  - **200:** Petición eliminada con éxito.
  - **404:** Petición no encontrada.

