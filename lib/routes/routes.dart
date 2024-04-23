import 'package:flutter/material.dart';
import 'package:gamegrid/screens/HomeScreen.dart';
import 'package:gamegrid/screens/ContentScreen.dart';

class Routes {
  static const String HOMESCREEN = '/home';
  static const String CONTENTSCREEN = '/content';
// routes of pages in the app
  static Map<String, Widget Function(BuildContext)> get getroutes => {
    '/': (context) => const HomeScreen(),
    HOMESCREEN: (context) => const HomeScreen(),
    CONTENTSCREEN: (context) => const ContentScreen(),
  };
}