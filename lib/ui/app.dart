import 'package:flutter/material.dart';
import 'package:unetpedia/ui/ui.dart';
import 'package:unetpedia/utils/local_storage.dart';
import 'package:unetpedia/models/generic/generic_enums.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late AppState status;

  @override
  void initState() {
    final isLogged = (LocalStorage.getToken() ?? "").isNotEmpty;

    // Caso cuando el usario esta logueado
    if (isLogged) {
      status = AppState.loggedUser;

      return;
    }

    // Caso cuando el usuario no esta logueado
    if (!isLogged) {
      status = AppState.logOut;
      return;
    }

    status = AppState.error;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    switch (status) {
      case AppState.loggedUser:
        return const HomeView();
      case AppState.logOut:
        return const LoginView();
      case AppState.error:
        return const Placeholder();
    }
  }
}
