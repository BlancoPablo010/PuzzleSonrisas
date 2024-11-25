import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:puzzle_sonrisa/modelo/current_user.dart';
import 'package:puzzle_sonrisa/modelo/uri.dart';


class CrearAlumno extends StatelessWidget {
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController apellidosController = TextEditingController();
  final TextEditingController dniController = TextEditingController();
  final TextEditingController nombreResponsableController = TextEditingController();
  final TextEditingController apellidosResponsableController = TextEditingController();
  final TextEditingController dniResponsableController = TextEditingController();
  final TextEditingController usuarioController = TextEditingController();
  final TextEditingController contrasenaController = TextEditingController();

  String? tipoDiscapacidad;

  Future<void> _crearAlumno(BuildContext context) async {
    final url = Uri.parse(uri + '/alumnos');
    final token = 'Bearer ${CurrentUser().token}';
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': token,
          },
        body: json.encode({
          'usuario': usuarioController.text,
          'password': contrasenaController.text,
          'nombre': nombreController.text,
          'apellidos': apellidosController.text,
          'DNI': dniController.text,
          'nombre_tutor_legal': nombreResponsableController.text,
          'apellidos_tutor_legal': apellidosResponsableController.text,
          'DNI_tutor_legal': dniResponsableController.text,
          'discapacidad': tipoDiscapacidad,
        }),
      );
      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Alumno creado con éxito.')),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al crear el alumno.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error de conexión con el servidor.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Crear Alumno'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Nombre',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              TextField(
                controller: nombreController,
                decoration: InputDecoration(
                  hintText: 'Introduce el nombre.',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Apellidos',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              TextField(
                controller: apellidosController,
                decoration: InputDecoration(
                  hintText: 'Introduce los apellidos.',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'DNI',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              TextField(
                controller: dniController,
                decoration: InputDecoration(
                  hintText: 'Introduce el DNI',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Padre, Madre o Tutor legal',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: nombreResponsableController,
                decoration: InputDecoration(
                  hintText: 'Introduce el nombre del responsable',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: apellidosResponsableController,
                decoration: InputDecoration(
                  hintText: 'Introduce los apellidos del responsable',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: dniResponsableController,
                decoration: InputDecoration(
                  hintText: 'Introduce el DNI del responsable',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Discapacidad',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                hint: const Text('Selecciona la más conveniente'),
                value: tipoDiscapacidad,
                onChanged: (String? newValue) {
                  tipoDiscapacidad = newValue;
                },
                items: <String>['Visual', 'Auditiva', 'Motora']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              const SizedBox(height: 8),
              const Text(
                'Datos de inicio de sesión',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              TextField(
                controller: usuarioController,
                decoration: InputDecoration(
                  hintText: 'Introduce el usuario con el que el alumno entrará en la aplicación',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: contrasenaController,
                decoration: InputDecoration(
                  hintText: 'Introduce la contraseña con la que el alumno entrará en la aplicación',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        // Set clear all text fields
                        nombreController.clear();
                        apellidosController.clear();
                        dniController.clear();
                        nombreResponsableController.clear();
                        apellidosResponsableController.clear();
                        dniResponsableController.clear();
                        usuarioController.clear();
                        contrasenaController.clear();
                        tipoDiscapacidad = null;
                      },
                      child: const Text('Vaciar'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        _crearAlumno(context);

                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text(
                        'Enviar',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}