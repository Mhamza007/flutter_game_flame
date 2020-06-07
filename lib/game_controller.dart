import 'dart:math';
import 'dart:ui';

import 'package:flame/flame.dart';
import 'package:flame/game/game.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_game_flame/components/enemy.dart';
import 'package:flutter_game_flame/components/health_bar.dart';
import 'package:flutter_game_flame/components/highscore_text.dart';
import 'package:flutter_game_flame/components/player.dart';
import 'package:flutter_game_flame/components/score_text.dart';
import 'package:flutter_game_flame/components/start_text.dart';
import 'package:flutter_game_flame/enemy_spawner.dart';
import 'package:flutter_game_flame/state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GameController extends Game {
  final SharedPreferences storage;
  Size screenSize;
  double tileSize;
  Player player;
  List<Enemy> enemies;
  EnemySpawner enemySpawner;
  HealthBar healthBar;
  ScoreText scoreText;
  HighscoreText highscoreText;
  StartText startText;
  int score;

  Random rand;

  State state;

  GameController(this.storage) {
    initialize();
  }

  void initialize() async {
    resize(await Flame.util.initialDimensions());
    state = State.menu;
    rand = Random();
    player = Player(this);
    enemies = List<Enemy>();
    enemySpawner = EnemySpawner(this);
    healthBar = HealthBar(this);
    score = 0;
    scoreText = ScoreText(this);
    highscoreText = HighscoreText(this);
    startText = StartText(this);
  }

  void render(Canvas c) {
    Rect background = Rect.fromLTWH(0, 0, screenSize.width, screenSize.height);
    Paint backgroundPaint = Paint()..color = Color(0xFFFAFAFA);
    c.drawRect(background, backgroundPaint);

    player.render(c);

    if (state == State.menu) {
      startText.render(c);
      highscoreText.render(c);
    } else if (state == State.playing) {
      enemies.forEach((Enemy enemy) => enemy.render(c));
      scoreText.render(c);
      healthBar.render(c);
    }
  }

  void update(double t) {
    if (state == State.menu) {
      startText.update(t);
      highscoreText.update(t);
    } else if (state == State.playing) {
      enemySpawner.update(t);
      enemies.forEach((Enemy enemy) => enemy.update(t));
      enemies.removeWhere((Enemy enemy) => enemy.isDead);
      player.update(t);
      scoreText.update(t);
      healthBar.upadte(t);
    }
  }

  void resize(Size size) {
    screenSize = size;
    tileSize = screenSize.width / 10;
  }

  void onTapDown(TapDownDetails d) {
    if (state == State.menu) {
      state = State.playing;
    } else if (state == State.playing) {
      enemies.forEach((Enemy enemy) {
        if (enemy.enemyRect.contains(d.globalPosition)) {
          enemy.onTapDown();
        }
      });
    }
  }

  void spawnEnemy() {
    double x, y;
    switch (rand.nextInt(4)) {
      case 0:
        // Top side
        x = rand.nextDouble() * screenSize.width;
        y = -tileSize * 2.5;
        break;
      case 1:
        // Right side
        x = screenSize.width + tileSize * 2.5;
        y = rand.nextDouble() * screenSize.height;
        break;
      case 2:
        // bottom side
        x = rand.nextDouble() * screenSize.width;
        y = screenSize.height + tileSize * 2.5;
        break;
      case 3:
        // Right side
        x = -tileSize * 2.5;
        y = rand.nextDouble() * screenSize.height;
        break;
    }
    enemies.add(Enemy(this, x, y));
  }
}
