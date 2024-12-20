import 'package:flutter/material.dart';
import 'package:puzzle_sonrisa/modelo/current_user.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:puzzle_sonrisa/modelo/uri.dart';

class DescribirPaso extends StatefulWidget {
  final int pasosTotales;
  final String titulo;
  final String imagenPrincipal;

  DescribirPaso(
      {required this.titulo,
      required this.pasosTotales,
      required this.imagenPrincipal});

  @override
  _DescribirPasoState createState() => _DescribirPasoState();
}

class _DescribirPasoState extends State<DescribirPaso> {
  final TextEditingController pasoController = TextEditingController();
  int pasoActual = 1;
  List<Map<String, dynamic>> pasos = [];
  final ImagePicker _picker = ImagePicker();
  final List<String> _imagenesElegidas = [];

  void _siguientePaso() {
    if (pasoController.text.isNotEmpty) {
      pasos.add({
        'numero_paso': pasoActual,
        'accion': pasoController.text,
        'imagen': _imagenesElegidas.isNotEmpty &&
                _imagenesElegidas.length >= pasoActual
            ? _imagenesElegidas[pasoActual - 1]
            : ''
      });
    }

    // Solo avanzar si no es la última fase
    if (pasoActual < widget.pasosTotales) {
      setState(() {
        pasoController.clear();
        pasoActual++;
      });
    } else {
      _guardarTarea(context);
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

  Future<void> _guardarTarea(BuildContext context) async {
    final url = Uri.parse(uri + '/tarea');
    final token = CurrentUser().token;
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: json.encode({
          'titulo': widget.titulo,
          'numero_pasos': widget.pasosTotales,
          'pasos': pasos,
          'imagen_principal': widget.imagenPrincipal,
        }),
      );
      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tarea creada con éxito.')),
        );
        Navigator.pushNamed(context, '/gestionarAlumnos');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Error al crear la tarea. Error ${response.statusCode}.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error de conexión con el servidor.')),
      );
    }
  }

  Future<String> _agregarImagen() async {
    final XFile? imagen = await _picker.pickImage(source: ImageSource.gallery);
    String imagenPath = await _subirImagen(imagen!);

    if (imagenPath != "") {
      setState(() {
        _imagenesElegidas.add(imagenPath);
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Describe el paso $pasoActual de ${widget.pasosTotales}:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: pasoController,
              maxLines: 3,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Descripción del paso',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _agregarImagen,
              child: Text('Agregar imagen'),
            ),
            // Mostrar la imagen elegida en el paso actual
            if (_imagenesElegidas.isNotEmpty &&
                _imagenesElegidas.length >= pasoActual)
              Image.network(_imagenesElegidas[pasoActual - 1],
                  height: 200, width: 200), // Mostrar imagen local
            const SizedBox(height: 40),
            SizedBox(
              width: 120,
              child: ElevatedButton(
                onPressed: _siguientePaso,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(
                  _getButtonText(),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getButtonText() {
    if (pasoActual < widget.pasosTotales) {
      return 'Siguiente';
    } else {
      return 'Finalizar';
    }
  }
}
