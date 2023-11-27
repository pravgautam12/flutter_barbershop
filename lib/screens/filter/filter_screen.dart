// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barbershop/blocs/filters/filters_bloc.dart';
import 'package:flutter_barbershop/screens/home/home_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FilterScreen extends StatelessWidget {
  static const String routeName = '/filter';

  const FilterScreen({super.key});

  static Route route() {
    return MaterialPageRoute(
        builder: (_) => FilterScreen(),
        settings: RouteSettings(name: routeName));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        bottomNavigationBar: BottomAppBar(
            height: 65,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                BlocBuilder<FiltersBloc, FiltersState>(
                  builder: (context, state) {
                    if (state is FiltersLoading) {
                      return Center(child: CircularProgressIndicator());
                    }

                    if (state is FiltersLoaded) {
                      return ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 50),
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)))),
                          onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => MyHomePage(callFromFilterScreen: true,
                                              )),
                                    );
                            // Navigator.pushNamed(context, '/',
                            //     arguments: true);
                          },
                          child: Text('Apply'));
                    }
                    return Container();
                  },
                )
              ],
            )),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(14, 20, 14, 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: Stack(
                      children: [
                        IconButton(
                            icon: Icon(Icons.arrow_back_ios),
                            onPressed: () {
                              Navigator.of(context).pop();
                            }),
                        Positioned(
                          right: 170,
                          top: 12,
                          child: Text(
                            'Filters',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Text('Distance', style: Theme.of(context).textTheme.bodyMedium),
              CustomDistanceFilter()
            ],
          ),
        ));
  }
}

class CustomDistanceFilter extends StatefulWidget {
  const CustomDistanceFilter({Key? key}) : super(key: key);

  @override
  CustomDistanceFilterState createState() => CustomDistanceFilterState();
}

class CustomDistanceFilterState extends State<CustomDistanceFilter> {
  int selectedSegment = 1;

  @override
  Widget build(BuildContext context) {
    //BlocBuilder records and tracks changes from custom distance filter widget.
    return BlocBuilder<FiltersBloc, FiltersState>(
      builder: (context, state) {
        //return different UI based on Filter state
        if (state is FiltersLoading) {
          return Center(child: CircularProgressIndicator());
        }
        if (state is FiltersLoaded) {
          return SizedBox(
            height: 50,
            child: CupertinoSlidingSegmentedControl(
                backgroundColor: Colors.white,
                thumbColor: Colors.grey,
                groupValue: selectedSegment,
                onValueChanged: (int? value) {
                  if (value != null) {
                    context.read<FiltersBloc>().add(DistanceFilterUpdated(
                        distanceFilter: state.filter.distanceFilters[value]
                            .copyWith(
                                value: !state
                                    .filter.distanceFilters[value].value)));
                    setState(() {
                      selectedSegment = value;
                    });
                  }
                },
                //using distance filters that are coming from state of BLoC
                children:
                    Map<int, Padding>.fromEntries(state.filter.distanceFilters
                        .asMap() //cast the distance filter objects as map
                        .entries //only the entries will be taken
                        .map((distance) => MapEntry(
                            distance.key,
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 40, vertical: 10),
                              child: Text(
                                state.filter.distanceFilters[distance.key]
                                    .distanceObj.distance,
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ))))),
          );
        } else {
          return Text("Something went wrong!");
        }
      },
    );
  }
}

// class CustomDistanceFilter extends StatelessWidget {
//   const CustomDistanceFilter({Key? key})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     //BlocBuilder records and tracks changes from custom distance filter widget.
//     return BlocBuilder<FiltersBloc, FiltersState>(
//       builder: (context, state) {
//         //return different UI based on Filter state
//         if (state is FiltersLoading) {
//           return Center(child: CircularProgressIndicator());
//         }
//         if (state is FiltersLoaded) {
//           return Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               //using distance filters that are coming from state of BLoC
//               children: state.filter.distanceFilters
//                   .asMap() //cast the distance filter objects as map
//                   .entries //only the entries will be taken
//                   .map((distance) => 
//                       InkWell(
//                         onTap: () => {
//                           //get the FiltersBloc instance and add event to it, triggering state change
//                           context.read<FiltersBloc>().add(
//                             DistanceFilterUpdated(
//                               distanceFilter: state.filter.distanceFilters[distance.key]
//                                 .copyWith(
//                                   value: !state.filter.distanceFilters[distance.key].value)
//                             )
//                           )                        
//                         },
//                         child: Container(
//                             margin: EdgeInsets.only(top: 10, bottom: 10),
//                             padding: EdgeInsets.symmetric(
//                                 horizontal: 40, vertical: 10),
//                             decoration: BoxDecoration(
//                                 color: state.filter.distanceFilters[distance.key].value
//                                   ? Theme.of(context).colorScheme.secondary
//                                   : Colors.white,
//                                 borderRadius: BorderRadius.circular(5)),
//                             child: Text(
//                                 //by doing ..[..key]: select only 1 element based on key
//                                 state.filter.distanceFilters[distance.key].distanceObj.distance,
//                                 style: Theme.of(context).textTheme.titleMedium)),
//                       )
//                     )
//                   .toList());
//         } 
//         else {
//           return Text("Something went wrong!");
//         }
//       },
//     );
//   }
// }