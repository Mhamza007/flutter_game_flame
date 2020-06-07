import 'dart:ui';

import 'package:flutter_game_flame/game_controller.dart';

class Enemy {
  final GameController gameController;
  int health;
  int demage;
  double speed;
  Rect enemyRect;
  bool isDead = false;

  Enemy(this.gameController, double x, double y) {
    health = 3;
    demage = 1;
    speed = gameController.tileSize * 2;
    enemyRect = Rect.fromLTWH(
      x,
      y,
      gameController.tileSize * 1.2,
      gameController.tileSize * 1.2,
    );
  }

  void render(Canvas c) {
    Color color;
    switch (health) {
      case 1:
        color = Color(0xFFFF7F7F);
        break;
      case 2:
        color = Color(0xFFFF4C4C);
        break;
      case 3:
        color = Color(0xFFFF4500);
        break;
      default:
        color = Color(0xFFFF0000);
        break;
    }
    Paint enemyColors = Paint()..color = color;
    c.drawRect(enemyRect, enemyColors);
  }

  void update(double t) {
    if(!isDead) {
      double stepDistance = speed * t;
      Offset toPlayer = gameController.player.playerRect.center - enemyRect.center;
      if(stepDistance <= toPlayer.distance - gameController.tileSize * 1.25 ) {
        Offset stepToPlayer = Offset.fromDirection(toPlayer.direction, stepDistance);
        enemyRect = enemyRect.shift(stepToPlayer);
      } else {
        attack();
      }
    }
  }

  void attack() {
    if(!gameController.player.isDead) {
      gameController.player.currentHealth -= demage;
    }
  }

  void onTapDown() {
    if(!isDead) {
      health--;
      if(health <= 0) {
        isDead = true;
        //score
        gameController.score++;
        print(gameController.score);
        if(gameController.score > (gameController.storage.getInt('highscore') ?? 0)) {
          gameController.storage.setInt('highscore', gameController.score);
        } 
      }
    }
  }
}
