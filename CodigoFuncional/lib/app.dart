import 'package:flutter/material.dart';
import 'package:puzzle_sonrisa/crear_alumno.dart';
import 'package:puzzle_sonrisa/crear_tarea_secuencial.dart';
import 'package:puzzle_sonrisa/gestionar_alumnos.dart';
import 'package:puzzle_sonrisa/login_page.dart';
import 'package:puzzle_sonrisa/mostrar_alumnos.dart';
import 'package:puzzle_sonrisa/mostrar_tareas_secuenciales.dart';

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
        '/': (context) => const LoginPage(),
        '/gestionarAlumnos': (context) => GestionarAlumnos(),
        '/crearAlumno': (context) => CrearAlumno(),
        '/mostrarAlumnos': (context) => const MostrarAlumnos(),
        '/crearTareaSecuencial': (context) => CrearTareaSecuencial(),
        '/mostrarTareasSecuenciales': (context) => const MostrarTareasSecuenciales(),
        '/agenda': (context) => const SizedBox(), // Falta esto
      },
    );
  }
}
