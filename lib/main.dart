import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meeting_app/Routeres/RouterContstants.dart';
import 'package:meeting_app/Routeres/go_Router.dart';
import 'package:meeting_app/services/auth_services.dart';
import 'package:meeting_app/supabase_helper.dart';
import 'package:meeting_app/utils/ZigoCloudConst.dart';
import 'package:meeting_app/viewModel/bloc/AuthCubit/auth_cubit.dart';
import 'package:meeting_app/viewModel/bloc/MeetingCubit/meeting_cubit.dart';
import 'package:meeting_app/viewModel/bloc/NavigationCubit/navigation_cubit.dart';
import 'package:meeting_app/viewModel/bloc/ProfileCubit/profile_cubit.dart';
import 'package:meeting_app/viewModel/bloc/ThemeCubit/theme_cubit.dart';
import 'package:meeting_app/viewModel/bloc/blocObserver.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';
import 'viewModel/data/SharedPrefrences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocObserver();

  await SupabaseHelper.init();

  ZegoUIKit().init(
    appID: ZigoCloud.ZEGO_APP_ID, 
    appSign: ZigoCloud.ZEGO_APP_SIGN, 
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
        BlocProvider(create: (context) => AuthCubit(AuthService())),
        BlocProvider(create: (context) => ProfileCubit()),
        BlocProvider(create: (context) => ThemesCubit()),
        BlocProvider(create: (context) => NavigationCubit()),
        BlocProvider(create: (context) => MeetingCubit()),
      ],
      child: BlocBuilder<ThemesCubit, ThemeData>(
        builder: (context, themeState) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Meeting App',
            theme: themeState,
            initialRoute: RouteConst.splash,
            onGenerateRoute: onGenerateRoute,
          );
        },
      ),
    );
  }
}
