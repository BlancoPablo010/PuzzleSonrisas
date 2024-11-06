import 'package:flutter/material.dart';
import 'package:puzzle_sonrisa/modelo/tarea_secuencial.dart';

class ModificarTareaSecuencial extends StatefulWidget {
  final Tarea tarea;

  ModificarTareaSecuencial({required this.tarea});

  @override
  _ModificarTareaSecuencialState createState() => _ModificarTareaSecuencialState();
}

class _ModificarTareaSecuencialState extends State<ModificarTareaSecuencial> {
  late TextEditingController tituloController;
  late List<TextEditingController> pasosControllers;

  @override
  void initState() {
    super.initState();
    // Initialyze the controllers with the values of the task
    tituloController = TextEditingController(text: widget.tarea.titulo);

    // Initialyze the controllers with the values of the task
    pasosControllers = widget.tarea.pasos
        .map((paso) => TextEditingController(text: paso))
        .toList();
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
              Center(
                child: Text(
                  "ACTIVIDAD: ${tituloController.text}",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 20),
              for (int i = 0; i < pasosControllers.length; i++) ...[
                Text(
                  "Describe el paso ${i + 1}:",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                TextField(
                  controller: pasosControllers[i],
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'Cambia el contenido del paso',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20),
              ],
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // In next iterations we will implement the functionality to save the changes
                    // Actualize the title and steps in the task object
                    widget.tarea.titulo = tituloController.text;
                    widget.tarea.pasos = pasosControllers.map((c) => c.text).toList();

                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  ),
                  child: Text(
                    'Guardar Cambios',
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
