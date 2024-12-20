import 'package:flutter/material.dart';
import 'package:puzzle_sonrisa/widgets/boton.dart';

class VistaAdministrador extends StatelessWidget {
  VistaAdministrador({super.key});

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
                    image: 'assets/paginaAdministrador/alumno.png',
                    text: 'Crear Perfil de Alumno',
                    onPressed: () {
                      Navigator.pushNamed(context, '/crearAlumno');
                    }),

                SizedBox(width: MediaQuery.of(context).size.width*0.1),

                CustomButton(
                    image: 'assets/paginaAdministrador/cruz.png',
                    text: 'Modificar Alumno',
                    onPressed: () {
                      Navigator.pushNamed(context, '/mostrarAlumnos');
                    }),

                SizedBox(width: MediaQuery.of(context).size.width*0.1),

                CustomButton(
                    image: 'assets/paginaAdministrador/profesor.png',
                    text: 'Mostrar Profesores',
                    onPressed: () {
                      Navigator.pushNamed(context, '/mostrarProfesores');
                    }),

                SizedBox(width: MediaQuery.of(context).size.width*0.1),

                CustomButton(
                image: 'assets/paginaAdministrador/lapiz.png',
                text: 'Mostrar Materiales',
                onPressed: () {
                  Navigator.pushNamed(context, '/mostrarMateriales');
                }),
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.height*0.2),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomButton(
                    image: 'assets/paginaAdministrador/libros.png',
                    text: 'Crear Tareas Secuenciales',
                    onPressed: () {
                      Navigator.pushNamed(context, '/crearTareaSecuencial');
                    }),
                SizedBox(width: MediaQuery.of(context).size.width*0.1),

                CustomButton(
                    image: 'assets/paginaAdministrador/libros.png',
                    text: 'Editar Tareas Secuenciales',
                    onPressed: () {
                      Navigator.pushNamed(context, '/mostrarTareasSecuenciales');
                    }),
                SizedBox(width: MediaQuery.of(context).size.width*0.1),

                CustomButton(
                    image: 'assets/paginaAdministrador/profesor.png',
                    text: 'Asignar tareas a alumnos',
                    onPressed: () {
                      Navigator.pushNamed(context, '/asignarTareas');
                    }),
                SizedBox(width: MediaQuery.of(context).size.width*0.1),

                CustomButton(
                    image: 'assets/paginaAdministrador/profesor.png',
                    text: 'Peticiones de profesores',
                    onPressed: () {
                      Navigator.pushNamed(context, '/peticionesProfesores');
                    })
              ],
            )

          ],
        ),
      ),
    );
  }
}