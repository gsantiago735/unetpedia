import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:unetpedia/ui/cubit/cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unetpedia/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:unetpedia/core/routes/routes.dart';
import 'package:unetpedia/utils/local_storage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await LocalStorage.init();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<GeneralCubit>(
          create: (BuildContext context) => GeneralCubit(),
        ),
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Unetpedia',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Poppins',
        scaffoldBackgroundColor: Colors.white,
      ),
      routes: AppRouter.routes,
    );
  }
}
