import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:puzzle_sonrisa/modelo/current_user.dart';
import 'package:puzzle_sonrisa/modelo/uri.dart';
import 'package:puzzle_sonrisa/password_alumnos.dart';

class LoginAlumnos extends StatefulWidget {
  const LoginAlumnos({super.key});

  @override
  State<LoginAlumnos> createState() => _LoginAlumnosState();
}

class _LoginAlumnosState extends State<LoginAlumnos> {

  int user = 0;
  int? lastClickedPictogram;
  List<int> password = [];

  final List<Map<String, dynamic>> pictogramasUsuario= [
    {'id': 1, 'nombre': 'círculo', 'ruta': 'assets/pictogramasUsuario/cerdito.png'},
    {'id': 2, 'nombre': 'cuadrado', 'ruta': 'assets/pictogramasUsuario/dragón.png'},
    {'id': 3, 'nombre': 'triángulo', 'ruta': 'assets/pictogramasUsuario/El gato con botas.png'},
    {'id': 4, 'nombre': 'rombo', 'ruta': 'assets/pictogramasUsuario/genio.png'},
    {'id': 5, 'nombre': 'estrella', 'ruta': 'assets/pictogramasUsuario/hada.png'},
    {'id': 6, 'nombre': 'pentágono', 'ruta': 'assets/pictogramasUsuario/sirena.png'},
  ];

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Image.asset(
                'assets/logo.png',
                width: 100,
                height: 100,
              ),
            ),
            const Text(
              'COLEGIO SAN RAFAEL ALUMNOS',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            _crearPictogramasUsuario(context),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/loginAdministrador');
              },
              child: const Text('Iniciar Sesión como Administrador', ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _crearPictogramasUsuario(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: MediaQuery.of(context).size.height * 0.1),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (int i=0; i<3; i++) ...[
              InkWell(
              onTap: () => {
                Navigator.push(context, MaterialPageRoute(builder: (context) => PasswordAlumnos(user: pictogramasUsuario[i]['id'])))
              },
              child: 
                Image.asset(pictogramasUsuario[i]['ruta'], width: 200, height: 200)
              ),
              if (i!= 2)
                SizedBox(width: MediaQuery.of(context).size.width * 0.1),
            ],
          ],
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.1),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (int i=3; i<6; i++) ...[
              InkWell(
              onTap: () => {
                Navigator.push(context, MaterialPageRoute(builder: (context) => PasswordAlumnos(user: pictogramasUsuario[i]['id'])))
              },
              child: 
                Image.asset(pictogramasUsuario[i]['ruta'], width: 200, height: 200)
              ),
              if (i!= 5)
                SizedBox(width: MediaQuery.of(context).size.width * 0.1),
            ],
          ],
        ),
      ],
    );
  }
}
