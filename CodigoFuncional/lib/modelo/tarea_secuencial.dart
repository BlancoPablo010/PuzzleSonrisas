class Tarea {
  String id;
  String titulo;
  int numero_pasos;
  List<String> pasos;
  List<String> imagenes;

  Tarea({
    required this.id,
    required this.titulo,
    required this.numero_pasos,
    required this.pasos,
    List<String>? imagenes,  // Hacemos que este parámetro sea opcional
  }) : imagenes = imagenes ?? [];  // Si no se pasa, inicializa como lista vacía
}