import 'package:flutter/material.dart';
import 'dart:async';
import 'homeScreen.dart';
import 'package:google_fonts/google_fonts.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  bool castle=false; //add a fade in for castle

  @override
  void initState() {
    super.initState();

    Timer(Duration(milliseconds: 180), () {
      setState(() {
        castle = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
      children: [
    Positioned.fill(
      child: Image.asset(
        'image/menu.png',
        fit: BoxFit.cover,
      ),
    ),
    AnimatedOpacity(
      opacity: castle ? 1.0 : 0.0,
      duration: Duration(seconds: 3),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Image.asset(
          'image/c.png',
          height: 300,
          fit: BoxFit.cover,
        ),
      ),
    ),
    Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Princess Run',
            style: GoogleFonts.fredoka(
              fontSize: 60,
              fontWeight: FontWeight.bold,
              color: const Color.fromARGB(255, 237, 156, 182),
            ),
          ),
          SizedBox(height: 30),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => Homescreen()),
              );
            },
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
              backgroundColor: const Color.fromARGB(255, 237, 156, 182),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: Text(
              'Start Game',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    ),
  ],
)
    );
  }
}
