import 'package:flutter/material.dart';
import 'package:meeting_app/core/Routers/RouterContstants.dart';
import 'package:meeting_app/model/Models/UserModel.dart';
import 'package:meeting_app/view/AuthScreens/LoginSection/LoginScreen.dart';
import 'package:meeting_app/view/AuthScreens/SignUpSection/VerifyScreen.dart';
import 'package:meeting_app/view/AuthScreens/SignUpSection/passwordSection/passwordScreen.dart';
import 'package:meeting_app/view/AuthScreens/SignUpSection/signUpScreen.dart';
import 'package:meeting_app/view/AuthScreens/SignUpSection/userInfoSection/UserInfoSection.dart';
import 'package:meeting_app/view/AuthScreens/signMainScreen.dart';
import 'package:meeting_app/view/HomeScreens/ChatScreen/ChatScreen.dart';
import 'package:meeting_app/view/HomeScreens/HomeVeiw.dart';
import 'package:meeting_app/view/HomeScreens/ProfileScreen/ProfileScreen.dart';
import 'package:meeting_app/view/searchView/search_view.dart';
import 'package:meeting_app/view/splashScreen.dart';

Route<dynamic> onGenerateRoute(RouteSettings settings) {
  switch (settings.name) {
    case RouteConst.splash:
      return MaterialPageRoute(builder: (_) => const SplashScreen());

    case RouteConst.signMain:
      return MaterialPageRoute(builder: (_) => const SignMainScreen());

    case RouteConst.signUp:
      return MaterialPageRoute(builder: (_) => const SignUpScreen());

    case RouteConst.login:
      return MaterialPageRoute(builder: (_) => const LoginScreen());

    case RouteConst.verify:
      return MaterialPageRoute(builder: (_) => const VerifyScreen());

    case RouteConst.password:
      return MaterialPageRoute(builder: (_) => const PasswordScreen());

    case RouteConst.inputProfileInfo:
      return MaterialPageRoute(builder: (_) => const UserInfoSection());

    case RouteConst.home:
      return MaterialPageRoute(builder: (_) => const HomeVeiw());

    case RouteConst.profile:
        final user = settings.arguments as UserModel;
        return MaterialPageRoute(
            builder: (context) => ProfileView(user: user));

   case RouteConst.chat:
    final args = settings.arguments as Map<String, dynamic>;
    final myUid = args['myUid'] as String;
    final otherUser = args['otherUser'] as UserModel;
     return MaterialPageRoute(
      builder: (_) => ChatView(myUid: myUid, otherUser: otherUser),
      );


    case RouteConst.search:
      return MaterialPageRoute(builder: (_) => const SearchView());  

    default:
      return MaterialPageRoute(
        builder: (_) => const Scaffold(
          body: Center(child: Text('No route defined')),
        ),
      );
  }
}
