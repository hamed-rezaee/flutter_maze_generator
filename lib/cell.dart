import 'package:equatable/equatable.dart';

import 'package:flutter_maze_generator/enums.dart';
import 'package:flutter_maze_generator/position.dart';

class Cell with EquatableMixin {
  Cell({
    required this.position,
    required this.width,
  });

  final Position position;
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

  @override
  List<Object?> get props => <Object?>[position];
}
