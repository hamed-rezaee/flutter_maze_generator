import 'package:flutter/material.dart';
import 'package:flutter_maze_generator/cell.dart';
import 'package:flutter_maze_generator/enums.dart';
import 'package:flutter_maze_generator/maze_generator.dart';

class MazeDrawer {
  const MazeDrawer(this.maze);

  final MazeGenerator maze;

  void draw(Canvas canvas) {
    final grid = maze.grid;

    for (var i = 0; i < grid.first.length; i++) {
      for (var j = 0; j < grid.length; j++) {
        final cell = grid[j][i];
        final x = cell.position.x * cell.width;
        final y = cell.position.y * cell.width;

        _drawCells(canvas, cell, x, y);
        _drawWalls(canvas, cell, x, y);
      }
    }
  }

  void drawPath(Canvas canvas) {
    final path = maze.grid
        .expand((List<Cell> cells) => cells)
        .where((Cell cell) => cell.path)
        .toList();

    for (final cell in path) {
      final paint = Paint()
        ..color = Colors.red
        ..strokeCap = StrokeCap.round
        ..strokeWidth = cell.width / 3;

      final offset = cell.offset;

      if (cell.previous != null) {
        final previousOffset = cell.previous!.offset;

        canvas.drawLine(offset, previousOffset, paint);
      }
    }
  }

  void _drawCells(Canvas canvas, Cell cell, double x, double y) {
    final backgroundPaint = Paint()
      ..color = maze.currentCell == cell
          ? Colors.green
          : cell.visited
              ? Colors.black
              : Colors.grey
      ..style = PaintingStyle.fill;

    canvas.drawRect(
      Rect.fromLTWH(x, y, cell.width + 0.5, cell.width + 0.5),
      backgroundPaint,
    );

    if (maze.start == cell.position || maze.goal == cell.position) {
      canvas.drawCircle(
        Offset(x + cell.width / 2, y + cell.width / 2),
        cell.width / 3,
        Paint()..color = Colors.orange,
      );
    }
  }

  void _drawWalls(Canvas canvas, Cell cell, double x, double y) {
    final walllPaint = Paint()..color = Colors.white;

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
}
