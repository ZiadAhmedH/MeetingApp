import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:meeting_app/model/components/CustomText.dart';
import 'package:meeting_app/utils/AppColor.dart';
import 'package:meeting_app/views/HomePage.dart';
import 'package:page_transition/page_transition.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Center(
        child: Row(
          children: [
            SvgPicture.asset("assets/logos/mainLogo.svg"),
            const CustomText(text: "MeetSpace" , fontFamily: "Gilroy",fontWeight: FontWeight.bold,fontSize: 26,color: AppColor.white,)
          ],
        ),
      ),
      nextScreen: HomePage(),
      splashTransition: SplashTransition.fadeTransition,
      duration: 3000,
      backgroundColor: const Color(0xff1a1a1a),
      pageTransitionType: PageTransitionType.rightToLeft,
    );
  }
}
