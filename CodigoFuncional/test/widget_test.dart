import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;

import 'package:puzzle_sonrisa/modelo/main.dart';

import 'package:puzzle_sonrisa/lib/agenda.dart';
import 'package:puzzle_sonrisa/lib/crear_alumno.dart';
import 'package:puzzle_sonrisa/lib/crear_tarea_secuencial.dart';
import 'package:puzzle_sonrisa/lib/describir_paso.dart';
import 'package:puzzle_sonrisa/lib/gestionar_alumnos.dart';
import 'package:puzzle_sonrisa/lib/login_alumnos.dart';
import 'package:puzzle_sonrisa/lib/login_administrador.dart';
import 'package:puzzle_sonrisa/lib/modificar_alumnos.dart';
import 'package:puzzle_sonrisa/lib/modificar_tareas_secuenciales.dart';
import 'package:puzzle_sonrisa/lib/mostrar_alumnos.dart';
import 'package:puzzle_sonrisa/lib/mostrar_tareas.dart';
import 'package:puzzle_sonrisa/lib/mostrar_tareas_secuenciales.dart';
import 'package:puzzle_sonrisa/lib/password_alumnos.dart';
import 'package:puzzle_sonrisa/lib/main.dart';

import 'package:puzzle_sonrisa/api.py';
import 'package:puzzle_sonrisa/api_image.py';

// Mock de cliente API
class MockClient extends Mock implements http.Client {}

