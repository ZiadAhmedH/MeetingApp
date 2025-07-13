import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meeting_app/core/lifeCycle/userStatManger.dart';
import 'package:meeting_app/core/services/app_startup_service.dart';
import 'package:meeting_app/viewModel/bloc/blocObserver.dart';
import 'package:meeting_app/viewModel/bloc/AuthCubit/auth_cubit.dart';
import 'package:meeting_app/viewModel/bloc/MeetingCubit/meeting_cubit.dart';
import 'package:meeting_app/viewModel/bloc/NavigationCubit/navigation_cubit.dart';
import 'package:meeting_app/viewModel/bloc/ProfileCubit/profile_cubit.dart';
import 'package:meeting_app/viewModel/bloc/ThemeCubit/theme_cubit.dart';
import 'package:meeting_app/core/Routers/RouterContstants.dart';
import 'package:meeting_app/core/Routers/go_Router.dart';
import 'package:meeting_app/global_navigator.dart';
import 'package:meeting_app/viewModel/data/SharedPrefrences.dart'; 
import 'package:meeting_app/viewModel/data/SharedKeys.dart'; 

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocObserver();

  await AppStartupService.initializeApp();

  final String? uid = LocalData.getData(key: SharedKey.uid); 

  runApp(
    uid != null
        ? UserStatusManager(
            userId: uid,
            child: const MyApp(),
          )
        : const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthCubit(AppStartupService.authService)),
        BlocProvider(create: (_) => ProfileCubit()),
        BlocProvider(create: (_) => ThemesCubit()),
        BlocProvider(create: (_) => NavigationCubit()),
        BlocProvider(create: (_) => MeetingCubit()),
      ],
      child: BlocBuilder<ThemesCubit, ThemeData>(
        builder: (_, theme) {
          return MaterialApp(
            navigatorKey: navigatorKey,
            debugShowCheckedModeBanner: false,
            title: 'Meeting App',
            theme: theme,
            initialRoute: RouteConst.splash,
            onGenerateRoute: onGenerateRoute,
          );
        },
      ),
    );
  }
}
