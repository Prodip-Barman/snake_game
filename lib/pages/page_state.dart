import 'package:flutter/material.dart';

final Widget gameStartChild = Container(
  width: 320,
  height: 320,
  padding: const EdgeInsets.all(32),
  child: const Center(
    child: Text(
      "Tap to start the Game!\nDo not Touch Walls:)",
      textAlign: TextAlign.center,
      style: TextStyle(
          color: Colors.blue,
        fontSize: 20.0,
        decoration: TextDecoration.none
      ),
    ),
  ),
);

final Widget gameRunningChild = Container(
  width: 15.5,
  height: 15.5,
  decoration: const BoxDecoration(
    color: Color(0xFFFF0000),
    shape: BoxShape.rectangle,
  ),
);

final Widget newSnakePointInGame = Container(
  width: 15.5,
  height: 15.5,
  decoration: BoxDecoration(
    color: const Color(0xFF0080FF),
    border: Border.all(color: Colors.white),
    borderRadius: BorderRadius.circular(20),
  ),
);

//class which gives the snake HEAD
class Point {
  double? x;
  double? y;

  Point(this.x, this.y);
}