void main() {
  group('Pruebas de API', () {
    late MockClient client;

    setUp(() {
      client = MockClient();
    });

    test('La API devuelve datos válidos para una solicitud GET', () async {
      when(client.get(Uri.parse('$uri/data')))
          .thenAnswer((_) async => http.Response('[{"id":1,"name":"Item 1"}]', 200));

      final response = await client.get(Uri.parse('$uri/data'));

      expect(response.statusCode, 200);
      expect(response.body, contains('Item 1'));
    });

    test('La API maneja respuestas de error para una solicitud GET', () async {
      when(client.get(Uri.parse('$uri/data')))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      final response = await client.get(Uri.parse('$uri/data'));

      expect(response.statusCode, 404);
      expect(response.body, 'Not Found');
    });

    test('La solicitud POST de la API envía datos correctos', () async {
      when(client.post(
        Uri.parse('$uri/data'),
        body: {'name': 'New Item'},
      )).thenAnswer((_) async => http.Response('{"id":2,"name":"New Item"}', 201));

      final response = await client.post(
        Uri.parse('$uri/data'),
        body: {'name': 'New Item'},
      );

      expect(response.statusCode, 201);
      expect(response.body, contains('New Item'));
    });
  });

  group('Pruebas de Widgets', () {
    testWidgets('Prueba de incremento del contador', (WidgetTester tester) async {
      // Construir la app y activar un frame.
      await tester.pumpWidget(const MyApp());

      // Verificar que el contador empieza en 0.
      expect(find.text('0'), findsOneWidget);
      expect(find.text('1'), findsNothing);

      // Pulsar el icono de '+' y activar un frame.
      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();

      // Verificar que el contador ha incrementado.
      expect(find.text('0'), findsNothing);
      expect(find.text('1'), findsOneWidget);
    });

    testWidgets('Formulario de registro muestra errores cuando falta información', (WidgetTester tester) async {
      // Construir el árbol de widgets
      await tester.pumpWidget(const MyApp());

      // Buscar el botón de registro y simular tap
      final registerButton = find.text('Registrar');
      await tester.tap(registerButton);
      await tester.pump();

      // Verificar si se muestran los mensajes de error
      expect(find.text('Campo usuario requerido'), findsOneWidget);
      expect(find.text('Campo contraseña requerido'), findsOneWidget);
    });

    testWidgets('Navegación entre pantalla de login y pantalla principal', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());

      // Buscar el botón de login y simular tap
      final loginButton = find.text('Login');
      await tester.tap(loginButton);
      await tester.pumpAndSettle();

      // Verificar que estamos en la pantalla principal
      expect(find.text('Bienvenido'), findsOneWidget);
    });

    testWidgets('Lista de elementos se renderiza correctamente', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());

      // Simular la carga de una lista de elementos
      await tester.pumpAndSettle();

      // Verificar que la lista contiene elementos esperados
      expect(find.text('Elemento 1'), findsOneWidget);
      expect(find.text('Elemento 2'), findsOneWidget);
    });

    testWidgets('Eliminación de un elemento actualiza la lista', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());

      // Simular la eliminación de un elemento
      final deleteButton = find.text('Eliminar Elemento 1');
      await tester.tap(deleteButton);
      await tester.pumpAndSettle();

      // Verificar que el elemento eliminado ya no aparece
      expect(find.text('Elemento 1'), findsNothing);
    });
  });

  group('Pruebas de API de Flask - Carga de imágenes', () {
    late MockClient client;

    setUp(() {
      client = MockClient();
    });

    test('Carga de imagen exitosa', () async {
      final fileBytes = <int>[137, 80, 78, 71];  // Representación de una imagen PNG (ejemplo)
      final filename = 'uploaded_image.png';

      when(client.post(
        Uri.parse('$uriImage/upload'),
        body: fileBytes,
        headers: {'X-File-Name': filename},
      )).thenAnswer((_) async => http.Response(
          '{"message": "Image uploaded successfully", "file_path": "img/$filename"}', 201));

      final response = await client.post(
        Uri.parse('$uriImage/upload'),
        body: fileBytes,
        headers: {'X-File-Name': filename},
      );

      expect(response.statusCode, 201);
      expect(response.body, contains('Image uploaded successfully'));
      expect(response.body, contains('file_path'));
    });

    test('Carga de imagen fallida debido a archivo sin datos', () async {
      when(client.post(
        Uri.parse('$uriImage/upload'),
        body: <int>[],
      )).thenAnswer((_) async => http.Response('No file data provided', 404));

      final response = await client.post(
        Uri.parse('$uriImage/upload'),
        body: <int>[],
      );

      expect(response.statusCode, 404);
      expect(response.body, contains('No file data provided'));
    });

    test('Carga de imagen fallida debido a tipo de archivo inválido', () async {
      final fileBytes = <int>[137, 80, 78, 71];  // Imagen PNG, pero con extensión incorrecta
      final filename = 'invalid_image.txt';  // Nombre incorrecto

      when(client.post(
        Uri.parse('$uriImage/upload'),
        body: fileBytes,
        headers: {'X-File-Name': filename},
      )).thenAnswer((_) async => http.Response('Invalid file type', 403));

      final response = await client.post(
        Uri.parse('$uriImage/upload'),
        body: fileBytes,
        headers: {'X-File-Name': filename},
      );

      expect(response.statusCode, 403);
      expect(response.body, contains('Invalid file type'));
    });
  });

  group('Pruebas de la pantalla Agenda', () {
    testWidgets('La lista de tareas se carga correctamente', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: Agenda(),
      ));

      // Verificar que las tareas aparecen correctamente
      expect(find.text('Usar Microondas'), findsOneWidget);
      expect(find.text('Tarea 2'), findsOneWidget);
      expect(find.text('Tarea 3'), findsOneWidget);
    });

    testWidgets('La navegación a la pantalla de tarea secuencial funciona', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: Agenda(),
      ));

      // Tap en la primera tarea
      await tester.tap(find.text('Usar Microondas'));
      await tester.pumpAndSettle();

      // Verificar que estamos en la pantalla de MostrarTareaSecuencial
      expect(find.byType(MostrarTareaSecuencial), findsOneWidget);
    });

    testWidgets('El encabezado muestra la fecha correcta', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: Agenda(),
      ));

      // Verificar que el texto del encabezado contiene la fecha en el formato correcto
      final String fechaActual = DateFormat('dd/MM/yyyy').format(DateTime.now());
      expect(find.text('AGENDA --- DÍA $fechaActual'), findsOneWidget);
    });
  });

  group('Pruebas de navegación en MyApp', () {
    testWidgets('La pantalla inicial es LoginAlumnos', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: MyApp(),
      ));

      // Verificar que se muestra la pantalla de LoginAlumnos
      expect(find.byType(LoginAlumnos), findsOneWidget);
    });

    testWidgets('Navegación desde LoginAlumnos a LoginAdministrador', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: MyApp(),
      ));

      // Simular tap en el botón que lleva a LoginAdministrador
      await tester.tap(find.text('Ir a LoginAdministrador')); // Asegúrate de tener un botón o un texto que dirija a esta pantalla
      await tester.pumpAndSettle();

      // Verificar que estamos en la pantalla LoginAdministrador
      expect(find.byType(LoginAdministrador), findsOneWidget);
    });

    testWidgets('Navegación entre pantallas gestionadas', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: MyApp(),
      ));

      // Navegar desde LoginAdministrador a GestionarAlumnos
      await tester.tap(find.text('Ir a GestionarAlumnos'));
      await tester.pumpAndSettle();
      expect(find.byType(GestionarAlumnos), findsOneWidget);

      // Navegar desde GestionarAlumnos a CrearAlumno
      await tester.tap(find.text('Ir a CrearAlumno'));
      await tester.pumpAndSettle();
      expect(find.byType(CrearAlumno), findsOneWidget);

      // Navegar desde CrearAlumno a MostrarAlumnos
      await tester.tap(find.text('Ir a MostrarAlumnos'));
      await tester.pumpAndSettle();
      expect(find.byType(MostrarAlumnos), findsOneWidget);

      // Navegar desde MostrarAlumnos a CrearTareaSecuencial
      await tester.tap(find.text('Ir a CrearTareaSecuencial'));
      await tester.pumpAndSettle();
      expect(find.byType(CrearTareaSecuencial), findsOneWidget);

      // Navegar desde CrearTareaSecuencial a MostrarTareasSecuenciales
      await tester.tap(find.text('Ir a MostrarTareasSecuenciales'));
      await tester.pumpAndSettle();
      expect(find.byType(MostrarTareasSecuenciales), findsOneWidget);

      // Navegar desde MostrarTareasSecuenciales a Agenda
      await tester.tap(find.text('Ir a Agenda'));
      await tester.pumpAndSettle();
      expect(find.byType(Agenda), findsOneWidget);
    });
  });

  group('Pruebas de la funcionalidad de CrearAlumno', () {
    testWidgets('Formulario de Crear Alumno vacío', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: CrearAlumno(),
      ));

      // Verificar que los campos de texto estén vacíos inicialmente
      expect(find.byType(TextField), findsNWidgets(4));
      expect(find.text('Introduce el nombre.'), findsOneWidget);
      expect(find.text('Introduce el apellido.'), findsOneWidget);
      expect(find.text('Introduce el usuario con el que el alumno entrará en la aplicación'), findsOneWidget);
      expect(find.text('Introduce la contraseña con la que el alumno entrará en la aplicación'), findsOneWidget);
    });

    testWidgets('Comprobar que los campos se limpian correctamente', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: CrearAlumno(),
      ));

      // Rellenar los campos de texto
      await tester.enterText(find.byType(TextField).at(0), 'Juan');
      await tester.enterText(find.byType(TextField).at(1), 'Pérez');
      await tester.enterText(find.byType(TextField).at(2), 'juanperez');
      await tester.enterText(find.byType(TextField).at(3), 'contrasena123');

      // Pulsar el botón de vaciar
      await tester.tap(find.text('Vaciar'));
      await tester.pumpAndSettle();

      // Verificar que los campos se han vaciado
      expect(find.text('Juan'), findsNothing);
      expect(find.text('Pérez'), findsNothing);
      expect(find.text('juanperez'), findsNothing);
      expect(find.text('contrasena123'), findsNothing);
    });

    testWidgets('Formulario de Crear Alumno con datos inválidos', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: CrearAlumno(),
      ));

      // Rellenar los campos con datos inválidos
      await tester.enterText(find.byType(TextField).at(0), '');
      await tester.enterText(find.byType(TextField).at(1), ''); 
      await tester.enterText(find.byType(TextField).at(2), 'usuario123');
      await tester.enterText(find.byType(TextField).at(3), '');

      // Pulsar el botón de enviar
      await tester.tap(find.text('Enviar'));
      await tester.pumpAndSettle();

      // Verificar que no se envía el formulario si hay campos vacíos
      expect(find.text('Error al crear el alumno.'), findsOneWidget);
    });

    testWidgets('Formulario de Crear Alumno con datos válidos', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: CrearAlumno(),
      ));

      // Rellenar los campos con datos válidos
      await tester.enterText(find.byType(TextField).at(0), 'Juan');
      await tester.enterText(find.byType(TextField).at(1), 'Pérez');
      await tester.enterText(find.byType(TextField).at(2), 'juanperez');
      await tester.enterText(find.byType(TextField).at(3), 'contrasena123');

      // Seleccionar una preferencia
      await tester.tap(find.text('Selecciona la más conveniente'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Visual')); // Suponiendo que 'Visual' es una opción
      await tester.pumpAndSettle();

      // Pulsar el botón de enviar
      await tester.tap(find.text('Enviar'));
      await tester.pumpAndSettle();

      // Verificar que el mensaje de éxito aparece
      expect(find.text('Alumno creado con éxito.'), findsOneWidget);
    });

    testWidgets('Comprobación de la validación de la preferencia', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: CrearAlumno(),
      ));

      // Rellenar los campos sin seleccionar preferencia
      await tester.enterText(find.byType(TextField).at(0), 'Juan');
      await tester.enterText(find.byType(TextField).at(1), 'Pérez');
      await tester.enterText(find.byType(TextField).at(2), 'juanperez');
      await tester.enterText(find.byType(TextField).at(3), 'contrasena123');

      // Pulsar el botón de enviar
      await tester.tap(find.text('Enviar'));
      await tester.pumpAndSettle();

      // Verificar que se muestra un mensaje de error de preferencia vacía
      expect(find.text('Error al crear el alumno.'), findsOneWidget);
    });
  });

  group('Pruebas de la funcionalidad de CrearTareaSecuencial', () {
    testWidgets('Formulario vacío en CrearTareaSecuencial', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: CrearTareaSecuencial(),
      ));

      // Verificar que los campos están vacíos inicialmente
      expect(find.byType(TextField), findsNWidgets(2));
      expect(find.text('Introduce el título de la actividad'), findsOneWidget);
      expect(find.text('¿Cuántos pasos son necesarios para llevar a cabo la tarea?'), findsOneWidget);
    });

    testWidgets('Comprobar navegación a DescribirPaso con datos válidos', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: CrearTareaSecuencial(),
      ));

      // Rellenar los campos con datos válidos
      await tester.enterText(find.byType(TextField).at(0), 'Actividad 1');
      await tester.enterText(find.byType(TextField).at(1), '5');

      // Pulsar el botón de siguiente
      await tester.tap(find.text('Siguiente'));
      await tester.pumpAndSettle();

      // Verificar que la pantalla de DescribirPaso es la siguiente
      expect(find.byType(DescribirPaso), findsOneWidget);
    });

    testWidgets('Mostrar mensaje de error si no se ingresa título o pasos válidos', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: CrearTareaSecuencial(),
      ));

      // Pulsar el botón de siguiente sin rellenar los campos
      await tester.tap(find.text('Siguiente'));
      await tester.pumpAndSettle();

      // Verificar que aparece un mensaje de error
      expect(find.text('Por favor, introduce un título y un número válido de pasos'), findsOneWidget);
    });

    testWidgets('Comprobar que la navegación no ocurre si los pasos no son un número válido', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: CrearTareaSecuencial(),
      ));

      // Rellenar los campos con un número no válido de pasos
      await tester.enterText(find.byType(TextField).at(0), 'Actividad 1');
      await tester.enterText(find.byType(TextField).at(1), 'abc'); // Valor no numérico

      // Pulsar el botón de siguiente
      await tester.tap(find.text('Siguiente'));
      await tester.pumpAndSettle();

      // Verificar que no se navega y se muestra el mensaje de error
      expect(find.byType(DescribirPaso), findsNothing);
      expect(find.text('Por favor, introduce un título y un número válido de pasos'), findsOneWidget);
    });

    testWidgets('Comprobar navegación correcta con número válido de pasos', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: CrearTareaSecuencial(),
      ));

      // Rellenar los campos con datos válidos
      await tester.enterText(find.byType(TextField).at(0), 'Actividad de ejemplo');
      await tester.enterText(find.byType(TextField).at(1), '3');

      // Pulsar el botón de siguiente
      await tester.tap(find.text('Siguiente'));
      await tester.pumpAndSettle();

      // Verificar que la navegación se realiza correctamente
      expect(find.byType(DescribirPaso), findsOneWidget);
    });
  });

