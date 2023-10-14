import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

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
  bool path = false;

  double f = 0;
  double g = 0;
  double h = 0;

  Cell? previous;

  Offset get offset =>
      Offset(position.x * width + width / 2, position.y * width + width / 2);

  @override
  List<Object?> get props => <Object?>[position];
}
