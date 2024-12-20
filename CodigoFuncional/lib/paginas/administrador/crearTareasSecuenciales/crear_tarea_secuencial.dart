import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:puzzle_sonrisa/paginas/administrador/crearTareasSecuenciales/describir_paso.dart';
import 'package:http/http.dart' as http;
import 'package:puzzle_sonrisa/modelo/uri.dart';

class CrearTareaSecuencial extends StatefulWidget {
  const CrearTareaSecuencial({super.key});

  @override
  _CrearTareaSecuencialState createState() => _CrearTareaSecuencialState();
}

class _CrearTareaSecuencialState extends State<CrearTareaSecuencial> {
  final TextEditingController tituloController = TextEditingController();
  final TextEditingController pasosController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  String imagenPrincipal = '';

  void _siguientePantalla() {
    int? pasos = int.tryParse(pasosController.text);
    String titulo = tituloController.text;

    if (pasos != null && pasos > 0 && titulo.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DescribirPaso(
              titulo: titulo,
              pasosTotales: pasos,
              imagenPrincipal: imagenPrincipal),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                "Por favor, introduce un título y un número válido de pasos")),
      );
    }
  }

  Future<String> _subirImagen(XFile imagen) async {
    final url = Uri.parse(uriImage + '/upload');

    try {
      // Convertir la imagen a bytes
      final bytes = await imagen.readAsBytes();
      final String fileName = imagen.name;

      // Realizar la solicitud POST
      final response = await http.post(url,
          headers: {
            'Content-Type': 'application/octet-stream',
            'X-File-Name': fileName,
          },
          body: bytes);

      // Verificar la respuesta
      if (response.statusCode == 201) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        return responseData[
            'file_path']; // Devuelve la ruta del archivo como respuesta
      } else {
        print('Error al subir la imagen: ${response.statusCode}');
        return ''; // Devolver cadena vacía en caso de error
      }
    } catch (e) {
      print('Error: $e');
      return ''; // Devolver cadena vacía en caso de error
    }
  }

  Future<String> _agregarImagen() async {
    final XFile? imagen = await _picker.pickImage(source: ImageSource.gallery);
    String imagenPath = await _subirImagen(imagen!);

    if (imagenPath != "") {
      setState(() {
        imagenPrincipal = imagenPath;
      });
    }

    return imagenPath;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Título de la Actividad',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: 300,
                child: TextField(
                  controller: tituloController,
                  textAlign: TextAlign.center,
                  decoration: const InputDecoration(
                    hintText: 'Introduce el título de la actividad',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                '¿Cuántos pasos son necesarios para llevar a cabo la tarea?',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: 100,
                child: TextField(
                  controller: pasosController,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              SizedBox(height: 40),
              ElevatedButton(
                onPressed: _agregarImagen,
                child: Text('Agregar imagen'),
              ),
              // Mostrar la imagen elegida en el paso actual
              if (imagenPrincipal != '')
                Image.network(imagenPrincipal,
                    height: 200, width: 200), // Mostrar imagen local
              SizedBox(height: 8),
              SizedBox(
                width: 120,
                child: ElevatedButton(
                  onPressed: _siguientePantalla,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    'Siguiente',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



/**
  No se puede crear mas de una tarea por sesión, pero la primera se crea bn 
  Las fotos 

 */