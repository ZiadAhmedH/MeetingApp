import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:meeting_app/Routeres/RouterContstants.dart';
import 'package:meeting_app/model/components/CustomBtnRouter.dart';
import 'package:meeting_app/model/components/CustomText.dart';
import 'package:meeting_app/utils/AppColor.dart';
import 'package:meeting_app/utils/ThemeExtension.dart';

import '../../model/components/CustomBtn.dart';

class SignMainScreen extends StatelessWidget {
  const SignMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 150,
                    height: 150,
                    child: SvgPicture.asset("assets/logos/mainLogo.svg"),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomText(
                    text: "\"Connect, Collaborate & Create\" ",
                    fontFamily: "Gilroy",
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: context.secondaryTextColor,
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: [
                  CustomButton(
                    textColor: context.primaryTextColor!,
                    text: "Sign up",
                    backgroundColor: AppColor.primaryBlue,
                    borderColor: AppColor.primaryBlue,
                    onTap: () {
                      context.pushNamed(RouteConst.signUp);
                    }, isClickable: 1,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                 CustomButton(
                   textColor: context.secondaryTextColor!,
                    text: "Log in",
                    backgroundColor: AppColor.white,
                    borderColor: AppColor.primaryBlue,
                    onTap: () {
                      context.pushNamed(RouteConst.login);
                    }, isClickable: 1,
                 ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ],
        )));
  }
}
