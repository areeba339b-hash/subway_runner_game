import 'package:flame/game.dart';
import 'package:flutter_swipe_detector/flutter_swipe_detector.dart';
import 'package:flutter/material.dart';
import 'package:subway_runner_game/components/player.dart';
import 'package:subway_runner_game/components/obstacle.dart';
import 'package:subway_runner_game/components/coin.dart';
import 'package:subway_runner_game/components/background.dart'; // Import background
import 'package:shared_preferences/shared_preferences.dart';
import 'package:subway_runner_game/audio_manager.dart';
// For ValueNotifier
import 'dart:math';

enum PlayState {
  mainMenu,
  playing,
  gameOver,
}

class SubwayRunnerGame extends FlameGame {
  // This is the main game class.
  // All game components will be added here.
  late Player _player;
  int _score = 0;
  int _highScore = 0;
  late SharedPreferences _prefs;
  final AudioManager _audioManager = AudioManager();

  // Game state management
  final ValueNotifier<PlayState> playState = ValueNotifier(PlayState.mainMenu);

  // Expose score and high score for UI overlays
  int get score => _score;
  int get highScore => _highScore;

  // Define lane positions
  final List<double> lanePositions = [];
  final double laneWidth = 70.0; // Adjust based on your game's visual
  final int numberOfLanes = 3;

  // Obstacle and Coin generation
  double _spawnTimer = 0;
  final double _spawnInterval = 1.5; // Seconds between spawns
  final Random _random = Random();

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    // Load all the assets and components here
    final background = Background();
    add(background);
    _player = Player();
    add(_player);

    // Initialize SharedPreferences and AudioManager
    _prefs = await SharedPreferences.getInstance();
    _highScore = _prefs.getInt('highScore') ?? 0;
    await _audioManager.init();
    _audioManager.playBackgroundMusic('background_music.mp3');

    // Calculate lane positions
    final double gameWidth = size.x;
    final double startX = (gameWidth - (numberOfLanes * laneWidth)) / 2;
    for (int i = 0; i < numberOfLanes; i++) {
      lanePositions.add(startX + (i * laneWidth) + (laneWidth / 2));
    }

    // Set initial player position to the middle lane
    _player.x = lanePositions[numberOfLanes ~/ 2];

    // Pause the game initially for the main menu
    pauseEngine();
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (playState.value == PlayState.playing) {
      // Spawn logic for obstacles and coins
      _spawnTimer += dt;
      if (_spawnTimer >= _spawnInterval) {
        _spawnTimer = 0;
        _spawnRandomEntity();
      }

      // Collision detection
      children.whereType<Obstacle>().forEach((obstacle) {
        if (_player.toRect().overlaps(obstacle.toRect())) {
          // Game over logic here
          _audioManager.playSfx('game_over.mp3');
          print('Game Over! Hit an obstacle. Score: $_score, High Score: $_highScore');
          if (_score > _highScore) {
            _highScore = _score;
            _prefs.setInt('highScore', _highScore);
            print('New High Score: $_highScore');
          }
          playState.value = PlayState.gameOver;
          pauseEngine();
        }
      });

      children.whereType<Coin>().forEach((coin) {
        if (_player.toRect().overlaps(coin.toRect())) {
          _score++;
          _audioManager.playSfx('coin_collect.mp3');
          print('Score: $_score');
          coin.removeFromParent();
        }
      });
    }
  }

  void _spawnRandomEntity() {
    final randomLane = _random.nextInt(numberOfLanes);
    final spawnPositionX = lanePositions[randomLane];
    final spawnPositionY = -100.0; // Start above the screen

    // Randomly decide to spawn an obstacle or a coin
    if (_random.nextDouble() < 0.7) { // 70% chance for obstacle
      final randomObstacleType = ObstacleType.values[_random.nextInt(ObstacleType.values.length)];
      final obstacle = Obstacle(randomObstacleType);
      obstacle.x = spawnPositionX;
      obstacle.y = spawnPositionY;
      add(obstacle);
    } else { // 30% chance for coin
      final coin = Coin();
      coin.x = spawnPositionX;
      coin.y = spawnPositionY;
      add(coin);
    }
  }

  void onSwipe(SwipeDirection direction, Offset offset) {
    if (playState.value == PlayState.playing) {
      switch (direction) {
        case SwipeDirection.left:
          _player.moveLeft();
          break;
        case SwipeDirection.right:
          _player.moveRight();
          break;
        case SwipeDirection.up:
          _player.jump();
          break;
        case SwipeDirection.down:
          _player.slide();
          break;
      }
    }
  }

  void startGame() {
    playState.value = PlayState.playing;
    resumeEngine();
    _audioManager.playBackgroundMusic('background_music.mp3');
  }

  void resetGame() {
    // Reset score
    _score = 0;
    // Remove all existing obstacles and coins
    children.whereType<Obstacle>().forEach((obstacle) => obstacle.removeFromParent());
    children.whereType<Coin>().forEach((coin) => coin.removeFromParent());
    // Reset player position
    _player.x = lanePositions[numberOfLanes ~/ 2];
    _player.y = size.y - 100; // Reset to ground level
    _player.animation = _player.runAnimation; // Reset animation
    // Resume game engine
    playState.value = PlayState.playing;
    resumeEngine();
    _audioManager.playBackgroundMusic('background_music.mp3');
  }
}