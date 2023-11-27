import 'package:flutter_barbershop/models/distance_filter_model.dart';
import 'package:equatable/equatable.dart';

class Filter extends Equatable{
  final List<DistanceFilter> distanceFilters;

  const Filter({this.distanceFilters = const <DistanceFilter>[]});

  //this method helps take the Filter class and change only one of the filters
  Filter copyWith({List<DistanceFilter>? distanceFilters}) {
    return Filter(distanceFilters: distanceFilters ?? this.distanceFilters);
  }

  @override
  List<Object?> get props => [distanceFilters];
}