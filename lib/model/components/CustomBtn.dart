import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meeting_app/model/components/CustomText.dart';
import 'package:meeting_app/utils/AppColor.dart';

import '../../Routeres/RouterContstants.dart';
class CustomButton extends StatelessWidget {

  final Color borderColor;
  final Color backgroundColor;
  final String text;
  final int isClickable;
  final Color textColor;
  final void Function() onTap;

  const CustomButton({super.key, required this.borderColor, required this.backgroundColor, required this.text, required this.isClickable, required this.onTap, required this.textColor});
  @override
  Widget build(BuildContext context) {
    return  InkWell(
      onTap: (){
        if(isClickable == 1) {
         onTap();
        }
      },
      child: Container(
        width: double.infinity - 50,
        height: 50,
        decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: borderColor , width: 1)
        ),
        child: Center(
            child: CustomText(text:text , fontFamily: "Gilroy",fontWeight: FontWeight.normal,fontSize: 16,color: textColor,)
        ),
      ),
    );
  }
}
