import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:snak_game/pages/page_state.dart';

enum Direction { LEFT, RIGHT, UP, DOWN }
enum GameState { START, RUNNING, FAILURE }

class Game extends StatefulWidget {
  const Game({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _GameState();
}

class _GameState extends State<Game> {
  var snakePosition;
  late Point newPointPosition;
  late Timer timer;
  Direction _direction = Direction.UP;
  var gameState = GameState.START;
  int score = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Container(
          width: 320,
          height: 320,
          padding: const EdgeInsets.all(25),
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/snake_bg.png"),
              fit: BoxFit.fill,
            ),
          ),
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTapUp: (tapUpDetails) {
              _handleTap(tapUpDetails);
            },
            child: _getChildBasedOnGameState(),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                width: 100,
                height: 100,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(width: 1.0, color: Colors.blue),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Text(
                  "Score\n$score",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                    decoration: TextDecoration.none
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 50),
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _direction = Direction.UP;
                        });
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.green)
                      ),
                      child: const Icon(Icons.keyboard_arrow_up),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _direction = Direction.LEFT;
                          });
                        },
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(Colors.green)
                        ),
                        child: const Icon(Icons.keyboard_arrow_left),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 35),
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _direction = Direction.RIGHT;
                            });
                          },
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(Colors.green)
                          ),
                          child: const Icon(Icons.keyboard_arrow_right),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 50),
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _direction = Direction.DOWN;
                        });
                      },
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Colors.green)
                      ),
                      child: const Icon(Icons.keyboard_arrow_down),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _handleTap(TapUpDetails tapUpDetails) {
    switch (gameState) {
      case GameState.START:
        startToRunState();
        break;
      case GameState.RUNNING:
        break;
      case GameState.FAILURE:
        setGameState(GameState.START);
        break;
    }
  }

  void startToRunState() {
    startingSnake();
    generateNewPoint();
    _direction = Direction.UP;
    setGameState(GameState.RUNNING);
    timer = Timer.periodic(const Duration(milliseconds: 400), onTimeTick);
  }

  void startingSnake() {
    setState(() {
      const midPoint = (320 / 20 / 2);
      snakePosition = [
        Point(midPoint, midPoint - 1),
        Point(midPoint, midPoint),
        Point(midPoint, midPoint + 1),
      ];
    });
  }

  void generateNewPoint() {
    setState(() {
      Random rng = Random();
      var min = 0;
      var max = 320 ~/ 20;
      var nextX = min + rng.nextInt(max - min);
      var nextY = min + rng.nextInt(max - min);

      var newRedPoint = Point(nextX.toDouble(), nextY.toDouble());

      if (snakePosition.contains(newRedPoint)) {
        generateNewPoint();
      } else {
        newPointPosition = newRedPoint;
      }
    });
  }

  void setGameState(GameState _gameState) {
    setState(() {
      gameState = _gameState;
    });
  }

  Widget _getChildBasedOnGameState() {
    var child;
    switch (gameState) {
      case GameState.START:
        setState(() {
          score = 0;
        });
        child = gameStartChild;
        break;

      case GameState.RUNNING:
        List<Positioned> snakePiecesWithNewPoints = [];
        snakePosition.forEach(
              (i) {
            snakePiecesWithNewPoints.add(
              Positioned(
                child: gameRunningChild,
                left: i.x * 15.5,
                top: i.y * 15.5,
              ),
            );
          },
        );
        final latestPoint = Positioned(
          child: newSnakePointInGame,
          left: newPointPosition.x! * 15.5,
          top: newPointPosition.y! * 15.5,
        );
        snakePiecesWithNewPoints.add(latestPoint);
        child = Stack(children: snakePiecesWithNewPoints);
        break;

      case GameState.FAILURE:
        timer.cancel();
        child = Container(
          width: 320,
          height: 320,
          padding: const EdgeInsets.all(32),
          child: Center(
            child: Text(
              "You Scored: $score\nTap to play again!",
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.red,
                fontSize: 20.0,
                decoration: TextDecoration.none
              ),
            ),
          ),
        );
        break;
    }
    return child;
  }

  void onTimeTick(Timer timer) {
    setState(() {
      snakePosition.insert(0, getLatestSnake());
      snakePosition.removeLast();
    });

    var currentHeadPos = snakePosition.first;
    if (currentHeadPos.x < 0 ||
        currentHeadPos.y < 0 ||
        currentHeadPos.x > 320 / 20 ||
        currentHeadPos.y > 320 / 20) {
      setGameState(GameState.FAILURE);
      return;
    }

    if (snakePosition.first.x == newPointPosition.x &&
        snakePosition.first.y == newPointPosition.y) {
      generateNewPoint();
      setState(() {
        if (score <= 10) {
          score = score + 1;
        } else if (score > 10 && score <= 25) {
          score = score + 2;
        } else {
          score = score + 3;
        }
        snakePosition.insert(0, getLatestSnake());
      });
    }
  }

  Point getLatestSnake() {
    var newHeadPos;

    switch (_direction) {
      case Direction.LEFT:
        var currentHeadPos = snakePosition.first;
        newHeadPos = Point(currentHeadPos.x - 1, currentHeadPos.y);
        break;

      case Direction.RIGHT:
        var currentHeadPos = snakePosition.first;
        newHeadPos = Point(currentHeadPos.x + 1, currentHeadPos.y);
        break;

      case Direction.UP:
        var currentHeadPos = snakePosition.first;
        newHeadPos = Point(currentHeadPos.x, currentHeadPos.y - 1);
        break;

      case Direction.DOWN:
        var currentHeadPos = snakePosition.first;
        newHeadPos = Point(currentHeadPos.x, currentHeadPos.y + 1);
        break;
    }

    return newHeadPos;
  }
}