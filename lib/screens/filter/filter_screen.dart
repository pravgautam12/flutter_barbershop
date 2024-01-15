// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barbershop/providers/filter_provider.dart';
import 'package:provider/provider.dart';

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
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 50),
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(5))),
                        backgroundColor: Colors.white),
                    onPressed: () {
                      Navigator.pushNamed(context, '/');
                    },
                    child: Text('Apply',
                              style: TextStyle(color: Colors.black)))
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
  int selectedSegment = 0;

  @override
  Widget build(BuildContext context) {
    int radius = context.watch<FilterProvider>().distance;
    switch (radius) {
      case 16094:
        selectedSegment = 1;
      case 24140:
        selectedSegment = 2;
    }

    return SizedBox(
      height: 50,
      child: CupertinoSlidingSegmentedControl(
          backgroundColor: Colors.white,
          thumbColor: Colors.grey,
          groupValue: selectedSegment,
          onValueChanged: (int? value) {
            if (value != null) {
              int radius = 10000;
              switch (value) {
                case 0:
                  radius = 1611;
                  break;
                case 1:
                  radius = 16094;
                  break;
                case 2:
                  radius = 24140;
                  break;
              }

              setState(() {
                selectedSegment = value;
              });

              context.read<FilterProvider>().changeFilter(newDistance: radius);
            }
          },
          children: <int, Text>{
            0: Text('1mi'),
            1: Text('10mi'),
            2: Text('15mi')
          }),
    );
  }
}
