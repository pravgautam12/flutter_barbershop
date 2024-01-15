import 'package:flutter/material.dart';

class FilterProvider extends ChangeNotifier {
  int distance;

  FilterProvider({this.distance = 1611});

  void changeFilter({required int newDistance}) async {
    distance = newDistance;
  }

}
