import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final String image;

  const CustomButton({
    super.key,
    required this.onPressed,
    required this.text,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(50),
          child: CircleAvatar(
            radius: 40,
            backgroundImage: AssetImage(image),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
