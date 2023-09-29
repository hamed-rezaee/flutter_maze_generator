import 'package:equatable/equatable.dart';

class Position with EquatableMixin {
  Position(this.x, this.y);

  final int x;
  final int y;

  @override
  List<Object?> get props => <Object?>[x, y];

  @override
  String toString() => '$runtimeType(x: $x, y: $y)';
}
