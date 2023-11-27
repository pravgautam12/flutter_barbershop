import 'package:flutter_barbershop/models/distance_model.dart';

class DistanceFilter {
  final int id;
  final Distance distanceObj;
  final bool value;

  DistanceFilter(
      {required this.id, required this.distanceObj, required this.value});

  DistanceFilter copyWith({int? id, Distance? distanceObj, bool? value}) {
    return DistanceFilter(
        id: id ?? this.id,
        distanceObj: distanceObj ?? this.distanceObj,
        value: value ?? this.value);
  }

  List<Object?> get props => [id, distanceObj, value];

  static List<DistanceFilter> filters = Distance.distances
      .map((distance) => DistanceFilter(
          id: distance.id, 
          distanceObj: distance, 
          value: false))
      .toList();
}