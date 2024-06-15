import 'package:flutter/material.dart';

import 'package:flutter_maze_generator/maze_drawer.dart';
import 'package:flutter_maze_generator/maze_generator.dart';
import 'package:flutter_maze_generator/maze_painter.dart';
import 'package:flutter_maze_generator/position.dart';

const Size size = Size(300, 400);
const double cellWidth = 14;

void main() => runApp(MainApp());

class MainApp extends StatelessWidget {
  MainApp({super.key});

  final MazeGenerator maze = MazeGenerator(
    width: size.width,
    height: size.height,
    cellWidth: cellWidth,
    start: const Position(0, 0),
    goal: Position(
      (size.width / cellWidth - 1).floor(),
      (size.height / cellWidth - 1).floor(),
    ),
  );

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: Colors.black,
          body: Center(
            child: StreamBuilder<MazeGenerator>(
              stream: maze.generateDepthFirst(),
              initialData: maze,
              builder: (_, AsyncSnapshot<MazeGenerator> result) => CustomPaint(
                size: size,
                painter: MazePainter(MazeDrawer(result.data!)),
              ),
            ),
          ),
        ),
      );
}
