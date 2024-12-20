import 'package:flutter/material.dart';
import 'package:puzzle_sonrisa/paginas/login/loginAlumnos/password_alumnos.dart';

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
    {'id': 1, 'ruta': 'assets/pictogramasUsuario/cerdito.png'},
    {'id': 2, 'ruta': 'assets/pictogramasUsuario/dragón.png'},
    {'id': 3, 'ruta': 'assets/pictogramasUsuario/El gato con botas.png'},
    {'id': 4, 'ruta': 'assets/pictogramasUsuario/genio.png'},
    {'id': 5, 'ruta': 'assets/pictogramasUsuario/hada.png'},
    {'id': 6, 'ruta': 'assets/pictogramasUsuario/sirena.png'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'COLEGIO SAN RAFAEL',
            style: TextStyle(
              fontSize: 60,
              fontWeight: FontWeight.bold,
            ),
          ),
          _crearPictogramasUsuario(context),
          const SizedBox(height: 20),
          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, '/loginAdministrador');
            },
            child: const Text('Iniciar Sesión como Administrador o Profesor', ),
          ),
        ],
      ),
    );
  }

  Widget _crearPictogramasUsuario(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: MediaQuery.of(context).size.height * 0.05),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (int i = 0; i < 3; i++) ...[
              InkWell(
                onTap: () => {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PasswordAlumnos(
                              user: pictogramasUsuario[i]['id'])))
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 5),
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.blue[100],
                  ),
                  child: Image.asset(pictogramasUsuario[i]['ruta'],
                      width: 300, height: 300),
                ),
              ),
              if (i != 2)
                SizedBox(width: MediaQuery.of(context).size.width * 0.1),
            ],
          ],
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.1),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (int i = 3; i < 6; i++) ...[
              InkWell(
                onTap: () => {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PasswordAlumnos(
                              user: pictogramasUsuario[i]['id'])))
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 5),
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.blue[100],
                  ),
                  child: Image.asset(pictogramasUsuario[i]['ruta'],
                      width: 300, height: 300),
                ),
              ),
              if (i != 5)
                SizedBox(width: MediaQuery.of(context).size.width * 0.1),
            ],
          ],
        ),
      ],
    );
  }
}
