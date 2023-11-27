import 'package:equatable/equatable.dart';

class Distance extends Equatable {
  final int id;
  final String distance;
  final int value;

  Distance({
    required this.id,
    required this.distance,
    required this.value
  });

  @override
  List<Object?> get props => [id, distance];

  static List<Distance> distances = [
    Distance(id: 1, distance: '5km', value: 5000),
    Distance(id: 2, distance: '10km', value: 10000),
    Distance(id: 3, distance: '20km', value: 20000)
  ];
}