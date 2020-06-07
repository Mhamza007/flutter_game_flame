import 'package:flutter/material.dart';
import 'package:flutter_game_flame/game_controller.dart';

class StartText {
  final GameController gameController;
  TextPainter painter;
  Offset position;

  StartText(this.gameController) {
    painter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    position = Offset.zero;
  }

  void render(Canvas c) {
    painter.paint(c, position);
  }

  void update(double t) {
    painter.text = TextSpan(
      text: 'START GAME',
      style: TextStyle(
        color: Colors.black,
        fontSize: 50.0,
      ),
    );
    painter.layout();
    position = Offset(
      (gameController.screenSize.width / 2) - (painter.width / 2),
      (gameController.screenSize.height * 0.8) - (painter.height / 2),
    );
  }
}
