import 'package:flutter_game_flame/components/enemy.dart';
import 'package:flutter_game_flame/game_controller.dart';

class EnemySpawner {
  final GameController gameController;
  final maxSpawnInterval = 3000;
  final minSpawnInterval = 1000;

  final int intervalChange = 3;
  final int maxEnemies = 7;
  int currentInterval;
  int nextSpawn;

  EnemySpawner(this.gameController) {
    initialize();
  }

  void initialize() {
    killAllEnemies();
    currentInterval = maxSpawnInterval;
    nextSpawn = DateTime.now().millisecondsSinceEpoch + currentInterval;
  }

  void killAllEnemies() {
    gameController.enemies.forEach((Enemy enemy) => enemy.isDead = true);
  }

  void update(double t) {
    int now = DateTime.now().microsecondsSinceEpoch;
    if(gameController.enemies.length < maxEnemies && now >= nextSpawn) {
      gameController.spawnEnemy();
      if(currentInterval > minSpawnInterval) {
        currentInterval -= intervalChange;
        currentInterval -= (currentInterval * 0.1).toInt();
      }
      nextSpawn = now + currentInterval;
    }
  }
}
