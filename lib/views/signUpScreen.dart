import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:meeting_app/model/components/CustomBtn.dart';
import 'package:meeting_app/model/components/CustomText.dart';
import 'package:meeting_app/utils/AppColor.dart';
class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width:150,
                    height: 150,
                    child: SvgPicture.asset("assets/logos/mainLogo.svg"),
                        ),
                  const SizedBox(height: 20,),
                  const CustomText(text: "\"Connect, Collaborate & Create\" " , fontFamily: "Gilroy",fontWeight: FontWeight.bold,fontSize: 16,color:AppColor.blue ,),
                ],
              ),
            ),

            CustomButton(backgroundColor: AppColor.primaryBlue,borderColor: AppColor.primaryBlue,),
            const SizedBox(height: 20,),
            CustomButton(backgroundColor: AppColor.blackBtn,borderColor: AppColor.primaryBlue,),
            const SizedBox(height: 20,),

          ],
        )

    ));
  }
}
