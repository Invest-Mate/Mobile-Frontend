import 'package:crowd_application/screens/splash_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fundzer',
      theme: ThemeData(
        fontFamily: 'Poppins',
      ),
      home: SplashScreen(key: key),
    );
  }
}
