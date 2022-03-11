import 'package:flutter/material.dart';
import 'package:snak_game/pages/game.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Snake Game',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Game(),
    );
  }
}