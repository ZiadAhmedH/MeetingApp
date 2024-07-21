import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meeting_app/Routeres/RouterContstants.dart';
import 'package:meeting_app/views/HomePage.dart';
import 'package:meeting_app/views/LoginScreen.dart';
import 'package:meeting_app/views/signMainScreen.dart';
import 'package:meeting_app/views/signUpScreen.dart';
import 'package:meeting_app/views/splashScreen.dart';

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
          path: '/login',
          pageBuilder: (context, state) {
            return const MaterialPage(child: LoginScreen());
          }),
      GoRoute(
        name: RouteConst.home,
        path: '/home',
        pageBuilder: (context, state) {
          return const MaterialPage(child: HomePage());
        },
      ),
    ],
    redirect: (context, state) {},
  );
}
