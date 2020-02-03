import 'package:flutter/material.dart';
import 'package:gittrend/pages/splash_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xFFFFFFFF),
        primaryColor: Colors.black,
        accentColor: Colors.black,
      ),
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
