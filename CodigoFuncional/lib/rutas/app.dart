import 'package:flutter/material.dart';
import 'package:puzzle_sonrisa/paginas/administrador/asignarTareasAlumno/asignar_tareas.dart';
import 'package:puzzle_sonrisa/paginas/administrador/crearPerfilAlumno/crear_alumno.dart';
import 'package:puzzle_sonrisa/paginas/administrador/mostrarMateriales/crear_material.dart';
import 'package:puzzle_sonrisa/paginas/administrador/mostrarProfesores/crear_profesor.dart';
import 'package:puzzle_sonrisa/paginas/administrador/crearTareasSecuenciales/crear_tarea_secuencial.dart';
import 'package:puzzle_sonrisa/paginas/administrador/mostrarMateriales/mostrar_materiales.dart';
import 'package:puzzle_sonrisa/paginas/administrador/mostrarProfesores/mostrar_profesores.dart';
import 'package:puzzle_sonrisa/paginas/profesor/pedir_materiales.dart';
import 'package:puzzle_sonrisa/paginas/administrador/peticionesProfesores/peticiones_profesores.dart';
import 'package:puzzle_sonrisa/vistas/vista_administrador.dart';
import 'package:puzzle_sonrisa/paginas/login/login.dart';
import 'package:puzzle_sonrisa/paginas/login/loginAlumnos/login_alumnos.dart';
import 'package:puzzle_sonrisa/paginas/administrador/modificarAlumno/mostrar_alumnos.dart';
import 'package:puzzle_sonrisa/paginas/administrador/editarTareasSecuenciales/mostrar_tareas_secuenciales.dart';
import 'package:puzzle_sonrisa/vistas/vista_alumno.dart';
import 'package:puzzle_sonrisa/vistas/vista_profesor.dart';

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
        '/loginAdministrador': (context) => const Login(),
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
        '/peticionesProfesores': (context) => PeticionesProfesores(),
        '/pedirMateriales': (context) => PedirMateriales(),
      },
    );
  }
}
