import 'package:flutter_a_star/enums.dart';

class Cell {
  Cell({
    required this.x,
    required this.y,
    required this.width,
  });

  final int x;
  final int y;
  final double width;

  final List<Direction> walls = <Direction>[
    Direction.top,
    Direction.right,
    Direction.bottom,
    Direction.left,
  ];

  bool visited = false;

  double f = 0;
  double g = 0;
  double h = 0;

  Cell? previous;
}
