import 'package:flutter/material.dart';
import 'package:puzzle_sonrisa/paginas/alumno/agenda.dart';

class VistaAlumno extends StatefulWidget{
  const VistaAlumno({Key? key}) : super(key: key);

  @override
  _VistaAlumnoState createState() => _VistaAlumnoState();
}

class _VistaAlumnoState extends State<VistaAlumno> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Colegio San Rafael'),
      ),
      body: Agenda(),
    );
  }
}