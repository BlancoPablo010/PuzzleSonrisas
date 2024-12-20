class Tarea {
  String id;
  String titulo;
  int numero_pasos;
  List<String> pasos;
  String imagenPrincipal;
  List<String> imagenes;

  Tarea({
    required this.id,
    required this.titulo,
    required this.numero_pasos,
    required this.pasos,
    String? imagenPrincipal, // Hacemos que este parámetro sea opcional
    List<String>? imagenes, // Hacemos que este parámetro sea opcional

  }) : imagenes = imagenes ?? [], // Si no se pasa, inicializa como lista vacía
    imagenPrincipal = imagenPrincipal ?? ''; // Si no se pasa, inicializa como lista vacía
}
