import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:meeting_app/Routeres/RouterContstants.dart';
import 'package:meeting_app/model/components/CustomText.dart';
import 'package:meeting_app/utils/AppColor.dart';
import 'package:go_router/go_router.dart';
import 'package:meeting_app/viewModel/data/SharedPrefrences.dart';

import '../viewModel/data/SharedKeys.dart';

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
      LocalData.getData(key: SharedKey.isLogin)
          ? GoRouter.of(context).go(RouteConst.home)
          : GoRouter.of(context).go(RouteConst.signMain);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff1a1a1a),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset("assets/logos/mainLogo.svg",
                width: 50, height: 50),
            const SizedBox(width: 10),
            const CustomText(
              text: "MeetSpace",
              fontFamily: "Gilroy",
              fontWeight: FontWeight.bold,
              fontSize: 26,
              color: AppColor.white,
            ),
          ],
        ),
      ),
    );
  }
}