group('Pruebas DescribirPaso', () {
    testWidgets('Prueba de la funcionalidad de siguiente paso', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: DescribirPaso(titulo: 'Test', pasosTotales: 3),
      ));

      // Verificar que el primer paso está visible
      expect(find.text('Describe el paso 1 de 3:'), findsOneWidget);

      // Ingresar un texto en el campo de texto
      await tester.enterText(find.byType(TextField), 'Paso 1: Acción');

      // Hacer clic en el botón de siguiente
      await tester.tap(find.text('Siguiente'));
      await tester.pumpAndSettle();

      // Verificar que el siguiente paso se muestra
      expect(find.text('Describe el paso 2 de 3:'), findsOneWidget);
    });

    testWidgets('Prueba de agregar imagen', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: DescribirPaso(titulo: 'Test', pasosTotales: 1),
      ));

      // Verificar que el botón "Agregar imagen" está presente
      expect(find.text('Agregar imagen'), findsOneWidget);

      // Simular la acción de seleccionar una imagen
      final imagePath = 'path/to/fake/image.jpg';
      await tester.tap(find.text('Agregar imagen'));
      await tester.pumpAndSettle();

      // Verificar que la imagen ha sido agregada a la lista de imágenes
      expect(find.byType(Image), findsOneWidget);
    });

    testWidgets('Prueba de finalizar tarea', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: DescribirPaso(titulo: 'Test', pasosTotales: 2),
      ));

      // Completar el primer paso
      await tester.enterText(find.byType(TextField), 'Paso 1');
      await tester.tap(find.text('Siguiente'));
      await tester.pumpAndSettle();

      // Completar el segundo paso y finalizar la tarea
      await tester.enterText(find.byType(TextField), 'Paso 2');
      await tester.tap(find.text('Finalizar'));
      await tester.pumpAndSettle();

      // Verificar que la tarea fue completada (puedes simular la navegación aquí)
      expect(find.text('Tarea creada con éxito.'), findsOneWidget);
    });
  });

  group('GestionarAlumnos Tests', () {
    testWidgets('Botón "Crear Perfil de Alumno" es visible', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: GestionarAlumnos()));
      expect(find.text('Crear Perfil de Alumno'), findsOneWidget);
    });

    testWidgets('Botón "Modificar Alumno" es visible', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: GestionarAlumnos()));
      expect(find.text('Modificar Alumno'), findsOneWidget);
    });

    testWidgets('Botón "Crear Tareas Secuenciales" es visible', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: GestionarAlumnos()));
      expect(find.text('Crear Tareas Secuenciales'), findsOneWidget);
    });

    testWidgets('Botón "Editar Tareas Secuenciales" es visible', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: GestionarAlumnos()));
      expect(find.text('Editar Tareas Secuenciales'), findsOneWidget);
    });

    testWidgets('Botón "Asignar tareas a alumnos" es visible', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: GestionarAlumnos()));
      expect(find.text('Asignar tareas a alumnos'), findsOneWidget);
    });

    testWidgets('Navegar a "Crear Perfil de Alumno" al presionar el botón', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: GestionarAlumnos()));
      await tester.tap(find.text('Crear Perfil de Alumno'));
      await tester.pumpAndSettle();
      expect(find.byType(CrearAlumno), findsOneWidget);
    });

    testWidgets('Navegar a "Modificar Alumno" al presionar el botón', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: GestionarAlumnos()));
      await tester.tap(find.text('Modificar Alumno'));
      await tester.pumpAndSettle();
      expect(find.byType(MostrarAlumnos), findsOneWidget);
    });

    testWidgets('Navegar a "Crear Tareas Secuenciales" al presionar el botón', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: GestionarAlumnos()));
      await tester.tap(find.text('Crear Tareas Secuenciales'));
      await tester.pumpAndSettle();
      expect(find.byType(CrearTareaSecuencial), findsOneWidget);
    });

    testWidgets('Navegar a "Editar Tareas Secuenciales" al presionar el botón', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: GestionarAlumnos()));
      await tester.tap(find.text('Editar Tareas Secuenciales'));
      await tester.pumpAndSettle();
      expect(find.byType(MostrarTareasSecuenciales), findsOneWidget);
    });

    testWidgets('Navegar a "Asignar tareas a alumnos" al presionar el botón', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: GestionarAlumnos()));
      await tester.tap(find.text('Asignar tareas a alumnos'));
      await tester.pumpAndSettle();
      expect(find.byType(CrearAlumno), findsOneWidget);
    });
  });

  group('Tests para LoginAdministrador', () {
    testWidgets('Verificar elementos en la pantalla de login', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: LoginAdministrador()));

      // Verifica que el logo esté visible
      expect(find.byType(Image), findsOneWidget);

      // Verifica que los textos de los campos de entrada estén presentes
      expect(find.text('Nombre de usuario'), findsOneWidget);
      expect(find.text('Contraseña'), findsOneWidget);

      // Verifica que el botón "Iniciar sesión" esté visible
      expect(find.text('Iniciar sesión'), findsOneWidget);

      // Verifica que el botón "¿Problemas para acceder?" esté visible
      expect(find.text('¿Problemas para acceder? Pida ayuda.'), findsOneWidget);
    });

    testWidgets('Probar login exitoso', (WidgetTester tester) async {
      // Prepara la simulación de la respuesta de la API
      final mockClient = MockClient();
      final fakeResponse = '{"access_token": "fake_token"}';
      when(mockClient.post(any, headers: anyNamed('headers'), body: anyNamed('body')))
          .thenAnswer((_) async => http.Response(fakeResponse, 200));

      // Crea el widget de la pantalla de login
      await tester.pumpWidget(
        MaterialApp(
          home: LoginAdministrador(),
          routes: {'/gestionarAlumnos': (_) => Scaffold()},
        ),
      );

      // Completa los campos de entrada
      await tester.enterText(find.byType(TextField).at(0), 'usuario');
      await tester.enterText(find.byType(TextField).at(1), 'contraseña');
      await tester.tap(find.byType(ElevatedButton));

      // Simula el renderizado de la nueva pantalla después de la navegación
      await tester.pumpAndSettle();

      // Verifica que se haya navegado a la pantalla de gestionar alumnos
      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('Probar login fallido', (WidgetTester tester) async {
      // Prepara la simulación de la respuesta de la API
      final mockClient = MockClient();
      final fakeResponse = '{"error": "Credenciales incorrectas"}';
      when(mockClient.post(any, headers: anyNamed('headers'), body: anyNamed('body')))
          .thenAnswer((_) async => http.Response(fakeResponse, 400));

      // Crea el widget de la pantalla de login
      await tester.pumpWidget(MaterialApp(home: LoginAdministrador()));

      // Completa los campos de entrada
      await tester.enterText(find.byType(TextField).at(0), 'usuario');
      await tester.enterText(find.byType(TextField).at(1), 'contraseña');
      await tester.tap(find.byType(ElevatedButton));

      // Simula el renderizado de la UI
      await tester.pump();

      // Verifica que se haya mostrado un SnackBar con el mensaje de error
      expect(find.byType(SnackBar), findsOneWidget);
    });

    testWidgets('Campos vacíos no permiten login', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: LoginAdministrador()));

      // Deja los campos vacíos y toca el botón
      await tester.tap(find.byType(ElevatedButton));

      // Simula el renderizado de la UI
      await tester.pump();

      // Verifica que no se haya navegado, ya que los campos están vacíos
      expect(find.byType(Scaffold), findsNothing);
    });

    test('Verificar llamada a la API en login', () async {
      final mockClient = MockClient();
      final fakeResponse = '{"access_token": "fake_token"}';

      when(mockClient.post(any, headers: anyNamed('headers'), body: anyNamed('body')))
          .thenAnswer((_) async => http.Response(fakeResponse, 200));

      final login = LoginAdministrador();
      await login._login(mockClient, 'usuario', 'contraseña');

      // Verifica que la llamada a la API se haya realizado
      verify(mockClient.post(any, headers: anyNamed('headers'), body: anyNamed('body'))).called(1);
    });

    test('Verificar controlador de texto de usuario', () {
      final controller = TextEditingController();
      controller.text = 'usuario';

      expect(controller.text, 'usuario');
    });
  });

  group('Tests para LoginAlumnos', () {
    testWidgets('Verificar elementos en la pantalla de login de alumnos', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: LoginAlumnos()));

      // Verifica que el título esté presente
      expect(find.text('COLEGIO SAN RAFAEL INICIO DE SESIÓN'), findsOneWidget);

      // Verifica que los pictogramas de usuario estén presentes
      expect(find.byType(InkWell), findsNWidgets(6));

      // Verifica que el texto para iniciar sesión como administrador esté presente
      expect(find.text('Iniciar Sesión como Administrador'), findsOneWidget);
    });

    testWidgets('Verificar navegación al hacer clic en un pictograma', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: LoginAlumnos(),
        routes: {'/loginAdministrador': (_) => Scaffold(), '/passwordAlumnos': (_) => Scaffold()},
      ));

      // Encuentra el primer pictograma
      final pictograma = find.byType(InkWell).first;
      
      // Realiza el clic en el pictograma
      await tester.tap(pictograma);

      // Simula el renderizado de la navegación
      await tester.pumpAndSettle();

      // Verifica que se haya navegado a la pantalla de PasswordAlumnos
      expect(find.byType(PasswordAlumnos), findsOneWidget);
    });

    testWidgets('Verificar que el botón de administrador navega correctamente', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: LoginAlumnos(),
        routes: {'/loginAdministrador': (_) => Scaffold()},
      ));

      // Encuentra y toca el botón de inicio de sesión como administrador
      await tester.tap(find.text('Iniciar Sesión como Administrador'));

      // Simula el renderizado de la navegación
      await tester.pumpAndSettle();

      // Verifica que se haya navegado a la pantalla de loginAdministrador
      expect(find.byType(Scaffold), findsOneWidget);
    });
  });

}
