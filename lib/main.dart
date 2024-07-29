
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meeting_app/Routeres/go_Router.dart';
import 'package:meeting_app/firebase_options.dart';
import 'package:meeting_app/viewModel/bloc/AuthCubit/auth_cubit.dart';
import 'package:meeting_app/viewModel/bloc/blocObserver.dart';
import 'package:meeting_app/views/splashScreen.dart';

import 'viewModel/data/SharedPrefrences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
    Bloc.observer = MyBlocObserver();
  await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
   LocalData.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthCubit()),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Meeting App',
       routerConfig: AppRouter().router,
      ),
    );
  }
}