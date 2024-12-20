import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:puzzle_sonrisa/modelo/current_user.dart';
import 'package:puzzle_sonrisa/modelo/uri.dart';
import 'package:http/http.dart' as http;


class PeticionesProfesores extends StatefulWidget {
  const PeticionesProfesores({Key? key}) : super(key: key);

  @override
  _PeticionesProfesoresState createState() => _PeticionesProfesoresState();

}

class _PeticionesProfesoresState extends State<PeticionesProfesores> {

  late Future<List<Map<String, dynamic>>> _peticiones;
  List<Map<String, dynamic>> _profesores = [];
  
  @override
  void initState() {
    init();
    _peticiones = _fetchPeticiones();
    super.initState();
  }

  void init() async {
    await _fetchProfesores();
  }



  Future<List<Map<String, dynamic>>> _fetchPeticiones() async {
    final url = Uri.parse(uri + '/peticiones');
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
        throw Exception('Failed to load peticiones: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching peticiones: $e');
    }
  }

  Future<void> _fetchProfesores() async {
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
        _profesores = responseData.map((data) => data as Map<String, dynamic>).toList();
      } else {
        throw Exception('Failed to load profesor: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching profesor: $e');
    }
  }

  Future<List<Map<String, dynamic>>> _fetchMateriales(List<Map<String, dynamic>> materiales) async {
    List<Map<String, dynamic>> _materiales = [];
    for (var material in materiales) {
      final url = Uri.parse(uri + '/materiales/${material['material']}');
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
          dynamic responseData = json.decode(response.body);
          _materiales.add(responseData as Map<String, dynamic>);
        } else {
          throw Exception('Failed to load material: ${response.statusCode}');
        }
      } catch (e) {
        throw Exception('Error fetching material: $e');
      }
    }

    return _materiales;
  }


  Future<void> _eliminarPeticion(String id) async {
    final url = Uri.parse(uri + '/peticiones/$id');
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
          _peticiones = _fetchPeticiones();
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Peticion completada')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al completar peticion: ${response.statusCode}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al completar peticion: $e')),
      );
    }
  }

  Future<void> _crearTareaMaterial(List<Map<String, dynamic>> materiales) async {
    final url = Uri.parse(uri + '/tarea');
    final token = CurrentUser().token;
    List<Map<String, dynamic>> pasos = [];
    for (int i=0; i<materiales.length; i++) {
      pasos.add({
        'numero_paso': i+1,
        'accion': 'Recoger material: ${materiales[i]['titulo']}',
        'imagen': materiales[i]['imagen'],
      });
    }
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: json.encode({
          'titulo': 'Tarea de recogida de materiales',
          'numero_pasos': materiales.length,
          'pasos': pasos,
        }),
      );
      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tarea de materiales creada con éxito.')),
        );
      } else {
        throw Exception('Failed to create tarea: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error creating tarea: $e');
    }
  }

// AQUÍ DA ERROR
  void _aceptar(Map<String, dynamic> peticion) async {
    if (peticion['materiales'] == null || peticion['materiales'] is! List) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('La petición no contiene materiales válidos.')),
      );
      return;
    }
    try {
      List<Map<String, dynamic>> materiales = await _fetchMateriales(
        (peticion['materiales'] as List).cast<Map<String, dynamic>>()
      );
      await _crearTareaMaterial(materiales);
      await _eliminarPeticion(peticion['_id']);
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al procesar la petición: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Peticiones'),
      ),
      body: Stack(
        children: [
          FutureBuilder(
            future: _peticiones, 
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No se encontraron peticiones'));
              } else {
                final peticiones = snapshot.data!;
                return ListView.builder (
                  itemCount: peticiones.length,
                  itemBuilder: (context, index) {
                    final peticion = peticiones[index];
                    final profesor = _profesores.firstWhere((profesor) => profesor['_id'] == peticion['profesor']);
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
                              child: InkWell(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: const Text('Crear tarea de materiales'),
                                        content: const Text('¿Está seguro de crear la tarea?'),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text('Cancelar'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              _aceptar(peticion);
                                            },
                                            child: const Text('Aceptar'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${peticion['titulo']}',
                                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      'Profesor: ${profesor['nombre']} ${profesor['apellidos']}',
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                    Text(
                                        'Fecha: ${DateTime.parse(peticion['fecha']).toLocal().toString().split(' ')[0]}',
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                );
              }
            }
          ),
        ],
      ),
    );
  }
}