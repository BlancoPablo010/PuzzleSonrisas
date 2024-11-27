import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:puzzle_sonrisa/modelo/current_user.dart';
import 'package:puzzle_sonrisa/modelo/uri.dart';
import 'package:http/http.dart' as http;


class PasswordAlumnos extends StatefulWidget{
  final int user;
  
  const PasswordAlumnos({Key? key, required this.user}) : super(key: key);
  


  @override
  State<PasswordAlumnos> createState() => _PasswordAlumnosState();
}

class _PasswordAlumnosState extends State<PasswordAlumnos> {
  int user = 0;
  int? lastClickedPictogram;
  List<int> password = [];

  @override
  initState() {
    super.initState();
    user = widget.user;
  }

  Future<void> _login(BuildContext context, String usuario, String password) async {
    final url = Uri.parse(uri + '/loginAlumno');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'usuario': usuario, 'password': password}),
      );
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        CurrentUser().rol = responseData['rol'];
        CurrentUser().token = responseData['access_token'];

        Navigator.pushNamed(context, '/agenda');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login fallido: Credenciales incorrectas.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error de red: $e')),
      );
    }
  }

  // Lista de pictogramas con sus IDs y rutas
  final List<Map<String, dynamic>> pictogramasPassword = [
    {'id': 1, 'nombre': 'círculo', 'ruta': 'assets/pictogramasPassword/círculo.png'},
    {'id': 2, 'nombre': 'cuadrado', 'ruta': 'assets/pictogramasPassword/cuadrado.png'},
    {'id': 3, 'nombre': 'triángulo', 'ruta': 'assets/pictogramasPassword/triángulo.png'},
    {'id': 4, 'nombre': 'rombo', 'ruta': 'assets/pictogramasPassword/rombo.png'},
    {'id': 5, 'nombre': 'estrella', 'ruta': 'assets/pictogramasPassword/estrella.png'},
    {'id': 6, 'nombre': 'pentágono', 'ruta': 'assets/pictogramasPassword/pentágono.png'},
    {'id': 7, 'nombre': 'corazón', 'ruta': 'assets/pictogramasPassword/corazón.png'},
    {'id': 8, 'nombre': 'espiral', 'ruta': 'assets/pictogramasPassword/espiral.png'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Selecciona un pictograma'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                
                for (int i=0; i<4; i++) ...[
                  InkWell(
                    onTap: () => {
                      setState(() {
                        password.add(pictogramasPassword[i]['id']);
                      }),
                    },
                    child: 
                      Image.asset(pictogramasPassword[i]['ruta'], width: 200, height: 200)
                    ),
                    if (i!= 3)
                      SizedBox(width: MediaQuery.of(context).size.width * 0.1),
                ],
              ],

            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.1),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (int i=4; i<8; i++) ...[
                  InkWell(
                    onTap: () => {
                      setState(() {
                        password.add(pictogramasPassword[i]['id']);
                      }),
                    },
                    child: 
                      Image.asset(pictogramasPassword[i]['ruta'], width: 200, height: 200)
                    ),
                    if (i!= 7)
                      SizedBox(width: MediaQuery.of(context).size.width * 0.1),
                ],
              
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.1),
            if (password.isNotEmpty) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (int i = 0; i < password.length; i++)
                    Image.asset(pictogramasPassword[password[i] - 1]['ruta'], width: 250, height: 250),
                  if (password.length == 3) ...[
                    const SizedBox(height: 50),
                    ElevatedButton(
                      onPressed: () {
                        // Aquí se debe validar la contraseña
                        // Si es correcta, se debe redirigir a la pantalla de inicio
                        // Si es incorrecta, se debe mostrar un mensaje de error
                        print('Usuario: ${user.toString()}');
                        print('Contraseña: ${password.join()}');

                        _login(context, user.toString(), password.join());
                      },
                      child: Image.asset('assets/flecha.png', width: 200, height: 200),
                    ),
                  ]
                  else
                    const SizedBox(width: 200),
                ],
              ),
              
            ]
            else 
              const SizedBox(height: 250),
          ],
        ),
      ),
    );
  }
}
