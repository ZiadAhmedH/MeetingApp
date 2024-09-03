import 'package:flutter/material.dart';
import 'package:meeting_app/model/components/CustomText.dart';
import 'package:meeting_app/utils/ThemeExtension.dart';

import '../../utils/AppColor.dart';
class MeetingFBtn extends StatelessWidget {


  final String text;

  final IconData icon;
  final void Function()? onTap;

  const MeetingFBtn({super.key, required this.text, this.onTap, required this.icon});
  @override
  Widget build(BuildContext context) {

    return  LayoutBuilder(
      builder: (context, constraints) {
        return   Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: onTap,
              child: Container(
                height:60,
                width: 60,
                decoration: const BoxDecoration(
                  color: AppColor.primaryBlue,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: Icon(
                 icon,
                  color: context.thirdTextColor,
                ),
              ),
            ),
            CustomText(text: text ,fontSize: 15,fontWeight: FontWeight.w200,color:context.thirdTextColor,fontFamily: 'Gilroy',)
          ],
        );
      },

    );
  }
}
