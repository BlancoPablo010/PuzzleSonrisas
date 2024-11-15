import 'package:flutter/material.dart';
import 'package:puzzle_sonrisa/modelo/current_user.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MostrarAlumnos extends StatelessWidget {
  const MostrarAlumnos({super.key});

  Future<List<Map<String, dynamic>>> _fetchAlumnos() async {
    final url = Uri.parse('http://127.0.0.1:5000/alumnos');
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

  Future<void> _eliminarAlumno(BuildContext context, String usuario) async {
    final url = Uri.parse('http://127.0.0.1:5000/alumnos/$usuario');
    final token = 'Bearer ${CurrentUser().token}';
    try {
      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': token,
        },
      );
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Alumno eliminado con éxito.')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al eliminar el alumno.')),
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
        title: const Text('Mostrar Alumnos'),
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
                          child: Icon(Icons.person, size: 40, color: Colors.white),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${alumno['nombre']} ${alumno['apellidos']}',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 4),
                              Text("DNI: ${alumno['DNI']}", style: TextStyle(fontSize: 14)),
                              Text("Tutor legal: ${alumno['nombre_tutor_legal']}", style: TextStyle(fontSize: 14)),
                            ],
                          ),
                        ),
                        SizedBox(width: 16),
                        Column(
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                _eliminarAlumno(context, alumno['usuario']);
                                Navigator.pushNamed(context, '/gestionarAlumnos');
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              ),
                              child: Text('Eliminar', style: TextStyle(color: Colors.white)),
                            ),
                            SizedBox(height: 8),
                            OutlinedButton(
                              onPressed: () {
                                // Navigate to the modify student page
                              },
                              style: OutlinedButton.styleFrom(
                                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              ),
                              child: Text('Modificar datos', style: TextStyle(color: Colors.black)),
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
        },
      ),
    );
  }
}