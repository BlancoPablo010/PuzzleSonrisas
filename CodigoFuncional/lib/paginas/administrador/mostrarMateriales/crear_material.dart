import 'package:flutter/material.dart';
import 'package:puzzle_sonrisa/modelo/current_user.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:puzzle_sonrisa/modelo/uri.dart';

class CrearMaterial extends StatefulWidget {

  CrearMaterial({Key? key}) : super(key: key);

  @override
  _CrearMaterialState createState() => _CrearMaterialState();
}

class _CrearMaterialState extends State<CrearMaterial> {
  final TextEditingController tituloController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  late String _imagen = '';

  Future<String> _subirImagen(XFile imagen) async {
    
    final url = Uri.parse('$uriImage/upload');

    try {
      // Convertir la imagen a bytes
      final bytes = await imagen.readAsBytes();
      final String fileName = imagen.name;

      // Realizar la solicitud POST
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/octet-stream',
          'X-File-Name': fileName,
        },
        body: bytes
      );

      // Verificar la respuesta
      if (response.statusCode == 201) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        return responseData['file_path']; // Devuelve la ruta del archivo como respuesta
      } else {
        print('Error al subir la imagen: ${response.statusCode}');
        return ''; // Devolver cadena vacía en caso de error
      }
    } catch (e) {
      print('Error: $e');
      return ''; // Devolver cadena vacía en caso de error
    }
  }

  Future<void> _crearMaterial(BuildContext context) async {
    final url = Uri.parse(uri + '/material');
    final token = CurrentUser().token;
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: json.encode({
          'titulo': tituloController.text,
          'imagen': _imagen,
        }),
      );
      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Material creado con éxito.')),
        );
        Navigator.pop(context, 'Material creado');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al crear el material. Error ${response.statusCode}.')),
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
        _imagen = imagenPath;
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
          const Text(
            'Título del material:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          TextField(
            controller: tituloController,
            maxLines: 3,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Título',
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _agregarImagen,
            child: const Text('Agregar imagen'),
          ),
          // Mostrar la imagen elegida en el paso actual
          if (_imagen != '') ...[

            Image.network(_imagen, height: 200, width: 200), // Mostrar imagen local
            SizedBox(
              width: 120,
              child: ElevatedButton(
                onPressed: () {
                  _crearMaterial(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'Crear',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ],
      ),
    ),
  );
  }

}

