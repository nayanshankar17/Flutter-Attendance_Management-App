import 'package:attendance_app/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'screens/login_screen.dart';

void main() { 
  runApp(MyApp());  
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, //This line removes the debug banner from the app
      home: LoginScreen(), //Sets LoginScreen as the initial screen of the app
    );
  }
}