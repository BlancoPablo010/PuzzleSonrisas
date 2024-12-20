import 'package:flutter/material.dart';
import 'package:puzzle_sonrisa/modelo/current_user.dart';
import 'package:http/http.dart' as http;
import 'package:puzzle_sonrisa/modelo/tarea_secuencial.dart';
import 'dart:convert';
import 'package:puzzle_sonrisa/modelo/uri.dart';
import 'package:puzzle_sonrisa/paginas/administrador/editarTareasSecuenciales/mostrar_tarea_secuencial.dart';
import 'package:puzzle_sonrisa/paginas/administrador/editarTareasSecuenciales/modificar_tarea_secuencial.dart';

class MostrarTareasSecuenciales extends StatefulWidget {
  const MostrarTareasSecuenciales({super.key});

  @override
  _MostrarTareasSecuencialesState createState() =>
      _MostrarTareasSecuencialesState();
}

class _MostrarTareasSecuencialesState extends State<MostrarTareasSecuenciales> {
  late Future<List<Map<String, dynamic>>> _tareas;

  @override
  void initState() {
    super.initState();
    _tareas = _fetchTareas();
  }

  Future<List<Map<String, dynamic>>> _fetchTareas() async {
    final url = Uri.parse('$uri/tareas');
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
        return responseData
            .map((data) => data as Map<String, dynamic>)
            .toList();
      } else {
        throw Exception('Failed to load tareas: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching tareas: $e');
    }
  }

  Future<void> _eliminarTarea(BuildContext context, String id) async {
    final url = Uri.parse(uri + '/tareas/$id');
    final token = 'Bearer ${CurrentUser().token}';
    try {
      final response = await http.delete(
        url,
        headers: {'Content-Type': 'application/json', 'Authorization': token},
      );
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tarea eliminada con éxito.')),
        );
        setState(() {
          _tareas = _fetchTareas(); // Recargar las tareas
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al eliminar la tarea.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error de conexión con el servidor.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Actividades Creadas'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
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
                final tarea = Tarea(
                    id: tareaJSON['_id'],
                    titulo: tareaJSON['titulo'],
                    numero_pasos: tareaJSON['numero_pasos'] as int,
                    pasos: pasos,
                    imagenes: imagenes);
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  child: InkWell(
                    onTap: () => {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                MostrarTareaSecuencial(tarea: tarea),
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
                          Row(
                            children: [
                              OutlinedButton(
                                onPressed: () {
                                  _eliminarTarea(context, tarea.id);
                                },
                                style: OutlinedButton.styleFrom(
                                  minimumSize: const Size(70, 36),
                                ),
                                child: const Text('Borrar'),
                              ),
                              const SizedBox(width: 8),
                              ElevatedButton(
                                onPressed: () async {
                                  final resultado = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ModificarTareaSecuencial(
                                              tarea: tarea),
                                    ),
                                  );
                                  if (resultado != null && resultado) {
                                    setState(() {
                                      _tareas = _fetchTareas();
                                    });
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black,
                                  minimumSize: const Size(70, 36),
                                ),
                                child: const Text(
                                  'Editar',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
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
    );
  }
}
