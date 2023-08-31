import 'dart:math';

import 'package:flutter_a_star/cell.dart';
import 'package:flutter_a_star/enums.dart';

class Maze {
  Maze({
    Cell? start,
    Cell? goal,
    required this.width,
    required this.height,
    required this.cellWidth,
  }) {
    reset(start, goal);
  }

  final double width;
  final double height;
  final double cellWidth;

  final List<List<Cell>> grid = <List<Cell>>[];
  final List<Cell> _stack = <Cell>[];

  final List<Cell> openSet = <Cell>[];
  final List<Cell> closedSet = <Cell>[];
  final List<Cell> path = <Cell>[];

  int _columns = 0;
  int _rows = 0;

  Cell? start;
  Cell? goal;

  bool mazeIsDone = false;
  bool goalFound = false;
  Cell? currentCell;

  void reset([Cell? start, Cell? goal]) {
    mazeIsDone = false;
    goalFound = false;

    grid.clear();
    _stack.clear();

    _rows = (height / cellWidth).floor();
    _columns = (width / cellWidth).floor();

    for (int i = 0; i < _columns; i++) {
      grid.add(<Cell>[]);

      for (int j = 0; j < _rows; j++) {
        grid[i].add(Cell(x: i, y: j, width: cellWidth));
      }
    }

    currentCell = grid[0][0];
    currentCell!.visited = true;

    openSet.clear();
    closedSet.clear();

    this.start = start ?? grid[0][0];
    this.goal = goal ?? grid[_columns - 1][_rows - 1];

    openSet.add(this.start!);
  }

  void checkNeighbors() {
    if (mazeIsDone) {
      return;
    }

    final List<Cell> neighbors = <Cell>[];

    neighbors.addAll(_getNeigbor(currentCell!.x, currentCell!.y - 1));
    neighbors.addAll(_getNeigbor(currentCell!.x + 1, currentCell!.y));
    neighbors.addAll(_getNeigbor(currentCell!.x, currentCell!.y + 1));
    neighbors.addAll(_getNeigbor(currentCell!.x - 1, currentCell!.y));

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
      mazeIsDone = true;
    }
  }

  void findPath() {
    if (openSet.isNotEmpty && !goalFound) {
      int lowestIndex = 0;

      for (int i = 0; i < openSet.length; i++) {
        if (openSet[i].f < openSet[lowestIndex].f) {
          lowestIndex = i;
        }
      }

      final Cell current = openSet[lowestIndex];

      if (current == goal) {
        goalFound = true;

        path.clear();
        path.add(current);

        return;
      }

      openSet.remove(current);
      closedSet.add(current);

      final List<Cell> neighbors = [];

      if (!current.walls.contains(Direction.top)) {
        neighbors.addAll(_getNeigbor(current.x, current.y - 1));
      }
      if (!current.walls.contains(Direction.right)) {
        neighbors.addAll(_getNeigbor(current.x + 1, current.y));
      }
      if (!current.walls.contains(Direction.bottom)) {
        neighbors.addAll(_getNeigbor(current.x, current.y + 1));
      }
      if (!current.walls.contains(Direction.left)) {
        neighbors.addAll(_getNeigbor(current.x - 1, current.y));
      }

      for (var neighbor in neighbors) {
        if (closedSet.contains(neighbor)) {
          continue;
        }

        final double tempG = current.g + 1;

        if (openSet.contains(neighbor)) {
          if (tempG < neighbor.g) {
            neighbor.g = tempG;
          }
        } else {
          neighbor.g = tempG;
          openSet.add(neighbor);
        }

        neighbor.h = _calculateHeuristic(neighbor, goal!);
        neighbor.f = neighbor.g + neighbor.h;
        neighbor.previous = current;
      }
    }
  }

  bool _isOutsideOfGrid(int x, int y, int width, int height) =>
      x < 0 || x >= width || y < 0 || y >= height;

  List<Cell> _getNeigbor(int x, int y) {
    final List<Cell> neighbors = <Cell>[];
    final bool topOutsideOfGrid = _isOutsideOfGrid(x, y, _columns, _rows);

    if (!topOutsideOfGrid) {
      final Cell cell = grid[x][y];

      if (!cell.visited) {
        neighbors.add(cell);
      }
    }

    return neighbors;
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

  double _calculateHeuristic(Cell current, Cell goal) =>
      sqrt(pow(current.x - goal.x, 2) + pow(current.y - goal.y, 2));

  void backtrackPath() {
    if (path.last.previous != null) {
      path.add(path.last.previous!);
    }
  }
}
