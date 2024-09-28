import 'package:flutter/material.dart';
import 'package:quadbtech/home_screen.dart';
import 'package:quadbtech/search_screen.dart';
import 'package:quadbtech/splash_screen.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movie App',
      theme: ThemeData(
        primarySwatch: Colors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
        '/home': (context) => HomeScreen(),
        '/search': (context) => SearchScreen(),
      },
    );
  }
}
