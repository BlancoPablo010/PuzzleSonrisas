import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:puzzle_sonrisa/modelo/current_user.dart';
import 'package:puzzle_sonrisa/modelo/uri.dart';
import 'package:http/http.dart' as http;


class PedirMateriales extends StatefulWidget{
  PedirMateriales({Key? key}) : super(key: key);

  @override
  _PedirMaterialesState createState() => _PedirMaterialesState();
}

class _PedirMaterialesState extends State<PedirMateriales> {

  late Future<List<Map<String, dynamic>>> _materiales;

  List<Map<String, dynamic>> _idMaterialesSeleccionados = [];

  @override
  void initState() {
    // TODO: implement initState
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
        List<Map<String, dynamic>> materiales = responseData.map((data) {
          return {
            ...(data as Map<String, dynamic>), // Casting explícito
            'checked': false, // Añade el campo checked
          };
        }).toList();
        return materiales;
      } else {
        throw Exception('Failed to load materiales: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching materiales: $e');
    }
  }

  Future<void> _pedirMateriales() async {
    final url = Uri.parse(uri + '/peticion_material');
    final token = CurrentUser().token;
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(
          {
            'titulo': 'Pedido de materiales',
            'materiales': _idMaterialesSeleccionados,
            'profesor': CurrentUser().id,
            'fecha': DateTime.now().toIso8601String(),
          },
        ),
      );
      if (response.statusCode == 201) {
        Navigator.pop(context);
        const SnackBar(content: Text('Materiales pedidos con éxito.'));
      } else {
        throw Exception('Failed to create peticion: ${response.statusCode} + ${response.request!.headers['body']}');
      }
    } catch (e) {
      throw Exception('Error creando peticion de material: $e');
    }
  }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pedir Materiales'),
      ),
      body: Column(
        children: [
          // GridView escalable
          Expanded(
            child: FutureBuilder(
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
                  return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // 2 columnas
                    crossAxisSpacing: 10.0, // Espacio horizontal entre celdas
                    mainAxisSpacing: 10.0, // Espacio vertical entre celdas
                    childAspectRatio: 5, // Relación de aspecto para elementos
                  ),
                  itemCount: materiales.length,
                  itemBuilder: (context, index) {
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: const [
                            BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            offset: Offset(2, 2),
                          ),
                        ],
                      ),
                      child: CheckboxListTile(
                        title: Text(
                          materiales[index]['titulo'],
                          style: const TextStyle(fontSize: 14),
                        ),
                        value: materiales[index]['checked'],
                        onChanged: (value) {
                          setState(() {
                            materiales[index]['checked'] = value;
                            if (value == true) {
                              _idMaterialesSeleccionados.add({'material': materiales[index]['_id']});
                            } else {
                              _idMaterialesSeleccionados.remove({'material': materiales[index]['_id']});
                            }
                          });
                        },
                        controlAffinity: ListTileControlAffinity.trailing,
                      ),
                    );
                  },
                );
                }
              }
            ),
          ),
          // Botones al final
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  ),
                  onPressed: () {
                    _pedirMateriales();
                  },
                  child: const Text('Finalizar', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}