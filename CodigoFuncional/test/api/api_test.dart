import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

import 'package:puzzle_sonrisa/modelo/uri.dart';


import 'dart:convert';


void main() {

  group('API Tests', () {
    late String authToken;

    setUpAll(() async {
      final loginResponse = await http.post(
        Uri.parse('$uri/login'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "usuario": "admin",
          "password": "123"
        }),
      );
      final loginBody = jsonDecode(loginResponse.body);
      authToken = loginBody['access_token'];
    });

    test('Crear y Borrar a un usuario', () async {
      final createUserResponse = await http.post(
        Uri.parse('$uri/register'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
        "usuario": "test_user",
        "password": "1234",
        "rol": "Alumno"
        }),
      );

      expect(createUserResponse.statusCode, 201);

      // Elimina el usuario creado
      final deleteResponse = await http.delete(
        Uri.parse('$uri/alumnos/test_user'),
        headers: {"Authorization": "Bearer $authToken"},
      );

      expect(deleteResponse.statusCode, 200);
      expect(jsonDecode(deleteResponse.body)['message'], "Alumno eliminado con éxito");
    });

    test('Crear y Borrar tareas', () async {
      // Crear una nueva tarea
      final createResponse = await http.post(
        Uri.parse('$uri/tarea'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $authToken"
        },
        body: jsonEncode({
          "titulo": "Tarea para Borrar",
          "numero_pasos": 2,
          "pasos": [
            {"numero_paso": 1, "accion": "Paso 1", "imagen": "imagen1.jpg"},
            {"numero_paso": 2, "accion": "Paso 2", "imagen": "imagen2.jpg"}
          ]
        }),
      );

      expect(createResponse.statusCode, 201);
      final createBody = jsonDecode(createResponse.body);
      final taskId = createBody['tarea_id'];

      // Borrar la tarea creada
      final deleteResponse = await http.delete(
        Uri.parse('$uri/tareas/$taskId'),
        headers: {"Authorization": "Bearer $authToken"},
      );

      expect(deleteResponse.statusCode, 200);
      expect(jsonDecode(deleteResponse.body)['message'], "Tarea eliminada con éxito");
    });

    test('Get de todas las tareas', () async {
      final response = await http.get(
        Uri.parse('$uri/tareas'),
        headers: {"Authorization": "Bearer $authToken"},
      );

      expect(response.statusCode, 200);
      final tasks = jsonDecode(response.body);
      expect(tasks, isA<List>());
    });

    test('Login as a student', () async {
      // Primero, crea un usuario con rol de Alumno
      await http.post(
        Uri.parse('$uri/alumno'),
        headers: {"Content-Type": "application/json", 
          "Authorization": "Bearer $authToken"},
        body: jsonEncode({
          "usuario": "test_login_alumno",
          "password": "123",
          "nombre": "test_nombre",
          "apellidos": "test_apellidos",
          "preferencia": "test_preferencia",
        }),
      );

      // Ahora intenta iniciar sesión como el alumno creado
      final loginResponse = await http.post(
        Uri.parse('$uri/loginAlumno'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "usuario": "test_login_alumno",
          "password": "123"
        }),
      );

      // Verificar que el login fue exitoso
      expect(loginResponse.statusCode, 200);
      final loginBody = jsonDecode(loginResponse.body);
      expect(loginBody, contains('access_token'));
      expect(loginBody['rol'], "Alumno");

      // Ahora eliminar al alumno creado
      await http.delete(
        Uri.parse('$uri/alumnos/test_login_alumno'),
        headers: {"Authorization": "Bearer $authToken"},
      );
    });

    
  });
}