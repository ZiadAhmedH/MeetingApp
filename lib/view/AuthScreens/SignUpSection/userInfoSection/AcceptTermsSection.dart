
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meeting_app/utils/ThemeExtension.dart';
import '../../../../model/components/CustomText.dart';
import '../../../../utils/AppColor.dart';
class AcceptTerms extends StatelessWidget {

  final Cubit cubit;
  final void Function() onTap;
  final bool isAcceptTerms ;

  const AcceptTerms({super.key, required this.cubit, required this.onTap, required this.isAcceptTerms});

  @override
  Widget build(BuildContext context) {
    return   Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        IconButton(
            onPressed: () {
              onTap();
            },
            icon: Icon(
              Icons.circle,
              size: 15,
              color: isAcceptTerms
                  ? AppColor.primaryBlue
                  : AppColor.white,
            )),

         Flexible(
          child:  CustomText(
            text:
            'I have read and accept the Terms of Service and Privacy Policy.',
            fontFamily: 'Gilroy',
            fontWeight: FontWeight.w200,
            color: context.thirdTextColor,
            fontSize: 12,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    )
    ;
  }
}
