import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meeting_app/Routeres/go_Router.dart';
import 'package:meeting_app/firebase_options.dart';
import 'package:meeting_app/viewModel/bloc/AuthCubit/auth_cubit.dart';
import 'package:meeting_app/viewModel/bloc/NavigationCubit/navigation_cubit.dart';
import 'package:meeting_app/viewModel/bloc/ProfileCubit/profile_cubit.dart';
import 'package:meeting_app/viewModel/bloc/ThemeCubit/theme_cubit.dart';
import 'package:meeting_app/viewModel/bloc/VerfiyCubit/verfiy_cubit.dart';
import 'package:meeting_app/viewModel/bloc/blocObserver.dart';
import 'viewModel/data/SharedPrefrences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocObserver();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  LocalData.init();
  //LocalData.clearData();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthCubit()),
        BlocProvider(create: (context) => VerfiyCubit()),
        BlocProvider(create: (context) => ProfileCubit()),
        BlocProvider(create: (context) => ThemesCubit()),
        BlocProvider(create: (context) => NavigationCubit()),
      ],
      child: BlocBuilder<ThemesCubit, ThemeData>(
        builder: (context, themeState) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: 'Meeting App',
            theme: themeState,
            routerConfig: AppRouter().router,
          );
        },
      ),
    );
  }
}