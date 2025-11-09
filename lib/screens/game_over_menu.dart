import 'package:flutter/material.dart';
import 'package:subway_runner_game/subway_runner_game.dart';

class GameOverMenu extends StatelessWidget {
  final SubwayRunnerGame game;

  const GameOverMenu({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Game Over',
            style: TextStyle(fontSize: 48, color: Colors.white),
          ),
          const SizedBox(height: 20),
          Text(
            'Score: ${game.score}',
            style: const TextStyle(fontSize: 24, color: Colors.white),
          ),
          Text(
            'High Score: ${game.highScore}',
            style: const TextStyle(fontSize: 24, color: Colors.white),
          ),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: () {
              game.resetGame(); // Implement resetGame in SubwayRunnerGame
              game.resumeEngine();
              // TODO: Remove game over menu and start new game
            },
            child: const Text('Restart'),
          ),
        ],
      ),
    );
  }
}