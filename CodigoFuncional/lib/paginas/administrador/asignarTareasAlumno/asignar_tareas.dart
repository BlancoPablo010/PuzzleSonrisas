import 'package:flutter/material.dart';
import 'package:puzzle_sonrisa/paginas/administrador/asignarTareasAlumno/asignar_tareas_alumno.dart';
import 'package:puzzle_sonrisa/modelo/current_user.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:puzzle_sonrisa/modelo/uri.dart';

class AsignarTareas extends StatelessWidget {
  AsignarTareas({super.key});

  final List<Map<String, dynamic>> pictogramasUsuario= [
    {'id': 1, 'ruta': 'assets/pictogramasUsuario/cerdito.png'},
    {'id': 2, 'ruta': 'assets/pictogramasUsuario/dragón.png'},
    {'id': 3, 'ruta': 'assets/pictogramasUsuario/El gato con botas.png'},
    {'id': 4, 'ruta': 'assets/pictogramasUsuario/genio.png'},
    {'id': 5, 'ruta': 'assets/pictogramasUsuario/hada.png'},
    {'id': 6, 'ruta': 'assets/pictogramasUsuario/sirena.png'},
  ];

  Future<List<Map<String, dynamic>>> _fetchAlumnos() async {
    final url = Uri.parse(uri + '/alumnos');
    final token = 'Bearer ${CurrentUser().token}';
    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': token
        },
      );
      if (response.statusCode == 200) {
        List<dynamic> responseData = json.decode(response.body);
        return responseData.map((data) => data as Map<String, dynamic>).toList();
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tareas alumnos'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchAlumnos(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No se encontraron alumnos'));
          } else {
            final alumnos = snapshot.data!;
            return ListView.builder(
              itemCount: alumnos.length,
              itemBuilder: (context, index) {
                final alumno = alumnos[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) => AsignarTareasAlumno(idAlumno: alumno['_id'], nombreAlumno: '${alumno['nombre']} ${alumno['apellidos']}'),
                      ));
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundColor: Colors.grey.shade400,
                            child: Image.asset(
                              pictogramasUsuario[int.parse(alumno['usuario']) - 1]['ruta'],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${alumno['nombre']} ${alumno['apellidos']}',
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  'Usuario: ${alumno['usuario']}',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Text(
                            'Tareas asignadas: ${alumno['tareas_asignadas'].length}',
                          ),
                          const SizedBox(width: 16),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}