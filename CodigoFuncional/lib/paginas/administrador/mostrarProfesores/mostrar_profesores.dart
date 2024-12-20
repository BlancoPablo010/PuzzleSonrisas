import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:puzzle_sonrisa/modelo/current_user.dart';
import 'package:puzzle_sonrisa/modelo/uri.dart';
import 'package:http/http.dart' as http;


class MostrarProfesores extends StatefulWidget {
  const MostrarProfesores({Key? key}) : super(key: key);

  @override
  _MostrarProfesoresState createState() => _MostrarProfesoresState();

}

class _MostrarProfesoresState extends State<MostrarProfesores> {

  late Future<List<Map<String, dynamic>>> _profesores;
  
  @override
  void initState() {
    _profesores = _fetchProfesores();
    super.initState();
  }

  Future<List<Map<String, dynamic>>> _fetchProfesores() async {
    final url = Uri.parse(uri + '/profesores');
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
        throw Exception('Failed to load profesores: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching profesores: $e');
    }
  }

  Future<void> _eliminarProfesor(String id) async {
    final url = Uri.parse(uri + '/profesores/$id');
    final token = CurrentUser().token;
    try {
      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
      );
      if (response.statusCode == 200) {
        setState(() {
          _profesores = _fetchProfesores();
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profesor eliminado')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al eliminar profesor: ${response.statusCode}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al eliminar profesor: $e')),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profesores'),
      ),
      body: Stack(
        children: [
          FutureBuilder(
            future: _profesores, 
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No se encontraron profesores'));
              } else {
                final profesores = snapshot.data!;
                return ListView.builder(
                  itemCount: profesores.length,
                  itemBuilder: (context, index) {
                    final profesor = profesores[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                      child: Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${profesor['nombre']} ${profesor['apellidos']}',
                                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    'Usuario: ${profesor['usuario']}',
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            Column(
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    _eliminarProfesor(profesor['_id']);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.black,
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  ),
                                  child: const Text('Eliminar', style: TextStyle(color: Colors.white)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }
            }
          ),
          Positioned(
            bottom: 50,
            left: MediaQuery.of(context).size.width/3,
            width: MediaQuery.of(context).size.width/3,
            child: ElevatedButton(
              onPressed: () async {
                final response = await Navigator.pushNamed(context, '/crearProfesor');

                if (response == 'Profesor creado') {
                  setState(() {
                    _profesores = _fetchProfesores();
                  });
                }
              },
              child: const Text('Crear profesor', style: TextStyle(color: Colors.black)),
            ),
          ),
        ],
      ),
    );
  }
}