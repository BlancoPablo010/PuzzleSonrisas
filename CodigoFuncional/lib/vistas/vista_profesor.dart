import 'package:flutter/material.dart';
import 'package:puzzle_sonrisa/widgets/boton.dart';

class VistaProfesor extends StatelessWidget {
  VistaProfesor({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomButton(
              image: 'assets/paginaAdministrador/profesor.png',
              text: 'Pedir Materiales',
              onPressed: () {
                Navigator.pushNamed(context, '/pedirMateriales');
            }),
          ],
        ),
      ),
    );
  }
}