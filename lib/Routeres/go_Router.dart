import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meeting_app/Routeres/RouterContstants.dart';

import '../view/AuthScreens/LoginSection/LoginScreen.dart';
import '../view/AuthScreens/SignUpSection/VerifyScreen.dart';
import '../view/AuthScreens/SignUpSection/passwordSection/passwordScreen.dart';
import '../view/AuthScreens/SignUpSection/signUpScreen.dart';
import '../view/AuthScreens/SignUpSection/userInfoSection/UserInfoSection.dart';
import '../view/AuthScreens/signMainScreen.dart';
import '../view/HomeScreens/HomeScreen.dart';
import '../view/splashScreen.dart';


class AppRouter {
  GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
          name: RouteConst.splash,
          path: '/',
          pageBuilder: (context, state) {
            return const MaterialPage(child: SplashScreen());
          }),
      GoRoute(
          name: RouteConst.signMain,
          path: '/signMain',
          pageBuilder: (context, state) {
            return const MaterialPage(child: SignMainScreen());
          }),
      GoRoute(
          name: RouteConst.signUp,
          path: '/signUp',
          pageBuilder: (context, state) {
            return const MaterialPage(child: SignUpScreen());
          }),
      GoRoute(
           name: RouteConst.login,
          path: '/login',
          pageBuilder: (context, state) {
            return const MaterialPage(child: LoginScreen());
          }),
      GoRoute(
          name: RouteConst.verify,
          path: '/verify',
          pageBuilder: (context, state) {
            return const MaterialPage(child: VerifyScreen());
          }),
      GoRoute(
          name: RouteConst.password,
          path:"/password",
          pageBuilder: (context, state) {
        return const MaterialPage(child: PasswordScreen());
      }),
      GoRoute(
          name: RouteConst.inputProfileInfo,
          path: "/inputProfileInfo",
          pageBuilder: (context, state) {
        return const MaterialPage(child: UserInfoSection());
      }),
      GoRoute(
        name: RouteConst.home,
        path: '/home',
        pageBuilder: (context, state) {
          return const MaterialPage(child: HomeScreen());
        },
      ),




    ],


  );
}
