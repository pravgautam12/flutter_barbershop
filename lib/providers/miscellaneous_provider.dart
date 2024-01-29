import 'package:flutter/material.dart';

class MiscellaneousProvider extends ChangeNotifier {
  int resultCount;

  MiscellaneousProvider({this.resultCount = 5});

  void changeCount({required int count}) async {
    resultCount = count;
  }
}