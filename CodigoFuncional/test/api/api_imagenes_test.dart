import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;


import 'package:puzzle_sonrisa/modelo/uri.dart';


import 'dart:convert';

void main() {

  group('Pruebas de API de Carga de imágenes', () {
    test('Subida de una imágen válida', () async {
      final bytes = <int>[137, 80, 78, 71]; // Bytes para las pruebas
      
      final response = await http.post(
        Uri.parse('$uriImage/upload'),
        headers: {
          "Content-Type": "application/octet-stream",
          "X-File-Name": "test_image.png"
        },
        body: bytes,
      );

      expect(response.statusCode, 201);
      expect(jsonDecode(response.body)['message'], "Image uploaded successfully");

    });

    test('Subida de una imagen sin bytes', () async {
      final response = await http.post(
        Uri.parse('$uriImage/upload'),
        headers: {
          "X-File-Name": "test_image.png"
        },
        body: null,
      );

      expect(response.statusCode, 404);
      expect(jsonDecode(response.body)['error'], "No file data provided");
    });

    test('Subida de una imagen con un formato incorrecto', () async {
      // Intentar cargar un archivo de texto en lugar de una imagen
      final invalidFileBytes = utf8.encode("This is a text file, not an image.");
      
      final response = await http.post(
        Uri.parse('$uriImage/upload'),
        headers: {
          "Content-Type": "application/octet-stream",
          "X-File-Name": "test_image.txt"
        },
        body: invalidFileBytes,
      );

      expect(response.statusCode, 403);
      expect(jsonDecode(response.body)['error'], "Invalid file type");
    });


    test('Delete de una imagen', () async {
      final response = await http.delete(
        Uri.parse('$uriImage/delete'),
        headers: {
          "X-File-Name": "test_image.png"
        },
      );

      expect(response.statusCode, 200);
      expect(jsonDecode(response.body)['message'], "Image deleted successfully");
    });

    // Test de eliminación de una imagen que no existe
    test('Delete de una imagen que no existe', () async {
      final response = await http.delete(
        Uri.parse('$uriImage/delete'),
        headers: {
          "X-File-Name": "non_existing_image.png"
        },
      );

      expect(response.statusCode, 404);
      expect(jsonDecode(response.body)['error'], "File not found");
    });
  });
}