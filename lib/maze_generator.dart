import 'dart:math';

import 'package:flutter_maze_generator/cell.dart';
import 'package:flutter_maze_generator/enums.dart';
import 'package:flutter_maze_generator/position.dart';

class MazeGenerator {
  MazeGenerator({
    required this.width,
    required this.height,
    required this.cellWidth,
    required this.start,
    required this.goal,
  }) {
    _initializeGrid();

    currentCell = grid[0][0]..visited = true;
  }

  final double width;
  final double height;
  final double cellWidth;
  final Position start;
  final Position goal;

  final List<List<Cell>> grid = <List<Cell>>[];
  final List<Cell> _stack = <Cell>[];

  Cell? currentCell;

  bool _mazeIsDone = false;

  int get rowsCount => (height / cellWidth).floor();
  int get columnsCount => (width / cellWidth).floor();

  Stream<MazeGenerator> generateDepthFirst({
    bool solve = true,
    Duration duration = const Duration(milliseconds: 5),
  }) async* {
    while (!_mazeIsDone) {
      final neighbors = _getNeigbor(
        currentCell!.position,
        checkWalls: false,
      );

      if (neighbors.isNotEmpty) {
        final direction = Direction.values[Random().nextInt(neighbors.length)];
        final nextCell = neighbors[direction.index];

        _stack.add(currentCell!);
        _removeWalls(currentCell!, nextCell);

        currentCell = nextCell;
        currentCell!.visited = true;
      } else if (_stack.isNotEmpty) {
        currentCell = _stack.removeLast();
      } else {
        currentCell = null;

        _mazeIsDone = true;
      }

      await Future<void>.delayed(duration);
      yield this;
    }

    if (solve) {
      for (final cell in _findPath()) {
        cell.path = true;

        await Future<void>.delayed(duration * 5);
        yield this;
      }
    }
  }

  Iterable<Cell> _findPath() {
    final result = <Cell>[];

    for (final row in grid) {
      for (final cell in row) {
        cell
          ..f = 0
          ..g = 0
          ..h = 0
          ..visited = false
          ..previous = null;
      }
    }

    final openSet = <Cell>[grid[start.x][start.y]];

    while (openSet.isNotEmpty) {
      var current = openSet.first;

      for (final cell in openSet) {
        if (cell.f < current.f) {
          current = cell;
        }
      }

      if (current.position == goal) {
        result.addAll(_reconstructPath());
      }

      openSet.remove(current..visited = true);

      final neighbors = _getNeigbor(current.position, checkWalls: true);

      for (final neighbor in neighbors) {
        neighbor.previous = current;
        neighbor.g++;
        neighbor
          ..h = _getDistance(neighbor.position, goal)
          ..f = neighbor.g + neighbor.h;

        if (!openSet.contains(neighbor) && !neighbor.visited) {
          openSet.add(neighbor);
        }
      }
    }

    return result;
  }

  void _initializeGrid() {
    grid.clear();

    for (var i = 0; i < columnsCount; i++) {
      grid.add(<Cell>[]);

      for (var j = 0; j < rowsCount; j++) {
        grid[i].add(Cell(position: Position(i, j), width: cellWidth));
      }
    }
  }

  List<Cell> _getNeigbor(Position position, {required bool checkWalls}) {
    final neighbors = <Cell>[];
    final neighborPositions = <Position>[
      Position(position.x, position.y - 1),
      Position(position.x + 1, position.y),
      Position(position.x, position.y + 1),
      Position(position.x - 1, position.y),
    ];

    for (final direction in Direction.values) {
      final index = direction.index;

      if (_isOutsideOfGrid(neighborPositions[index], columnsCount, rowsCount)) {
        continue;
      }

      final current = grid[position.x][position.y];
      final neighbor =
          grid[neighborPositions[index].x][neighborPositions[index].y];

      if (checkWalls && current.walls.contains(direction)) {
        continue;
      }

      if (!neighbor.visited) {
        neighbors.add(neighbor);
      }
    }

    return neighbors;
  }

  bool _isOutsideOfGrid(Position position, int width, int height) =>
      position.x < 0 ||
      position.x >= width ||
      position.y < 0 ||
      position.y >= height;

  void _removeWalls(Cell currentCell, Cell nextCell) {
    final x = currentCell.position.x - nextCell.position.x;
    final y = currentCell.position.y - nextCell.position.y;

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

  Iterable<Cell> _reconstructPath() {
    var goal = grid[this.goal.x][this.goal.y];

    final path = <Cell>[goal];

    while (goal.previous != null) {
      goal = goal.previous!;
      path.add(goal);
    }

    return path.reversed;
  }

  double _getDistance(Position a, Position b) =>
      sqrt(pow(a.x - b.x, 2) + pow(a.y - b.y, 2));
}
