import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_a_star/maze.dart';
import 'package:flutter_a_star/maze_painter.dart';

const Size size = Size(600, 600);

void main() => runApp(MainApp());

class MainApp extends StatelessWidget {
  MainApp({super.key});

  final Maze maze = Maze(
    width: size.width,
    height: size.height,
    cellWidth: 16,
  );

  @override
  Widget build(BuildContext context) => MaterialApp(
        home: Scaffold(
          body: Center(
            child: StreamBuilder<Maze>(
              stream: updateGrid(),
              initialData: maze,
              builder: (_, AsyncSnapshot<Maze> result) => CustomPaint(
                size: size,
                painter: MazePainter(result.data!),
              ),
            ),
          ),
        ),
      );

  Stream<Maze> updateGrid() {
    final Stream<Maze> result = Stream<Maze>.periodic(
      const Duration(milliseconds: 30),
      (_) {
        if (maze.mazeIsDone) {
          for (var element in maze.grid) {
            for (var cell in element) {
              cell.visited = false;
            }
          }
        }

        maze.mazeIsDone ? maze.findPath() : maze.checkNeighbors();

        if (maze.goalFound) {
          maze.backtrackPath();
        }

        return maze;
      },
    );

    return result;
  }
}
