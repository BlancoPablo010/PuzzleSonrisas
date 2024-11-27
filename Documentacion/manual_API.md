# Documentación de la API de Gestión de Tareas

Esta API permite la gestión de usuarios y tareas a través de un servidor implementado con Flask y Flask-CORS. 

Esta API se ha implementado mediante el servicio cloud de AZURE, usando una cuenta de estudiante, en un futuro podría ser apliada con el aumento del presupuesto permitiendo localizar los datos en servidores de WE en lugar de Asia, reduciendo así los tiempos necesarios de espera.

A continuación, se presentan los elementos clave de la implementación.

## Requisitos

- Python 3.x
- Flask
- Flask-CORS
- Flask-Bcrypt
- Flask-JWT-Extended
- PyMongo

### Instalación

Para la instalación de los requisitos de nuestra API, puedes utilizar el siguiente comando: 
pip install Flask Flask-CORS Flask-Bcrypt Flask-JWT-Extended pymongo

## Ejecución

La ejecución de la API se realiza mediante el servicio Cloud de AZURE, en este encontramos la base de datos y los elementos necesarios para manejar la API
Por lo que la ejecución en un sistema local no es necesaria ya que esta está siempre en ejecución.