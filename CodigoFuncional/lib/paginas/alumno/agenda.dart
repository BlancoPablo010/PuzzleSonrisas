import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:puzzle_sonrisa/modelo/current_user.dart';
import 'package:puzzle_sonrisa/modelo/uri.dart';
import '../administrador/editarTareasSecuenciales/mostrar_tarea_secuencial.dart'; // Importa la pantalla MostrarTareaSecuencial
import 'package:puzzle_sonrisa/modelo/tarea_secuencial.dart'; // Importa la clase Tarea
import 'package:http/http.dart' as http;

class Agenda extends StatefulWidget {
   Agenda({super.key});

  @override
  State<Agenda> createState() => _AgendaState();
}

class _AgendaState extends State<Agenda> {
  final idCurrentUser = CurrentUser().id;
  late Future<List<Map<String, dynamic>>> _tareasAlumno; // Lista de tareas del alumno
  // Lista de tareas por defecto

  @override
  initState() {
    super.initState();
    _tareasAlumno = _fetchTareasAlumno();
  }

  Future<List<Map<String, dynamic>>> _fetchTareasAlumno() async {
    final url = Uri.parse(uri + '/alumno/$idCurrentUser/tareas_asignadas');
    final token = CurrentUser().token;
    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
      );
      if (response.statusCode == 200) {
        List<dynamic> responseData = json.decode(response.body);
        return responseData.map((data) => data as Map<String, dynamic>).toList();
      } else {
        throw Exception('Failed to load tareas: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching tareas: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Obtener la fecha actual formateada
    final String fechaActual = DateFormat('dd/MM/yyyy').format(DateTime.now());

    return Scaffold(
      backgroundColor: const Color(0xFFE6F2F2),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'AGENDA --- DÍA $fechaActual',
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: 
      FutureBuilder<List<Map<String, dynamic>>>(
          future: _tareasAlumno,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No se encontraron tareas'));
            } else {
              final tareas = snapshot.data!;
              return  GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Número de columnas
                  crossAxisSpacing: 20, // Espacio horizontal entre celdas
                  mainAxisSpacing: 20, // Espacio vertical entre celdas
                  childAspectRatio: 2, // Relación ancho/alto más cuadrada
                ),
                itemCount: tareas.length,
                itemBuilder: (context, index) {
                  final tareaJSON = tareas[index];
                  List<String> pasos = [];
                  List<String> imagenes = [];
                  for (int i = 0; i < (tareaJSON['numero_pasos'] as int); i++) {
                      pasos.add(tareaJSON['pasos'][i]['accion']);
                      if (tareaJSON['pasos'][i]['imagen'] != '') {

                        imagenes.add(tareaJSON['pasos'][i]['imagen']);
                      }
                    
                  }
                  final tarea = Tarea(id: tareaJSON['_id'], titulo: tareaJSON['titulo'], numero_pasos: tareaJSON['numero_pasos'] as int, pasos: pasos, imagenes: imagenes, imagenPrincipal: tareaJSON['imagen_principal']);
                
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    child: InkWell(
                      onTap: () async {
                        // Navegar a MostrarTareaSecuencial con la tarea seleccionada
                        final ret = await (Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MostrarTareaSecuencial(tarea: tarea),
                          ),
                        ));

                        if (ret == "Tarea desasignada") {
                          setState(() {
                            _tareasAlumno = _fetchTareasAlumno();
                          });
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(25),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 2,
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              tarea.titulo,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 30, // Tamaño más pequeño del texto
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 6), // Espacio reducido
                            Image.network(tarea.imagenPrincipal, width: MediaQuery.of(context).size.width * 0.4, height: MediaQuery.of(context).size.height * 0.4),
                            const SizedBox(height: 6), // Espacio reducido
                            Text(
                              'Pasos: ${tarea.numero_pasos}',
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 18, color: Colors.grey), // Subtítulo reducido
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }
          }
      ),
    );
  }
}
