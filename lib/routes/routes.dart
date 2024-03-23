import 'package:flutter/material.dart';
import 'package:gamegrid/screens/LoginScreen.dart';
import 'package:gamegrid/screens/CardsScreen.dart';
import 'package:gamegrid/screens/RegisterScreen.dart';
import 'package:gamegrid/screens/HomeScreen.dart';

class Routes {
  static const String LOGINSCREEN = '/login';
  static const String CARDSSCREEN = '/cards';
  static const String REGISTERSCREEN = '/register';
  static const String HOMESCREEN = '/home';
// routes of pages in the app
  static Map<String, Widget Function(BuildContext)> get getroutes => {
    '/': (context) => HomeScreen(),
    LOGINSCREEN: (context) => LoginScreen(),
    CARDSSCREEN: (context) => CardsScreen(),
    REGISTERSCREEN: (context) => RegisterScreen(),
    HOMESCREEN: (context) => HomeScreen(),
  };
}