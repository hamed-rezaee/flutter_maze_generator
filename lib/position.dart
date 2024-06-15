import 'package:equatable/equatable.dart';

class Position with EquatableMixin {
  const Position(this.x, this.y);

  final int x;
  final int y;

  @override
  List<Object?> get props => <Object?>[x, y];

  @override
  String toString() => 'Position(x: $x, y: $y)';
}
