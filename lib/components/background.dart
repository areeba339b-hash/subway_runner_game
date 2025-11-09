import 'package:flame/components.dart';
import 'package:flame/parallax.dart';
import 'package:subway_runner_game/subway_runner_game.dart';

class Background extends ParallaxComponent<SubwayRunnerGame> with HasGameRef<SubwayRunnerGame> {
  Background() : super(priority: -1); // Render behind other components

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    parallax = await gameRef.loadParallax(
      [
        ParallaxImageData('background/layer_0.png'), // Furthest back
        ParallaxImageData('background/layer_1.png'),
        ParallaxImageData('background/layer_2.png'), // Closest to player
      ],
      baseVelocity: Vector2(0, -50), // Move upwards
      velocityMultiplierDelta: Vector2(0, 1.2),
    );
  }

}