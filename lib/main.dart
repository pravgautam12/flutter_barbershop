import 'package:flutter/material.dart';
import 'package:flutter_barbershop/config/Theme.dart';
import 'package:flutter_barbershop/config/app_router.dart';
import 'package:flutter_barbershop/providers/filter_provider.dart';
import 'package:provider/provider.dart';
import 'screens/screens.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    //wrapping Material app with this widget to be able to use FilterProvider inside the entire app
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => FilterProvider()),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: theme(),
          home: Scaffold(body: MyHomePage()),
          onGenerateRoute: AppRouter.onGenerateRoute,
          initialRoute: MyHomePage.routeName,
        ));
  }
}