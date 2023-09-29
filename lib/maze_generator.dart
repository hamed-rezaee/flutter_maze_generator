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
    Duration duration = const Duration(milliseconds: 1),
  }) async* {
    while (!_mazeIsDone) {
      final List<Cell> neighbors = _getNeigbor(
        currentCell!.position,
        checkWalls: false,
      );

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

        _mazeIsDone = true;
      }

      await Future<void>.delayed(duration);
      yield this;
    }
  }

  void _initializeGrid() {
    grid.clear();

    for (int i = 0; i < columnsCount; i++) {
      grid.add(<Cell>[]);

      for (int j = 0; j < rowsCount; j++) {
        grid[i].add(Cell(position: Position(i, j), width: cellWidth));
      }
    }
  }

  List<Cell> _getNeigbor(Position position, {required bool checkWalls}) {
    final List<Cell> neighbors = <Cell>[];
    final List<Position> neighborPositions = <Position>[
      Position(position.x, position.y - 1),
      Position(position.x + 1, position.y),
      Position(position.x, position.y + 1),
      Position(position.x - 1, position.y),
    ];

    for (final Direction direction in Direction.values) {
      final int index = direction.index;

      if (_isOutsideOfGrid(neighborPositions[index], columnsCount, rowsCount)) {
        continue;
      }

      final Cell current = grid[position.x][position.y];
      final Cell neighbor =
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
    final int x = currentCell.position.x - nextCell.position.x;
    final int y = currentCell.position.y - nextCell.position.y;

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
