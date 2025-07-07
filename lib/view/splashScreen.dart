import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:meeting_app/core/utils/ThemeExtension.dart';
import 'package:meeting_app/viewModel/data/SharedKeys.dart';
import 'package:meeting_app/viewModel/data/SharedPrefrences.dart';
import '../core/Routers/RouterContstants.dart';
import '../core/components/CustomText.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _navigateToNextScreen();
    });
  }

  void _navigateToNextScreen() async {
    await Future.delayed(const Duration(seconds: 3));
    if (mounted) {
       
       final isLogin = LocalData.getData(key: SharedKey.isLogin) ?? false;
      
      if (isLogin) {      
          Navigator.pushNamedAndRemoveUntil(context, RouteConst.home ,( route) => false);
      } else {
          Navigator.pushNamedAndRemoveUntil(context, RouteConst.signMain , (route) => false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.primaryBackgroundColor,
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset("assets/logos/mainLogo.svg",
                width: 50, height: 50),
            const SizedBox(width: 10),
            CustomText(
              text: "MeetSpace",
              fontFamily: "Gilroy",
              fontWeight: FontWeight.bold,
              fontSize: 26,
              color: context.secondaryTextColor,
            ),
          ],
        ),
      ),
    );
  }
}
