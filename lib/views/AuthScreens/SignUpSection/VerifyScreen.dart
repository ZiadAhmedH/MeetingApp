
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meeting_app/utils/ThemeExtension.dart';
import 'package:meeting_app/viewModel/bloc/VerfiyCubit/verfiy_cubit.dart';
import 'package:meeting_app/Routeres/RouterContstants.dart';
import '../../../model/components/CustomBtn.dart';
import '../../../model/components/CustomText.dart';
import '../../../model/components/TextFormFeild.dart';
import '../../../utils/AppColor.dart';
import '../../../viewModel/bloc/AuthCubit/auth_cubit.dart';
class VerifyScreen extends StatelessWidget {
  const VerifyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var verfiyCubit = VerfiyCubit.get(context);
    var authCubit = AuthCubit.get(context);
    return  Scaffold(
      backgroundColor: context.primaryBackgroundColor,
         body: Padding(
           padding: const EdgeInsets.all(8.0),
           child: Column(
             children: [
               Expanded(
                 child: Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     const SizedBox(
                       height: 50,
                     ),
                      CustomText(
                       text: 'Verify your account',
                       fontFamily: 'Gilroy',
                       fontWeight: FontWeight.bold,
                       color: context.thirdTextColor,
                       fontSize: 20,
                     ),
                     const SizedBox(
                       height: 10,
                     ),
                      CustomText(
                       text:
                           "We have sent a verification code to your Phone number ${VerfiyCubit.userPhoneNumber.text}",
                       fontFamily: 'Gilroy',
                       fontWeight: FontWeight.w200,
                       color: context.thirdTextColor,
                       fontSize: 16,
                     ),
                     const SizedBox(
                       height: 20,
                     ),
                     CustomTextFormField(
                       hintText: 'Enter your verification code',
                       controller: verfiyCubit.verificationCode,
                       keyboardType: TextInputType.number,
                       obscureText: false,
                       validator: (value) {
                         if (value!.isEmpty) {
                           return 'Please enter your verification code';
                         }
                         return null;
                       },
                       icon: Icon(
                         Icons.meeting_room,
                         color:context.primaryTextColor ,
                       ),
                     ),
                     const SizedBox(
                       height: 20,
                     ),
                     CustomButton(
                       borderColor: AppColor.white,
                       backgroundColor: context.filledColor2!,
                       text: 'Verify',
                       textColor: context.primaryTextColor!,
                       isClickable: 1,
                       onTap: () {
                        verfiyCubit.onSmsCodeSubmitted();
                        Future.delayed(const Duration(seconds: 2), () {
                         const CircularProgressIndicator();
                          if (verfiyCubit.isVerify) {
                              context.pushReplacementNamed(RouteConst.password);
                          }
                        });
                       },
                     ),
                   ],
                 ),
               ),
             ],
           ),
         )
    );
  }
}
