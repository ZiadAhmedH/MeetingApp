import 'package:flutter/material.dart';
import 'package:meeting_app/model/components/CustomText.dart';
import 'package:meeting_app/utils/AppColor.dart';
class CustomButton extends StatelessWidget {

  final Color borderColor;
  final Color backgroundColor;

  const CustomButton({super.key, required this.borderColor, required this.backgroundColor});
  @override
  Widget build(BuildContext context) {
    return  InkWell(
      child: Container(
        width: double.infinity - 50,
        height: 50,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: borderColor , width: 1)
        ),
        child: const Center(
          child: CustomText(text: "Sign Up" , fontFamily: "Gilroy",fontWeight: FontWeight.normal,fontSize: 16,color: AppColor.white,)
        ),
      ),
    );
  }
}
