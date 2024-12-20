import 'package:flutter/material.dart';
import 'package:puzzle_sonrisa/modelo/alumno.dart';

// Modify the student data
// ignore: must_be_immutable
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
    ModificarAlumnos({required this.alumno})
      : nombreController = TextEditingController(text: alumno.nombre),
        apellidosController = TextEditingController(text: alumno.apellidos),
        dniController = TextEditingController(text: alumno.dni),
        nombreResponsableController = TextEditingController(text: alumno.nombreResponsable),
        apellidosResponsableController = TextEditingController(text: alumno.apellidosResponsable),
        dniResponsableController = TextEditingController(text: alumno.dniResponsable),
        tipoPreferencia = alumno.preferencia,
        super();


    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text('Modificar Alumno'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
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
                SizedBox(height: 16),
                Text(
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
                SizedBox(height: 16),
                Text(
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
                SizedBox(height: 16),
                Text(
                  'Padre, Madre o Tutor legal',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                TextField(
                  controller: nombreResponsableController,
                  decoration: InputDecoration(
                    hintText: 'Introduce el nombre del responsable',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                SizedBox(height: 8),
                TextField(
                  controller: apellidosResponsableController,
                  decoration: InputDecoration(
                    hintText: 'Introduce los apellidos del responsable',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                SizedBox(height: 8),
                TextField(
                  controller: dniResponsableController,
                  decoration: InputDecoration(
                    hintText: 'Introduce el DNI del responsable',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Preferencia',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  hint: Text('Selecciona la más conveniente'),
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
                SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          // Set clear the text fields
                        },
                        child: Text('Vaciar'),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // Send action
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: Text(
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
