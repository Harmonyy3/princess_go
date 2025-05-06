import 'package:flutter/material.dart';

class Mymap extends StatelessWidget {
  final double size;
  final String imagePath;

  const Mymap({super.key, required this.size, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: size,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
