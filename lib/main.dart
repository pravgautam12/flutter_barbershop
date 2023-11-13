import 'package:flutter/material.dart';
import 'package:flutter_barbershop/config/app_router.dart';
import 'screens/screens.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Poppins',
      ),
      home: const Scaffold(
          backgroundColor: Colors.white, appBar: null, body: MyHomePage()
      ),
      onGenerateRoute: AppRouter.onGenerateRoute,
      initialRoute: MyHomePage.routeName,
    );
  }
}