import 'package:flutter/material.dart';
import 'package:unetpedia/ui/ui.dart';

class AppRouter {
  static Map<String, Widget Function(BuildContext)> routes = {
    '/': (BuildContext contex) => const App(),

    // Authentication

    // Home
    HomeView.routeName: (BuildContext contex) => const HomeView(),
  };
}
