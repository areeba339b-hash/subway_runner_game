import 'package:flame/components.dart';
import 'package:subway_runner_game/subway_runner_game.dart';

class Coin extends SpriteComponent with HasGameRef<SubwayRunnerGame> {
  final double _coinSpeed = 150; // Speed at which coins move towards the player

  Coin() : super(size: Vector2(32, 32), anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    sprite = await gameRef.loadSprite('coin.png'); // Placeholder image
  }

  @override
  void update(double dt) {
    super.update(dt);
    y += _coinSpeed * dt; // Move coin towards the player

    // Remove coin when it goes off-screen
    if (y > gameRef.size.y + size.y) {
      removeFromParent();
    }
  }
}