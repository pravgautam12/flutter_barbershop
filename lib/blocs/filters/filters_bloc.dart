import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../models/models.dart';
part 'filters_event.dart';
part 'filters_state.dart';

//events come in, states come out : that's all this file does.
//we sent events into BLoC and yield states(like loaded, success or failure)
class FiltersBloc extends Bloc<FiltersEvent, FiltersState> {
  //indicates that initial state of bloc is FiltersLoading
  FiltersBloc() : super(FiltersLoading()) {
    on<FilterLoad>(_onLoadFilter);
    on<DistanceFilterUpdated>(_onUpdateDistanceFilter);
  }

  //yields filter loaded state.
  void _onLoadFilter(FilterLoad event, Emitter<FiltersState> emit) async {
    //as a parameter for Filter, we create a new Filter instance where we set distance filter
    //equal to list of filters we created in distance filter model.
    emit(
        FiltersLoaded(
          filter: Filter(distanceFilters: DistanceFilter.filters)));
  }

  void _onUpdateDistanceFilter(
      DistanceFilterUpdated event, Emitter<FiltersState> emit) async {
    final state = this.state;
    if (state is FiltersLoaded) {
      //create new list of DistanceFilter. we get distance filter that's been passed as input by
      //clicking UI in the filter screen. and then we will place this distance filter inside original
      //list of filters.
      //we do this coz as we click, we change the status of checkbox from false to true and we want to make
      //sure that in the list of filters that we are saving in the state of the bloc, we are also changing the
      //value of the category filter. lets say they click distance value of 100m, we change value from false
      //to true and we want to be able to track that so that later on, we are able to filter using distance of 100m.
      final List<DistanceFilter> updatedDistanceFilters =
          state.filter.distanceFilters.map((distanceFilter) {
        return distanceFilter.id == event.distanceFilter.id
            ? event.distanceFilter
            : distanceFilter.copyWith(value: false);
      }).toList();
      emit(FiltersLoaded(
          filter: Filter(distanceFilters: updatedDistanceFilters)));
    }
  }
}













// import 'package:bloc/bloc.dart';
// import 'package:equatable/equatable.dart';
// import '../../models/models.dart';
// part 'filters_event.dart';
// part 'filters_state.dart';

// //events come in, states come out : that's all this file does.
// //we sent events into BLoC and yield states(like loaded, success or failure)
// class FiltersBloc extends Bloc<FiltersEvent, FiltersState> {
//   //indicates that initial state of bloc is FiltersLoading
//   FiltersBloc() : super(FiltersLoading());

//   @override //takes event as input and transform it into a new state
//   Stream<FiltersState> mapEventToState(FiltersEvent event) async* {
//     if (event is FilterLoad) {
//       yield* _mapFilterLoadToState();
//     }

//     if (event is DistanceFilterUpdated) {
//       yield* _mapDistanceFilterUpdatedToState(event, state);
//     }
//   }

//   //yields filter loaded state.
//   Stream<FiltersState> _mapFilterLoadToState() async * {
//     //as a parameter for Filter, we create a new Filter instance where we set distance filter
//     //equal to list of filters we created in distance filter model.
//     yield FiltersLoaded(filter: Filter(distanceFilters: DistanceFilter.filters));
//   }

//   Stream<FiltersState> _mapDistanceFilterUpdatedToState(
//   DistanceFilterUpdated event, FiltersState state) async*
//     {
//       if (state is FiltersLoaded)
//       {
//         //create new list of DistanceFilter. we get distance filter that's been passed as input by
//         //clicking UI in the filter screen. and then we will place this distance filter inside original
//         //list of filters.
//         //we do this coz as we click, we change the status of checkbox from false to true and we want to make
//         //sure that in the list of filters that we are saving in the state of the bloc, we are also changing the
//         //value of the category filter. lets say they click distance value of 100m, we change value from false
//         //to true and we want to be able to track that so that later on, we are able to filter using distance of 100m.
//         final List<DistanceFilter> updatedDistanceFilters = state.filter.distanceFilters.map((distanceFilter){
//           return distanceFilter.id == event.distanceFilter.id ? event.distanceFilter : distanceFilter;
//         }).toList();
//         //
//         yield FiltersLoaded(
//           filter: Filter(
//             distanceFilters: updatedDistanceFilters
//           )
//         );
//       }
//     }
// }