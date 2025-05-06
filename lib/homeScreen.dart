import 'package:flutter/material.dart';
import 'dart:async';
import 'map.dart'; 
import 'role.dart'; 
import 'intro.dart';


class Homescreen extends StatefulWidget {
  @override
  _HomescreenState createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {


  double movement = 0;
  double time = 0;
  double height = 0; 
  double h0 = 0;
  bool flag = false;
  bool isGameOver = false;
  double mapx1 = 1;   
  double mapx2 = 2.5; 
  static const double roleWidth = 60.0;
  static const double roleHeight = 60.0;
  static const double obstacle1Height = 250.0;
  static const double obstacle2Height = 150.0;
  static const double obstacleWidth = 80.0;
  double gameAreaWidth = 0;
  double gameAreaHeight = 0;
  Timer? gameTimer; 
  int score = 0;
  Set<double> passedObstacles = {};
  bool hasScoredForObstacle1ThisPass = false;
  bool hasScoredForObstacle2ThisPass = false;
  static const double scoringLineX = 0.0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    gameTimer?.cancel(); 
    super.dispose();
  }

  //collision detection
  Rect _getPlayerRect(double currentMovement) {
    if (gameAreaWidth == 0 || gameAreaHeight == 0) return Rect.zero;
    double playerCenterX = gameAreaWidth / 2;
    double playerCenterY = (currentMovement + 1) / 2 * gameAreaHeight;

    return Rect.fromCenter(
      center: Offset(playerCenterX, playerCenterY),
      width: roleWidth,
      height: roleHeight,
    );
  }

  Rect _getObstacleRect(double mapX, double obsYAlignment, double obsHeight) {
    if (gameAreaWidth == 0 || gameAreaHeight == 0) return Rect.zero;
    double obstacleCenterX = (mapX + 1) / 2 * gameAreaWidth;
    double obstacleCenterY = (obsYAlignment + 1) / 2 * gameAreaHeight;

    return Rect.fromCenter(
      center: Offset(obstacleCenterX, obstacleCenterY),
      width: obstacleWidth,
      height: obsHeight,
    );
  }

  void jump() {
    if (isGameOver || !flag) return; 
    setState(() {
      time = 0;
      h0 = movement; 
    });
  }

  void gameOn() { 
    if (isGameOver || flag) return; 

    resetGame(); 
    flag = true;

    gameTimer = Timer.periodic(Duration(milliseconds: 50), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      time += 0.05;
      height = -4.9 * time * time + 2.5 * time; 

      double currentMapX1 = mapx1;
      double currentMapX2 = mapx2;

      double nextMovement = h0 - height;
      double nextMapX1 = mapx1 - 0.05;
      double nextMapX2 = mapx2 - 0.05;

      if (nextMapX1 < -2.0) 
      {
        nextMapX1 += 3.5;
        hasScoredForObstacle1ThisPass = false;
      }
      if (nextMapX2 < -2.0) 
      {
        nextMapX2 += 3.5;
        hasScoredForObstacle2ThisPass = false;
      }

      if (!hasScoredForObstacle1ThisPass && nextMapX1 < scoringLineX && currentMapX1 >= scoringLineX) {
        score += 10;
        hasScoredForObstacle1ThisPass = true;
      }
      if (!hasScoredForObstacle2ThisPass && nextMapX2 < scoringLineX && currentMapX2 >= scoringLineX) {
        score += 10;
        hasScoredForObstacle2ThisPass = true;
      }

      if (gameAreaWidth > 0 && gameAreaHeight > 0) {
        Rect playerRect = _getPlayerRect(nextMovement);
        Rect obstacle1Rect = _getObstacleRect(nextMapX1, 1.1, obstacle1Height);
        Rect obstacle2Rect = _getObstacleRect(nextMapX2, -1.1, obstacle2Height);

        if (playerRect.overlaps(obstacle1Rect) || playerRect.overlaps(obstacle2Rect)) {
          if (mounted) {
            setState(() {
              isGameOver = true;
              flag = false;
            });
            timer.cancel();
          }
          return;
        }
      }

      setState(() {
        movement = nextMovement;
        mapx1 = nextMapX1;
        mapx2 = nextMapX2;

       if (movement > 1.0) {
          movement = 1.0; 
          isGameOver = true;
          flag = false;
          timer.cancel();
        }
      });
    });
  }

  void resetGame() {
    setState(() {
      movement = 0; 
      time = 0;
      height = 0;
      h0 = 0;
      flag = false; 
      isGameOver = false;
      mapx1 = 1;
      mapx2 = 2.5; 
      score = 0;
      passedObstacles.clear();
      hasScoredForObstacle1ThisPass = false;
      hasScoredForObstacle2ThisPass = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (isGameOver) {
          resetGame();
          gameOn();
        } else if (flag) {
          jump();
        } else {
          gameOn();
        }
      },
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              flex: 2,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  if (gameAreaWidth != constraints.maxWidth || gameAreaHeight != constraints.maxHeight) {
                    Future.microtask(() {
                      if (mounted) {
                        setState(() {
                          gameAreaWidth = constraints.maxWidth;
                          gameAreaHeight = constraints.maxHeight;
                        });
                      }
                    });
                  }
                  if (gameAreaWidth == 0) gameAreaWidth = constraints.maxWidth;
                  if (gameAreaHeight == 0) gameAreaHeight = constraints.maxHeight;

                  return Stack(
                    children: [
                      Positioned.fill(
                        child: Image.asset(
                          'image/back.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: 20,
                        left: 20,
                        child: Text(
                          'Score: $score',
                          style: TextStyle(
                            fontSize: 24,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 20,
                        right: 20,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: (context) => IntroScreen()),
                            );
                          },      
                          child: Text(
                            'Exit',
                            style: TextStyle(
                              decorationColor: Colors.grey,
                              color: const Color.fromARGB(255, 53, 52, 52),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      
                      AnimatedContainer(
                        alignment: Alignment(0, movement),
                        duration: Duration(milliseconds: 0),
                        child: role(),
                      ),
                      Container(
                        alignment: Alignment(0, -0.8),
                        child: isGameOver
                            ? Text(
                                "Game Over! Tap to restart",
                                style: TextStyle(fontSize: 20, color: Colors.white),
                              )
                            : flag
                                ? SizedBox.shrink()
                                : Text(
                                    "Start! Tap To Play",
                                    style: TextStyle(fontSize: 20, color: Colors.white),
                                  ),
                      ),
                      AnimatedContainer(
                        alignment: Alignment(mapx1, 1.1),
                        duration: Duration(milliseconds: 0),
                        child: Mymap(size: obstacle1Height, imagePath: 'image/o2.png'),
                      ),
                      AnimatedContainer(
                        alignment: Alignment(mapx2, -1.1),
                        duration: Duration(milliseconds: 0),
                        child: Mymap(size: obstacle2Height, imagePath: 'image/o1.png'),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}