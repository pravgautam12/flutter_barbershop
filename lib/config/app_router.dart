// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_barbershop/main.dart';
import 'package:flutter_barbershop/place_detail.dart';
import 'package:flutter_barbershop/screens/screens.dart';

class AppRouter {
  static Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case MyHomePage.routeName:
        return MyHomePage.route();
      case FilterScreen.routeName:
        return FilterScreen.route();
      case PlaceDetail.routeName:
        return PlaceDetail.route();
      default:
        return _errorRoute();
    }
  }

  static Route _errorRoute() {
    return MaterialPageRoute(
        builder: (_) => Scaffold(appBar: AppBar(title: Text('error'))),
        settings: RouteSettings(name: '/error'));
  }
}
