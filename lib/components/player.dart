import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:subway_runner_game/subway_runner_game.dart';
import 'package:subway_runner_game/components/dust_particle.dart';

enum PlayerState {
  running,
  jumping,
  sliding,
  // Add other states like 'hit', 'dead' later
}

class Player extends SpriteAnimationComponent with HasGameRef<SubwayRunnerGame> {
  Player() : super(size: Vector2(64, 64), anchor: Anchor.center);

  late SpriteAnimation _runAnimation;
  late SpriteAnimation _jumpAnimation;
  late SpriteAnimation _slideAnimation;

  final double _animationSpeed = 0.15;
  final double _jumpForce = 200;
  final double _gravity = 500;
  final double _laneChangeSpeed = 200; // Speed of horizontal lane change

  final Vector2 _velocity = Vector2.zero();
  PlayerState _playerState = PlayerState.running;
  int _currentLane = 1; // 0 for left, 1 for middle, 2 for right

  // Expose runAnimation for game reset
  SpriteAnimation get runAnimation => _runAnimation;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Load player sprites
    final spriteSheet = SpriteSheet(
      image: await gameRef.images.load('player_sheet.png'), // Placeholder image
      srcSize: Vector2(32, 32),
    );

    _runAnimation = spriteSheet.createAnimation(row: 0, stepTime: _animationSpeed, from: 0, to: 4);
    _jumpAnimation = spriteSheet.createAnimation(row: 1, stepTime: _animationSpeed, from: 0, to: 0); // Single frame for jump
    _slideAnimation = spriteSheet.createAnimation(row: 2, stepTime: _animationSpeed, from: 0, to: 0); // Single frame for slide

    animation = _runAnimation;
    // Initial position will be set by the game class based on lane positions
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Apply gravity if jumping
    if (_playerState == PlayerState.jumping) {
      _velocity.y += _gravity * dt;
    }

    position += _velocity * dt;

    // Ground collision
    if (position.y >= gameRef.size.y - 100) {
      position.y = gameRef.size.y - 100;
      if (_playerState == PlayerState.jumping) {
        _playerState = PlayerState.running;
        _velocity.y = 0;
        animation = _runAnimation;
      }
    }

    // Smoothly move to the target lane position
    final targetX = gameRef.lanePositions[_currentLane];
    if ((targetX - position.x).abs() > _laneChangeSpeed * dt) {
      if (targetX > position.x) {
        position.x += _laneChangeSpeed * dt;
      } else {
        position.x -= _laneChangeSpeed * dt;
      }
    } else {
      position.x = targetX;
    }
  }

  void jump() {
    if (_playerState == PlayerState.running) {
      _playerState = PlayerState.jumping;
      _velocity.y = -_jumpForce;
      animation = _jumpAnimation;
    }
  }

  void slide() {
    if (_playerState == PlayerState.running) {
      _playerState = PlayerState.sliding;
      animation = _slideAnimation;
      gameRef.add(DustParticle(position: position, size: size)); // Add dust particles
      // Implement a timer to revert to run animation after a short duration
      Future.delayed(const Duration(milliseconds: 500), () {
        _playerState = PlayerState.running;
        animation = _runAnimation;
      });
    }
  }

  void moveLeft() {
    if (_currentLane > 0) {
      _currentLane--;
    }
  }

  void moveRight() {
    if (_currentLane < gameRef.numberOfLanes - 1) {
      _currentLane++;
    }
  }
}