import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:puzzle_sonrisa/modelo/current_user.dart';
import 'package:puzzle_sonrisa/modelo/uri.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  

  Future<void> _login(BuildContext context, String usuario, String password) async {
    final url = Uri.parse('$uri/login');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'usuario': usuario, 'password': password}),
      );
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        CurrentUser().token = responseData['access_token'];
        CurrentUser().rol = responseData['rol'];
        CurrentUser().id = responseData['_id'];

        if (CurrentUser().rol == 'Administrador') {
            Navigator.pushNamed(context, '/vistaAdministrador');
        } else if (CurrentUser().rol == 'Profesor') {
          Navigator.pushNamed(context, '/vistaProfesor');
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login fallido: Credenciales incorrectas.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error de red: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final usuarioController = TextEditingController();
    final passwordController = TextEditingController();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Image.asset(
                'assets/logo.png',
                width: 100,
                height: 100,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'COLEGIO SAN RAFAEL',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 50),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.5,

              child: TextField(
                controller: usuarioController,
                decoration: InputDecoration(
                  labelText: 'Nombre de usuario',
                  prefixIcon: const Icon(Icons.mail),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.5,
              child: TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Contraseña',
                  prefixIcon: const Icon(Icons.lock),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.5,
              child: ElevatedButton(
                onPressed: () {
                  _login(context, usuarioController.text, passwordController.text);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'Iniciar sesión',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
