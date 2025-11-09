import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:flutter_swipe_detector/flutter_swipe_detector.dart';
import 'package:subway_runner_game/subway_runner_game.dart';
import 'package:subway_runner_game/screens/main_menu.dart';
import 'package:subway_runner_game/screens/game_over_menu.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final game = SubwayRunnerGame();
    return MaterialApp(
      title: 'Subway Runner',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Scaffold(
        body: Stack(
          children: [
            SwipeDetector(
              onSwipe: (direction, offset) => game.onSwipe(direction, offset),
              child: GameWidget(game: game),
            ),
            // Main Menu Overlay
            ValueListenableBuilder(
              valueListenable: game.playState,
              builder: (context, value, child) {
                if (value == PlayState.mainMenu) {
                  return MainMenu(game: game);
                }
                return const SizedBox.shrink();
              },
            ),
            // Game Over Menu Overlay
            ValueListenableBuilder(
              valueListenable: game.playState,
              builder: (context, value, child) {
                if (value == PlayState.gameOver) {
                  return GameOverMenu(game: game);
                }
                return const SizedBox.shrink();
              },
            ),
            // In-game score counter
            ValueListenableBuilder(
              valueListenable: game.playState,
              builder: (context, value, child) {
                if (value == PlayState.playing) {
                  return Positioned(
                    top: 50,
                    right: 20,
                    child: Text(
                      'Score: ${game.score}',
                      style: const TextStyle(fontSize: 24, color: Colors.white),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }
}
