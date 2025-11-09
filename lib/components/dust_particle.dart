import 'package:flame/components.dart';
import 'package:flame/particles.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class DustParticle extends PositionComponent {
  DustParticle({
    required super.position,
    required super.size,
  }) {
    add(
      ParticleSystemComponent(
        particle: Particle.generate(
          count: 10,
          lifespan: 0.5,
          generator: (i) => AcceleratedParticle(
            position: Vector2.random() * size.x / 2,
            speed: Vector2(
                  (Random().nextDouble() - 0.5) * 100,
                  (Random().nextDouble() - 0.5) * 100,
                ) +
                Vector2(0, 50), // Move slightly downwards
            acceleration: Vector2(0, 200), // Accelerate downwards
            child: CircleParticle(
              radius: 2 + Random().nextDouble() * 3,
              paint: Paint()..color = Colors.grey.withOpacity(0.5),
            ),
          ),
        ),
      ),
    );
  }
}