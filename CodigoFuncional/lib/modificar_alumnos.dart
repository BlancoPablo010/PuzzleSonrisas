import 'package:flutter/material.dart';
import 'package:puzzle_sonrisa/modelo/alumno.dart';

// Modify the student data
class ModificarAlumnos extends StatelessWidget {
  final Alumno alumno;

  final TextEditingController nombreController;
  final TextEditingController apellidosController;
  final TextEditingController dniController;
  final TextEditingController nombreResponsableController;
  final TextEditingController apellidosResponsableController;
  final TextEditingController dniResponsableController;

  String? tipoPreferencia;
  
  // Initialize the controller with the student data
    ModificarAlumnos({super.key, required this.alumno})
      : nombreController = TextEditingController(text: alumno.nombre),
        apellidosController = TextEditingController(text: alumno.apellidos),
        dniController = TextEditingController(text: alumno.dni),
        nombreResponsableController = TextEditingController(text: alumno.nombreResponsable),
        apellidosResponsableController = TextEditingController(text: alumno.apellidosResponsable),
        dniResponsableController = TextEditingController(text: alumno.dniResponsable),
        tipoPreferencia = alumno.preferencia;


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
          title: const Text('Modificar Alumno'),
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
                  'Preferencia',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  hint: const Text('Selecciona la más conveniente'),
                  value: tipoPreferencia,
                  onChanged: (String? newValue) {
                    tipoPreferencia = newValue;
                  },
                  items: <String>['Visual', 'Auditiva', 'Motora']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          // Set clear the text fields
                        },
                        child: const Text('Vaciar'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // Send action
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
