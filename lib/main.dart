import 'package:flutter/material.dart';
import 'package:flutter_barbershop/blocs/filters/filters_bloc.dart';
import 'package:flutter_barbershop/config/Theme.dart';
import 'package:flutter_barbershop/config/app_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'screens/screens.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    //wrapping Material app with this widget to be able to use BLoC
    return MultiBlocProvider(
      providers: [
        //create new instance of Filters BLoC and add FilterLoad event so that
        //app is restarted, filter screen will be ready to be used.
        BlocProvider(create: (context) => FiltersBloc()..add(FilterLoad()))
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: theme(),
        home: Scaffold(body: MyHomePage(callFromFilterScreen: false)),
        onGenerateRoute: AppRouter.onGenerateRoute,
        initialRoute: MyHomePage.routeName,
      ),
    );
  }
}