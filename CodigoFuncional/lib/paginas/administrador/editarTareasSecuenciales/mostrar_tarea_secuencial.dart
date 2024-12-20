import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:puzzle_sonrisa/modelo/current_user.dart';
import 'package:puzzle_sonrisa/modelo/tarea_secuencial.dart';
import 'package:puzzle_sonrisa/modelo/uri.dart';
import 'package:http/http.dart' as http;


class MostrarTareaSecuencial extends StatefulWidget {
  final Tarea tarea;

  const MostrarTareaSecuencial({super.key, required this.tarea});

  @override
  _MostrarTareaSecuencialState createState() => _MostrarTareaSecuencialState();
}

class _MostrarTareaSecuencialState extends State<MostrarTareaSecuencial> {
  int _currentStep = 0;

  Future<void> _desasignarTarea(String idUsuario, String idTarea) async {
    final url = Uri.parse(uri + '/alumno/${idUsuario}/desasignar_tarea');
    final token = CurrentUser().token;
    try {
      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: json.encode({
          'id_tarea': idTarea,
        }),
      );
      if (response.statusCode == 200) {
        Navigator.pop(context, 'Tarea desasignada');
      } else {
        throw Exception('Failed to desasignar tarea: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error desasignar tarea: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    Color fondoColor = Colors.grey[200]!;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
            
        ),
        title: Text(
            
            '${widget.tarea.titulo} ${_currentStep + 1}/${widget.tarea.pasos.length}',
            style: const TextStyle(color: Colors.black, fontSize: 40, fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
        backgroundColor: fondoColor,
        toolbarHeight: 80,
      ),
      body: Container(
        color: fondoColor,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (widget.tarea.imagenes.isNotEmpty && widget.tarea.imagenes[_currentStep] != "")
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Image.network(
                      widget.tarea.imagenes[_currentStep], 
                      height: MediaQuery.of(context).size.height * 0.4,
                      fit: BoxFit.cover,
                    ),
                  ),
                Text(
                  widget.tarea.pasos.isNotEmpty ? widget.tarea.pasos[_currentStep] : "No hay pasos disponibles",
                  style: const TextStyle(fontSize: 60),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (_currentStep > 0)
                        IconButton(
                          icon: const Icon(Icons.arrow_back, size: 250),
                          onPressed: () {
                            setState(() {
                              _currentStep--;
                            });
                          },
                        ),
                      const Spacer(),
                      if (_currentStep < widget.tarea.pasos.length - 1)
                        IconButton(
                          icon: const Icon(Icons.arrow_forward, size: 250),
                          onPressed: () {
                            setState(() {
                              _currentStep++;
                            });
                          },
                        ),
                      if (_currentStep == widget.tarea.pasos.length - 1)
                        IconButton(
                          icon: const Icon(Icons.check, size: 250),
                          onPressed: () {
                            if (CurrentUser().rol == 'Alumno') {
                              _desasignarTarea(CurrentUser().id!, widget.tarea.id);
                            }
                            else {
                              Navigator.pop(context);
                            }
                          },
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}