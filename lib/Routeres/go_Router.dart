import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meeting_app/Routeres/RouterContstants.dart';
import 'package:meeting_app/views/AuthScreens/SignUpSection/VerifyScreen.dart';
import 'package:meeting_app/views/AuthScreens/signMainScreen.dart';
import 'package:meeting_app/views/HomePage.dart';
import 'package:meeting_app/views/AuthScreens/LoginSection/LoginScreen.dart';
import 'package:meeting_app/views/AuthScreens/SignUpSection/signUpScreen.dart';
import 'package:meeting_app/views/splashScreen.dart';

import '../views/AuthScreens/SignUpSection/passwordSection/passwordScreen.dart';

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
        name: RouteConst.home,
        path: '/home',
        pageBuilder: (context, state) {
          return const MaterialPage(child: HomePage());
        },
      ),
    ],

  );
}
