import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:puzzle_sonrisa/modelo/current_user.dart';
import 'package:puzzle_sonrisa/modelo/uri.dart';
import 'package:http/http.dart' as http;


class PasswordAlumnos extends StatefulWidget{
  final int user;
  
  const PasswordAlumnos({super.key, required this.user});
  


  @override
  State<PasswordAlumnos> createState() => _PasswordAlumnosState();
}

class _PasswordAlumnosState extends State<PasswordAlumnos> {
  int user = 0;
  int? lastClickedPictogram;
  List<int> password = [0,0,0];
  int passwordPosicion = 0;
  List<int> passwordCorrecta = [1,1,1];

  @override
  initState() {
    super.initState();
    user = widget.user;
    _getPassword(user);
  }

  Future<void> _getPassword(int user) async {
    final url = Uri.parse('$uri/password/$user');
    try {
      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final stringPassword = responseData['password'];
        passwordCorrecta = stringPassword.split('').map<int>((c) => int.parse(c)).toList();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al obtener la contraseña.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error de red: $e')),
      );
    }
  }

  Future<void> _login(BuildContext context, String usuario, String password) async {
    final url = Uri.parse('$uri/loginAlumno');
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
        CurrentUser().id = responseData['_id'];

        Navigator.pushNamed(context, '/vistaAlumno');
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
                          for (int j = 0; j<password.length; j++) {
                            if (password[j] == 0) {
                              passwordPosicion = j;
                              break;
                            } else if (j == 2) {
                              passwordPosicion = -1;
                            }
                          }
                          if (passwordPosicion != -1) {

                            password[passwordPosicion] = pictogramasPassword[i]['id'];
                            
                          }
                        
                      }),
                    },
                    child: 
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 5),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Image.asset(pictogramasPassword[i]['ruta'], width: 200, height: 200),
                      ),
                    
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
                          for (int j = 0; j<password.length; j++) {
                            if (password[j] == 0) {
                              passwordPosicion = j;
                              break;
                            } else if (j == 2) {
                              passwordPosicion = -1;
                            }
                          }
                          if (passwordPosicion != -1) {

                            password[passwordPosicion] = pictogramasPassword[i]['id'];
                          }
                        
                      }),
                    },
                    child: 
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 5),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Image.asset(pictogramasPassword[i]['ruta'], width: 200, height: 200),
                      ),
                    ),
                    if (i!= 7)
                      SizedBox(width: MediaQuery.of(context).size.width * 0.1),
                ],
              
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.1),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (password[0] != 0) ...[
                  InkWell(
                    onTap: () => {
                      setState(() {
                        password[0] = 0;
                      }),
                    },
                    child: 
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 5),
                          borderRadius: BorderRadius.circular(20),
                          color: password[0] == passwordCorrecta[0] ? Colors.green[100] : Colors.red[100],
                        ),
                        child: Image.asset(pictogramasPassword[password[0] - 1]['ruta'], width: 250, height: 250),
                      ),
                    ),
                ] else ... [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 5),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const SizedBox(width: 250, height: 250),
                  ),
                ],
        
                SizedBox(width: MediaQuery.of(context).size.width * 0.02),

                if (password[1] != 0) ...[
                  InkWell(
                    onTap: () => {
                      setState(() {
                        password[1] = 0;
                      }),
                    },
                    child: 
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 5),
                          borderRadius: BorderRadius.circular(20),
                          color: password[1] == passwordCorrecta[1] ? Colors.green[100] : Colors.red[100],
                        ),
                        child: Image.asset(pictogramasPassword[password[1] - 1]['ruta'], width: 250, height: 250),
                      ),
                    ),
                ] else ... [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 5),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const SizedBox(width: 250, height: 250),
                  ),
                ],

                SizedBox(width: MediaQuery.of(context).size.width * 0.02),

                if (password[2] != 0) ...[
                  InkWell(
                    onTap: () => {
                      setState(() {
                        password[2] = 0;
                      }),
                    },
                    child: 
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 5),
                          borderRadius: BorderRadius.circular(20),
                          color: password[2] == passwordCorrecta[2] ? Colors.green[100] : Colors.red[100],
                        ),
                        child: Image.asset(pictogramasPassword[password[2] - 1]['ruta'], width: 250, height: 250),
                      ),
                    ),
                ] else ... [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 5),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const SizedBox(width: 250, height: 250),
                  ),
                ],
                SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                ElevatedButton(
                  onPressed: () {
                    // Aquí se debe validar la contraseña
                    // Si es correcta, se debe redirigir a la pantalla de inicio
                    // Si es incorrecta, se debe mostrar un mensaje de error

                    _login(context, user.toString(), password.join());
                  },
                  child: Image.asset('assets/flecha.png', width: 200, height: 200),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
