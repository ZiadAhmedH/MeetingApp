import 'package:go_router/go_router.dart';
import 'package:meeting_app/views/HomePage.dart';
import 'package:meeting_app/views/signUpScreen.dart';
import 'package:meeting_app/views/splashScreen.dart';

final _router = GoRouter(
  // turn off history tracking in the browser for this navigation
  routerNeglect: true,
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/signUp',
      builder: (context, state) => const SignUpScreen(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomePage(),
    ),



  ],
);