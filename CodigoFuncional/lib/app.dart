import 'package:flutter/material.dart';
import 'package:puzzle_sonrisa/asignar_tareas.dart';
import 'package:puzzle_sonrisa/crear_alumno.dart';
import 'package:puzzle_sonrisa/crear_material.dart';
import 'package:puzzle_sonrisa/crear_profesor.dart';
import 'package:puzzle_sonrisa/crear_tarea_secuencial.dart';
import 'package:puzzle_sonrisa/mostrar_materiales.dart';
import 'package:puzzle_sonrisa/mostrar_profesores.dart';
import 'package:puzzle_sonrisa/pedir_materiales.dart';
import 'package:puzzle_sonrisa/vista_administrador.dart';
import 'package:puzzle_sonrisa/login_normal.dart';
import 'package:puzzle_sonrisa/login_alumnos.dart';
import 'package:puzzle_sonrisa/mostrar_alumnos.dart';
import 'package:puzzle_sonrisa/mostrar_tareas_secuenciales.dart';
import 'package:puzzle_sonrisa/vista_alumno.dart';
import 'package:puzzle_sonrisa/vista_profesor.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Colegio San Rafael',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginAlumnos(),
        '/loginAdministrador': (context) => const LoginNormal(),
        '/vistaAdministrador': (context) => VistaAdministrador(),
        '/vistaProfesor': (context) => VistaProfesor(),
        '/vistaAlumno': (context) =>  const VistaAlumno(),
        '/crearAlumno': (context) => CrearAlumno(),
        '/mostrarAlumnos': (context) => MostrarAlumnos(),
        '/mostrarProfesores': (context) => const MostrarProfesores(),
        '/crearProfesor': (context) => CrearProfesor(),
        '/mostrarMateriales': (context) => const MostrarMateriales(),
        '/crearMaterial': (context) => CrearMaterial(),
        '/crearTareaSecuencial': (context) => CrearTareaSecuencial(),
        '/mostrarTareasSecuenciales': (context) => const MostrarTareasSecuenciales(),
        '/asignarTareas': (context) => AsignarTareas(),
        '/pedirMateriales': (context) => PedirMateriales(),
      },
    );
  }
}
