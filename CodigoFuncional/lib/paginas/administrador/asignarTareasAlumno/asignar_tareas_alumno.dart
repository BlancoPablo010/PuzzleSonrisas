import 'package:flutter/material.dart';
import 'package:puzzle_sonrisa/modelo/current_user.dart';
import 'package:http/http.dart' as http;
import 'package:puzzle_sonrisa/modelo/tarea_secuencial.dart';
import 'dart:convert';
import 'package:puzzle_sonrisa/modelo/uri.dart';
import 'package:puzzle_sonrisa/paginas/administrador/editarTareasSecuenciales/mostrar_tarea_secuencial.dart';

// ignore: must_be_immutable
class AsignarTareasAlumno extends StatefulWidget {
  String idAlumno;
  String nombreAlumno;

  AsignarTareasAlumno({super.key, required this.idAlumno, required this.nombreAlumno});


  @override
  _MostrarTareasSecuencialesState createState() => _MostrarTareasSecuencialesState();
}

class _MostrarTareasSecuencialesState extends State<AsignarTareasAlumno> {
  late Future<List<Map<String, dynamic>>> _tareas;
  late Future<List<Map<String, dynamic>>> _tareasAlumno;

  late String nombreAlumno;

  @override
  void initState() {
    super.initState();
    _tareas = _fetchTareas();
    _tareasAlumno = _fetchTareasAlumno();
    nombreAlumno = widget.nombreAlumno;
  }

  Future<List<Map<String, dynamic>>> _fetchTareas() async {
    final url = Uri.parse(uri + '/tareas');
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

  Future<List<Map<String, dynamic>>> _fetchTareasAlumno() async {
    final url = Uri.parse(uri + '/alumno/${widget.idAlumno}/tareas_asignadas');
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

  Future<void> _desasignarTarea(String idTarea) async {
    final url = Uri.parse(uri + '/alumno/${widget.idAlumno}/desasignar_tarea');
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
        setState(() {
          _tareasAlumno = _fetchTareasAlumno();
        });
      } else {
        throw Exception('Failed to desasignar tarea: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error desasignar tarea: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tareas de $nombreAlumno'),
      ),
      body: Stack(
        children: [FutureBuilder<List<Map<String, dynamic>>>(
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
              return ListView.builder(
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
                  final tarea = Tarea(id: tareaJSON['_id'], titulo: tareaJSON['titulo'], numero_pasos: tareaJSON['numero_pasos'] as int, pasos: pasos, imagenes: imagenes);
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    child: InkWell(
                      onTap: () => {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => MostrarTareaSecuencial(tarea: tarea),
                            ))
                      },
                      child: Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                tarea.titulo,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            ElevatedButton(
                              onPressed: () {
                                _desasignarTarea(tarea.id);
                              }, 
                              child: const Icon(Icons.remove),
                            ),
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

        Positioned(
          bottom: 16,
          left: MediaQuery.of(context).size.width/4,
          width: MediaQuery.of(context).size.width/2,
          child: FloatingActionButton(
            
            
            
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) => _mostrarAsignarTarea(nombreAlumno),
              ));
            }, 
            child: Container(
              child: const Text('Asignar Tarea'),
            ),
          ),
        ),
        ],
      ),
    );
  }

  Widget _mostrarAsignarTarea(String nombreAlumno) {
    
        return Scaffold(
          appBar: AppBar(
            title: Text('Asignar tarea a $nombreAlumno'),
          ),
          body: Stack(
            children: [
              FutureBuilder<List<Map<String, dynamic>>>(
                future: _tareas,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No se encontraron tareas'));
                  } else {
                    final tareas = snapshot.data!;
                    return ListView.builder(
                      shrinkWrap: true,
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
                        final tarea = Tarea(id: tareaJSON['_id'], titulo: tareaJSON['titulo'], numero_pasos: tareaJSON['numero_pasos'] as int, pasos: pasos, imagenes: imagenes);
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                          child: InkWell(
                            onTap: () => {
                              _asignarTarea(tarea.id),
                              Navigator.pop(context),
                              
                            },
                            child: Container(
                              padding: const EdgeInsets.all(16.0),
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 231, 222, 222),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      tarea.titulo,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => MostrarTareaSecuencial(tarea: tarea),
                                      ));
                                    }, 
                                    child: const Row(
                                      children: [
                                        Text('Mostrar tarea'),
                                        SizedBox(width: 8),
                                        Icon(Icons.arrow_right_alt_rounded),
                                      ],
                                    ),
                                  ),
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
            ],
          ),
        );
}
  

  void _asignarTarea(String idTarea) async {
    final url = Uri.parse(uri + '/alumno/${widget.idAlumno}/asignar_tarea');
    final token = CurrentUser().token;
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: json.encode({
          'id_alumno': widget.idAlumno,
          'id_tarea': idTarea,
        }),
      );
      if (response.statusCode == 200) {
        setState(() {
          _tareasAlumno = _fetchTareasAlumno();
        });
      } else {
        throw Exception('Failed to assign tarea: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error assigning tarea: $e');
    }
  }

}                 