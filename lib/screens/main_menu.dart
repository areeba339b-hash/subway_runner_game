import 'package:flutter/material.dart';
import 'package:subway_runner_game/subway_runner_game.dart';

class MainMenu extends StatelessWidget {
  final SubwayRunnerGame game;

  const MainMenu({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Subway Runner',
            style: TextStyle(fontSize: 48, color: Colors.white),
          ),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: () {
              game.startGame();
            },
            child: const Text('Play'),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // TODO: Implement settings screen
              print('Settings button pressed');
            },
            child: const Text('Settings'),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Exit the app
              // TODO: Implement proper exit logic for different platforms
              print('Exit button pressed');
            },
            child: const Text('Exit'),
          ),
        ],
      ),
    );
  }
}