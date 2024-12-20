import 'package:flutter/material.dart';
import 'package:puzzle_sonrisa/modelo/tarea_secuencial.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:puzzle_sonrisa/modelo/current_user.dart';
import 'package:puzzle_sonrisa/modelo/uri.dart';

class ModificarTareaSecuencial extends StatefulWidget {
  final Tarea tarea;

  ModificarTareaSecuencial({required this.tarea});

  @override
  _ModificarTareaSecuencialState createState() =>
      _ModificarTareaSecuencialState();
}

class _ModificarTareaSecuencialState extends State<ModificarTareaSecuencial> {
  late TextEditingController tituloController;
  late List<TextEditingController> pasosControllers;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    // Initialyze the controllers with the values of the task
    tituloController = TextEditingController(text: widget.tarea.titulo);

    // Initialyze the controllers with the values of the task
    pasosControllers = widget.tarea.pasos
        .map((paso) => TextEditingController(text: paso))
        .toList();
    // Add an empty image controller for each step
    while (widget.tarea.imagenes.length < widget.tarea.pasos.length) {
      widget.tarea.imagenes.add('');
    }
  }

  @override
  void dispose() {
    // Dispose the controllers
    tituloController.dispose();
    for (var controller in pasosControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  // Metodo para subir una imagen
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

  // Metodo para añadir un paso
  void _agregarPaso() {
    setState(() {
      pasosControllers.add(TextEditingController());
      widget.tarea.pasos.add('');
      widget.tarea.imagenes.add('');
      widget.tarea.numero_pasos++;
    });
  }

  // Metodo para eliminar un paso
  void _eliminarPaso(int index) {
    setState(() {
      pasosControllers.removeAt(index);
      widget.tarea.pasos.removeAt(index);
      widget.tarea.imagenes.removeAt(index);
      widget.tarea.numero_pasos--;
    });
  }

  // Metodo para seleccionar una imagen
  Future<void> _seleccionarImagen(int index) async {
    final XFile? imagen = await _picker.pickImage(source: ImageSource.gallery);
    if (imagen != null) {
      final String imagePath = await _subirImagen(imagen);
      if (imagePath.isNotEmpty) {
        setState(() {
          widget.tarea.imagenes[index] = imagePath;
        });
      }
    }
  }

  // Metodo para guardar los cambios
  void _guardarCambios() async {
    // Construye los pasos actualizados
    final List<Map<String, dynamic>> pasosActualizados = [];
    for (int i = 0; i < pasosControllers.length; i++) {
      pasosActualizados.add({
        "numero_paso": i + 1,
        "accion": pasosControllers[i].text,
        "imagen":
            i < widget.tarea.imagenes.length ? widget.tarea.imagenes[i] : '',
      });
    }

    final url = Uri.parse('$uri/tarea/${widget.tarea.id}');
    final token = CurrentUser().token;

    try {
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          "titulo": tituloController.text,
          "numero_pasos": pasosControllers.length,
          "pasos": pasosActualizados,
        }),
      );
      print('Datos enviados: ${json.encode({
            "titulo": tituloController.text,
            "numero_pasos": pasosControllers.length,
            "pasos": pasosActualizados,
          })}');

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tarea actualizada con éxito')),
        );
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Error al actualizar la tarea. Código: ${response.statusCode}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error de conexión: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text("Modificar Tarea Secuencial"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("ACTIVIDAD:"),
              TextField(
                controller: tituloController,
                decoration: InputDecoration(border: OutlineInputBorder()),
              ),
              SizedBox(height: 20),
              Text("Pasos:"),
              for (int i = 0; i < pasosControllers.length; i++) ...[
                Text("Paso ${i + 1}:"),
                TextField(
                  controller: pasosControllers[i],
                  decoration: InputDecoration(
                    hintText: 'Descripción del paso',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () => _seleccionarImagen(i),
                      child: Text('Seleccionar Imagen'),
                    ),
                    SizedBox(width: 10),
                    if (widget.tarea.imagenes[i].isNotEmpty)
                      Image.network(
                        widget.tarea.imagenes[i],
                        width: 50,
                        height: 50,
                      ),
                    Spacer(),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _eliminarPaso(i),
                    ),
                  ],
                ),
                SizedBox(height: 20),
              ],
              Center(
                child: OutlinedButton(
                  onPressed: _agregarPaso,
                  child: Text("Agregar Paso"),
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: _guardarCambios,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                  ),
                  child: Text("Guardar Cambios",
                      style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
