import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:puzzle_sonrisa/modelo/current_user.dart';
import 'package:puzzle_sonrisa/modelo/uri.dart';
import 'package:http/http.dart' as http;


class MostrarMateriales extends StatefulWidget {
  const MostrarMateriales({Key? key}) : super(key: key);

  @override
  _MostrarMaterialesState createState() => _MostrarMaterialesState();

}

class _MostrarMaterialesState extends State<MostrarMateriales> {

  late Future<List<Map<String, dynamic>>> _materiales;
  
  @override
  void initState() {
    _materiales = _fetchMateriales();
    super.initState();
  }

  Future<List<Map<String, dynamic>>> _fetchMateriales() async {
    final url = Uri.parse(uri + '/materiales');
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
        throw Exception('Failed to load materiales: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching materiales: $e');
    }
  }

  Future<void> _eliminarMaterial(String id) async {
    final url = Uri.parse(uri + '/materiales/$id');
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
          _materiales = _fetchMateriales();
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('material eliminado')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al eliminar material: ${response.statusCode}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al eliminar material: $e')),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Materiales'),
      ),
      body: Stack(
        children: [
          FutureBuilder(
            future: _materiales, 
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No se encontraron materiales'));
              } else {
                final materiales = snapshot.data!;
                return ListView.builder(
                  itemCount: materiales.length,
                  itemBuilder: (context, index) {
                    final material = materiales[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                      child: Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${material['titulo']}',
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            ClipOval(
                              child: Image.network(
                                material['imagen'],
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Column(
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    _eliminarMaterial(material['_id']);
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
                final response = await Navigator.pushNamed(context, '/crearMaterial');

                if (response == 'Material creado') {
                  setState(() {
                    _materiales = _fetchMateriales();
                  });
                }
              },
              child: const Text('Crear material', style: TextStyle(color: Colors.black)),
            ),
          ),
        ],
      ),
    );
  }
}