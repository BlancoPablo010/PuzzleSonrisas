import 'package:flutter_test/flutter_test.dart';
import 'package:puzzle_sonrisa/modelo/tarea_secuencial.dart';
import 'package:puzzle_sonrisa/modelo/current_user.dart';

void main() {
  group('Clase Tarea', () {
    test('Crear una tarea', () {
      final tarea = Tarea(
        id: '1',
        titulo: 'Tarea 1',
        numero_pasos: 3,
        pasos: ['Compras huevos', 'Batir huevos', 'Freir huevos'],
        imagenPrincipal: "test",
        imagenes: ['imagen1.jpg', 'imagen2.jpg', 'imagen3.jpg'],
      );

      expect(tarea.id, '1');
      expect(tarea.titulo, 'Tarea 1');
      expect(tarea.numero_pasos, 3);
      expect(tarea.pasos[0], 'Compras huevos');
      expect(tarea.pasos[1], 'Batir huevos');
      expect(tarea.pasos[2], 'Freir huevos');
      expect(tarea.imagenPrincipal, "test");
      expect(tarea.imagenes[0], 'imagen1.jpg');
      expect(tarea.imagenes[1], 'imagen2.jpg');
      expect(tarea.imagenes[2], 'imagen3.jpg');
    });
    test('Crear un objeto sin imagenPrincipal', () {
      final tarea = Tarea(
        id: '2',
        titulo: 'Hacer comida',
        numero_pasos: 2,
        pasos: ['Comprar ingredientes', 'Cocinar ingredientes'],
        imagenes: ['imagen1.jpg', 'imagen2.jpg', 'imagen3.jpg'],
      );

      expect(tarea.imagenPrincipal, "");
    });
    
    test('Crear un objeto sin imagenes', () {
      final tarea = Tarea(
        id: '3',
        titulo: 'Hacer comida',
        numero_pasos: 2,
        pasos: ['Comprar ingredientes', 'Cocinar ingredientes'],
      );
      expect(tarea.imagenes, []);
    });

    test('Crear un objeto Tarea con pasos vacíos', () {
      final tarea = Tarea(
        id: '4',
        titulo: 'Hacer comida',
        numero_pasos: 0,
        pasos: [],
      );
      expect(tarea.pasos, []);
    });

    test('Verificar el número de pasos', () {
      final tarea = Tarea(
        id: '5',
        titulo: 'Hacer comida',
        numero_pasos: 2,
        pasos: ['Comprar ingredientes', 'Cocinar ingredientes'],
      );
      expect(tarea.numero_pasos, tarea.pasos.length);
    });
  });


  group('Clase CurrentUser', () {
    test('Crear un objeto CurrentUser', () {
      final currentUser = CurrentUser();
      expect(currentUser, isNotNull);
    
    });

    test('Verificar que el token es nulo', () {
      final currentUser = CurrentUser();
      expect(currentUser.token, isNull);
    });

    test('Verificar que el rol es nulo', () {
      final currentUser = CurrentUser();
      expect(currentUser.rol, isNull);
    });

    test('Verificar que el id es nulo', () {
      final currentUser = CurrentUser();
      expect(currentUser.id, isNull);
    });

    test('Verificar que el token no es nulo', () {
      final currentUser = CurrentUser();
      currentUser.token = '123456';
      expect(currentUser.token, isNotNull);
    });

    test('Verificar que el rol no es nulo', () {
      final currentUser = CurrentUser();
      currentUser.rol = 'admin';
      expect(currentUser.rol, isNotNull);
    });

    test('Verificar que el id no es nulo', () {
      final currentUser = CurrentUser();
      currentUser.id = '123';
      expect(currentUser.id, isNotNull);
    });
  });
}
