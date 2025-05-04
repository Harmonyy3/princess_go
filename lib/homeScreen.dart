import 'package:flutter/material.dart';
import 'package:flutter_application_1/map.dart';
import 'package:flutter_application_1/role.dart';
import 'dart:async';

class Homescreen extends StatefulWidget{
  @override
  _HomescreenState createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen>{
  static double movement = -1;
  double time=0;
  double height=0;
  double h0=movement;
  bool flag=false;
  static double mapx1=1;
  double mapx2=mapx1 + 1.5;


  void jump(){
    setState(() {
      time=0;
      h0=movement;
      
    });
  }

  void Gameon(){
      flag=true;
      Timer.periodic(Duration(milliseconds: 50), (timer){
      time+=0.05;
      height=-4.9 * time * time + 2.5 * time;
      setState(() {
        movement=h0-height;
    });
    setState(() {
      if (mapx1<-3){
       mapx1+=2;
    }
    else{
       mapx1-=0.05;
    }
      
    });
    setState(() {
      if (mapx2<-3){
       mapx2+=3.5;
    }
    else{
       mapx2-=0.05;
    }
      
    });
    if (movement>1){
      timer.cancel(); // to stay in origiinal spot
      flag=false;
    }
  });
  }
  @override
  Widget build (BuildContext context){
    return GestureDetector(
        onTap: (){
                if (flag){
                  jump();
                }else{
                  Gameon();
                }
              },
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              flex: 2,
              child: Stack(
                children: [
                  Positioned.fill(
                    child:Image.asset('image/back.png',
                    fit:BoxFit.cover,
                  ),
                  ),
                  AnimatedContainer(
                    alignment: Alignment(0, movement), //middle
                    duration: Duration(milliseconds: 1),
                    //color: Colors.white,
                    child:role(),
                    ),
              Container(
                alignment: Alignment(0, -0.3),
                child:flag?Text(" ") : Text("Tap To Play", style: TextStyle(fontSize: 20, color:Colors.white)),
              ),
              AnimatedContainer(
                alignment: Alignment(mapx1, 1.1),
                duration: Duration(milliseconds: 0),
                child: Mymap(
                  size:200.0,
                ),
              ),
              AnimatedContainer(
                alignment: Alignment(mapx2, -1.1),
                duration: Duration(milliseconds: 0),
                child: Mymap(
                  size:200.0,
                ),
              ),
              AnimatedContainer(
                alignment: Alignment(1, 1.1),
                duration: Duration(milliseconds: 0),
                child: Mymap(
                  size:100.0,
                ),
              ),
              AnimatedContainer(
                alignment: Alignment(1, -1.1),
                duration: Duration(milliseconds: 0),
                child: Mymap(
                  size:250.0,
                ),
              ),
                ],
              )
            ),
          ],
        ),
      ),
    );
  }
}