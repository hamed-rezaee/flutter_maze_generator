import 'package:flutter/material.dart';
import 'package:flutter_a_star/cell.dart';
import 'package:flutter_a_star/enums.dart';
import 'package:flutter_a_star/maze.dart';

class MazePainter extends CustomPainter {
  MazePainter(this.maze);

  final Maze maze;

  @override
  void paint(Canvas canvas, Size size) {
    _drawGrid(canvas);
  }

  void _drawGrid(Canvas canvas) {
    final List<List<Cell>> grid = maze.grid;

    for (int i = 0; i < grid.first.length; i++) {
      for (int j = 0; j < grid.length; j++) {
        final Cell cell = grid[j][i];
        final double x = cell.x * cell.width;
        final double y = cell.y * cell.width;

        _drawCells(canvas, cell, x, y);
        _drawWalls(canvas, cell, x, y);
      }
    }
  }

  void _drawCells(Canvas canvas, Cell cell, double x, double y) {
    final Paint backgroundPaint = Paint()
      ..color = maze.currentCell == cell
          ? Colors.green
          : cell.visited
              ? Colors.purple
              : Colors.grey
      ..style = PaintingStyle.fill;

    canvas.drawRect(
      Rect.fromLTWH(x, y, cell.width + 0.5, cell.width + 0.5),
      backgroundPaint,
    );
  }

  void _drawWalls(Canvas canvas, Cell cell, double x, double y) {
    final Paint walllPaint = Paint()..color = Colors.white;

    if (cell.walls.contains(Direction.top)) {
      canvas.drawLine(
        Offset(x, y),
        Offset(x + cell.width, y),
        walllPaint,
      );
    }

    if (cell.walls.contains(Direction.right)) {
      canvas.drawLine(
        Offset(x + cell.width, y),
        Offset(x + cell.width, y + cell.width),
        walllPaint,
      );
    }

    if (cell.walls.contains(Direction.bottom)) {
      canvas.drawLine(
        Offset(x + cell.width, y + cell.width),
        Offset(x, y + cell.width),
        walllPaint,
      );
    }

    if (cell.walls.contains(Direction.left)) {
      canvas.drawLine(
        Offset(x, y + cell.width),
        Offset(x, y),
        walllPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
