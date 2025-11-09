import 'package:flame/components.dart';
import 'package:subway_runner_game/subway_runner_game.dart';

enum ObstacleType {
  train,
  barrier,
  cone,
}

class Obstacle extends SpriteComponent with HasGameRef<SubwayRunnerGame> {
  final ObstacleType type;
  final double _obstacleSpeed = 150; // Speed at which obstacles move towards the player

  Obstacle(this.type) : super(size: Vector2(64, 64), anchor: Anchor.bottomCenter);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    // Load different sprites based on obstacle type
    String imagePath;
    switch (type) {
      case ObstacleType.train:
        imagePath = 'train.png'; // Placeholder
        size = Vector2(128, 128); // Example size for a train
        break;
      case ObstacleType.barrier:
        imagePath = 'barrier.png'; // Placeholder
        size = Vector2(96, 64); // Example size for a barrier
        break;
      case ObstacleType.cone:
        imagePath = 'cone.png'; // Placeholder
        size = Vector2(32, 32); // Example size for a cone
        break;
    }
    sprite = await gameRef.loadSprite(imagePath);
  }

  @override
  void update(double dt) {
    super.update(dt);
    y += _obstacleSpeed * dt; // Move obstacle towards the player

    // Remove obstacle when it goes off-screen
    if (y > gameRef.size.y + size.y) {
      removeFromParent();
    }
  }
}