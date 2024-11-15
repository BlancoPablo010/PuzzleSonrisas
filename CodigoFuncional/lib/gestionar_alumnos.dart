import 'dart:js';

import 'package:flutter/material.dart';
import 'package:puzzle_sonrisa/crear_alumno.dart';
import 'package:puzzle_sonrisa/componentes/boton.dart';
import 'package:puzzle_sonrisa/mostrar_alumnos.dart';
import 'package:puzzle_sonrisa/crear_tarea_secuencial.dart';
import 'package:puzzle_sonrisa/mostrar_tareas_secuenciales.dart';

class GestionarAlumnos extends StatelessWidget {
  GestionarAlumnos({super.key});

  final List<Map<String, dynamic>> buttonsData = [
  {
  'image': 'assets/alumno.png',
  'text': 'Crear Perfil de Alumno',
  'OnPressed': () {
    Navigator.push(
        context as BuildContext,
        MaterialPageRoute(builder: (context) => CrearAlumno(),
        ));
  }
},
];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomButton(
                    image: 'assets/alumno.png',
                    text: 'Crear Perfil de Alumno',
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => CrearAlumno(),
                          ));
                    }),
                SizedBox(width: MediaQuery.of(context).size.width*0.1),

                CustomButton(
                    image: 'assets/cruz.png',
                    text: 'Modificar Alumno',
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MostrarAlumnos(),
                          ));
                    }),
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.height*0.2),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomButton(
                    image: 'assets/libros.png',
                    text: 'Crear Tareas Secuenciales',
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => CrearTareaSecuencial(),
                          ));
                    }),
                SizedBox(width: MediaQuery.of(context).size.width*0.1),

                CustomButton(
                    image: 'assets/libros.png',
                    text: 'Editar Tareas Secuenciales',
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MostrarTareasSecuenciales(),
                          ));
                    }),
                SizedBox(width: MediaQuery.of(context).size.width*0.1),

                CustomButton(
                    image: 'assets/profesor.png',
                    text: 'Asignar tareas a alumnos',
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => CrearAlumno(),
                          ));
                    })
              ],
            )

          ],
        ),
      ),
    );
  }
}