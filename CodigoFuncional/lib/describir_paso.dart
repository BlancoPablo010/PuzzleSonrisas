import 'package:flutter/material.dart';
import 'package:puzzle_sonrisa/modelo/current_user.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:puzzle_sonrisa/modelo/uri.dart';

class DescribirPaso extends StatefulWidget {
  final int pasosTotales;
  final String titulo;

  DescribirPaso({required this.titulo, required this.pasosTotales});

  @override
  _DescribirPasoState createState() => _DescribirPasoState();
}

class _DescribirPasoState extends State<DescribirPaso> {
  final TextEditingController pasoController = TextEditingController();
  int pasoActual = 1;
  List<Map<String, String>> pasos = [];

  void _siguientePaso() {
    if (pasoController.text.isNotEmpty) {
      pasos.add({'numero_paso': pasoActual.toString(), 'accion': pasoController.text});
    }

    if (pasoActual < widget.pasosTotales) {
      setState(() {
        pasoController.clear();
        pasoActual++;
      });
    } else {
      _guardarTarea(context);
    }
  }

  Future<void> _guardarTarea(BuildContext context) async {
    final url = Uri.parse(uri + '/tareas');
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
          'pasos': pasos
        }),
      );
      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Tarea creada con éxito.')),
        );
        Navigator.pushNamed(context, '/gestionarAlumnos');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al crear la tarea.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error de conexión con el servidor.')),
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Describe el paso $pasoActual de ${widget.pasosTotales}:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            TextField(
              controller: pasoController,
              maxLines: 3,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Descripción del paso',
              ),
            ),
            SizedBox(height: 40),
            SizedBox(
              width: 120,
              child: ElevatedButton(
                onPressed: _siguientePaso,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(
                  _getButtonText(),
                  style: TextStyle(color: Colors.white),
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