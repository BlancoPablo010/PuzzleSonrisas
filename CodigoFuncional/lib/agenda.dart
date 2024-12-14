import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'mostrar_tarea_secuencial.dart'; // Importa la pantalla MostrarTareaSecuencial
import 'package:puzzle_sonrisa/modelo/tarea_secuencial.dart'; // Importa la clase Tarea

class Agenda extends StatelessWidget {
   Agenda({super.key});

  // Lista de tareas por defecto
  final List<Tarea> _tareas = [
    Tarea(
      id: '1',
      titulo: 'Usar Microondas',
      numero_pasos: 3,
      pasos: ['Paso 1: Abrir Microondas', 'Paso 2: Meter Comida en el microondas', 'Paso 3: Configurar el tiempo'],
      imagenes: ['img/abrir_microondas.jpeg', 'img/meter_comida.jpeg', 'img/configurar_tiempo.jpeg'],
    ),
    Tarea(
      id: '2',
      titulo: 'Tarea 2',
      numero_pasos: 2,
      pasos: ['Paso 1: Leer instrucciones', 'Paso 2: Completar tarea'],
      imagenes: ['', 'https://via.placeholder.com/150'],
    ),
    Tarea(
      id: '3',
      titulo: 'Tarea 3',
      numero_pasos: 1,
      pasos: ['Paso único: Enviar resultados'],
      imagenes: ['https://via.placeholder.com/150'],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    // Obtener la fecha actual formateada
    final String fechaActual = DateFormat('dd/MM/yyyy').format(DateTime.now());

    return Scaffold(
      backgroundColor: const Color(0xFFE6F2F2),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'AGENDA --- DÍA $fechaActual',
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: _tareas.length,
        itemBuilder: (context, index) {
          final tarea = _tareas[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: InkWell(
              onTap: () {
                // Navegar a MostrarTareaSecuencial con la tarea seleccionada
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MostrarTareaSecuencial(tarea: tarea),
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: ListTile(
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.calendar_today, color: Colors.black),
                  ),
                  title: Text(
                    tarea.titulo,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  subtitle: Text(
                    'Pasos: ${tarea.numero_pasos}',
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
