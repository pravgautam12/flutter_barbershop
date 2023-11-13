// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_barbershop/screens/screens.dart';

class AppRouter {
  static Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MyHomePage.route();
      case MyHomePage.routeName:
        return MyHomePage.route();
      case FilterScreen.routeName:
        return FilterScreen.route();
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
