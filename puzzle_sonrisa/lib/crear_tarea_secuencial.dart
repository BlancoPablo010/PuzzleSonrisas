import 'package:flutter/material.dart';
import 'package:puzzle_sonrisa/describir_paso.dart';

class CrearTareaSecuencial extends StatefulWidget {
  @override
  _CrearTareaSecuencialState createState() => _CrearTareaSecuencialState();
}

class _CrearTareaSecuencialState extends State<CrearTareaSecuencial> {
  final TextEditingController tituloController = TextEditingController();
  final TextEditingController pasosController = TextEditingController();

  void _siguientePantalla() {
    int? pasos = int.tryParse(pasosController.text);
    String titulo = tituloController.text;

    if (pasos != null && pasos > 0 && titulo.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DescribirPaso(titulo: titulo, pasosTotales: pasos),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Por favor, introduce un título y un número válido de pasos")),
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
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Título de la Actividad',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              SizedBox(
                width: 300,
                child: TextField(
                  controller: tituloController,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    hintText: 'Introduce el título de la actividad',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                '¿Cuántos pasos son necesarios para llevar a cabo la tarea?',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              SizedBox(
                width: 100,
                child: TextField(
                  controller: pasosController,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              SizedBox(height: 40),
              SizedBox(
                width: 120,
                child: ElevatedButton(
                  onPressed: _siguientePantalla,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding: EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
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
