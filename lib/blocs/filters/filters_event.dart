part of 'filters_bloc.dart';

abstract class FiltersEvent extends Equatable {
  const FiltersEvent();

  @override
  List<Object> get props => [];
}

//This is the event that will be added when we create new filter block in main.dart file
class FilterLoad extends FiltersEvent {
  @override
  List<Object> get props => [];
}

//gets called everytime distance filter gets updated
class DistanceFilterUpdated extends FiltersEvent {
  final DistanceFilter distanceFilter;

  const DistanceFilterUpdated({required this.distanceFilter});

  @override
  List<Object> get props => [distanceFilter];
}