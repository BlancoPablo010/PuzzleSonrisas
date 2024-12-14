import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'mostrar_tarea_secuencial.dart'; // Importa la pantalla MostrarTareaSecuencial
import 'package:puzzle_sonrisa/modelo/tarea_secuencial.dart'; // Importa la clase Tarea

class Agenda extends StatelessWidget {
  Agenda({super.key});

  // Lista de tareas por defecto
  final List<Tarea> _tareas = [
    Tarea(
      titulo: 'Usar Microondas',
      numero_pasos: 3,
      pasos: ['Paso 1: Abrir Microondas', 'Paso 2: Meter Comida en el microondas', 'Paso 3: Configurar el tiempo'],
      imagenes: ['img/imagen1.jpeg', 'img/imagen2.jpeg', 'img/configurar_tiempo.jpeg'],
    ),
    Tarea(
      titulo: 'Tarea 2',
      numero_pasos: 2,
      pasos: ['Paso 1: Leer instrucciones', 'Paso 2: Completar tarea'],
      imagenes: ['', 'https://via.placeholder.com/150'],
    ),
    Tarea(
      titulo: 'Tarea 3',
      numero_pasos: 1,
      pasos: ['Paso único: Enviar resultados'],
      imagenes: ['https://via.placeholder.com/150'],
    ),
    Tarea(
      titulo: 'Tarea 4',
      numero_pasos: 2,
      pasos: ['Paso 1: Preparar materiales', 'Paso 2: Realizar actividad'],
      imagenes: ['https://via.placeholder.com/150', 'https://via.placeholder.com/150'],
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
            fontSize: 50, // Ajustar el tamaño del título
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0), // Reduce el padding general
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Número de columnas
            crossAxisSpacing: 20, // Espacio horizontal entre celdas
            mainAxisSpacing: 20, // Espacio vertical entre celdas
            childAspectRatio: 2.5, // Relación ancho/alto más cuadrada
          ),
          itemCount: _tareas.length,
          itemBuilder: (context, index) {
            final tarea = _tareas[index];
            return InkWell(
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
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 40, // Reducir el tamaño del ícono
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.calendar_today, color: Colors.black, size: 20), // Ícono más pequeño
                    ),
                    const SizedBox(height: 12), // Espacio reducido
                    Text(
                      tarea.titulo,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 30, // Tamaño más pequeño del texto
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 6), // Espacio reducido
                    Text(
                      'Pasos: ${tarea.numero_pasos}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 18, color: Colors.grey), // Subtítulo reducido
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
