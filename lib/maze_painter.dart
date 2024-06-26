import 'package:flutter/material.dart';

import 'package:flutter_maze_generator/maze_drawer.dart';

class MazePainter extends CustomPainter {
  const MazePainter(this.mazeDarwer);

  final MazeDrawer mazeDarwer;

  @override
  void paint(Canvas canvas, Size size) {
    mazeDarwer
      ..draw(canvas)
      ..drawPath(canvas);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
