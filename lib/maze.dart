import 'dart:math';

import 'package:flutter_a_star/cell.dart';
import 'package:flutter_a_star/enums.dart';

class Maze {
  Maze({required this.width, required this.height, required this.cellWidth}) {
    rows = (height / cellWidth).floor();
    columns = (width / cellWidth).floor();

    for (int i = 0; i < columns; i++) {
      grid.add(<Cell>[]);

      for (int j = 0; j < rows; j++) {
        grid[i].add(Cell(x: i, y: j, width: cellWidth));
      }
    }

    currentCell = grid[0][0];
    currentCell!.visited = true;
  }

  final double width;
  final double height;
  final double cellWidth;

  late final int columns;
  late final int rows;

  final List<List<Cell>> grid = <List<Cell>>[];
  final List<Cell> _stack = <Cell>[];

  Cell? currentCell;

  void checkNeighbors() {
    final List<Cell> neighbors = <Cell>[];

    _addNeigbor(currentCell!.x, currentCell!.y - 1, neighbors);
    _addNeigbor(currentCell!.x + 1, currentCell!.y, neighbors);
    _addNeigbor(currentCell!.x, currentCell!.y + 1, neighbors);
    _addNeigbor(currentCell!.x - 1, currentCell!.y, neighbors);

    if (neighbors.isNotEmpty) {
      final Direction direction =
          Direction.values[Random().nextInt(neighbors.length)];
      final Cell nextCell = neighbors[direction.index];

      _stack.add(currentCell!);
      _removeWalls(currentCell!, nextCell);

      currentCell = nextCell;
      currentCell!.visited = true;
    } else if (_stack.isNotEmpty) {
      currentCell = _stack.removeLast();
    } else {
      currentCell = null;
    }
  }

  bool _isOutsideOfGrid(int x, int y, int width, int height) =>
      x < 0 || x >= width || y < 0 || y >= height;

  void _addNeigbor(int x, int y, List<Cell> neighbors) {
    final bool topOutsideOfGrid = _isOutsideOfGrid(x, y, columns, rows);

    if (!topOutsideOfGrid) {
      final Cell cell = grid[x][y];

      if (!cell.visited) {
        neighbors.add(cell);
      }
    }
  }

  void _removeWalls(Cell currentCell, Cell nextCell) {
    final int x = currentCell.x - nextCell.x;
    final int y = currentCell.y - nextCell.y;

    if (x == 1) {
      currentCell.walls.remove(Direction.left);
      nextCell.walls.remove(Direction.right);
    } else if (x == -1) {
      currentCell.walls.remove(Direction.right);
      nextCell.walls.remove(Direction.left);
    }

    if (y == 1) {
      currentCell.walls.remove(Direction.top);
      nextCell.walls.remove(Direction.bottom);
    } else if (y == -1) {
      currentCell.walls.remove(Direction.bottom);
      nextCell.walls.remove(Direction.top);
    }
  }
}
