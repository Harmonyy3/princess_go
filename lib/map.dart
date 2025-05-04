import 'package:flutter/material.dart';

class Mymap extends StatelessWidget {
  final double size;

  const Mymap({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: size,
      decoration: BoxDecoration(
        color: Colors.grey,
        border: Border.all(width: 5, color: Colors.green),
        borderRadius: BorderRadius.circular(15),
      ),
    );
  }
}
