import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meeting_app/core/Routers/RouterContstants.dart';
import 'package:meeting_app/core/components/CustomText.dart';
import 'package:meeting_app/core/utils/AppColor.dart';
import 'package:meeting_app/core/utils/ThemeExtension.dart';
import 'package:meeting_app/view/AuthScreens/SignUpSection/userInfoSection/AcceptTermsSection.dart';
import 'package:meeting_app/viewModel/bloc/AuthCubit/auth_cubit.dart';

import '../../../core/components/CustomBtn.dart';
import 'signUpSection/SignUpSection.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var authCubit = AuthCubit.get(context);
    return BlocBuilder<AuthCubit, AuthState>(
      bloc: authCubit,
      builder: (context, state) {
        return Scaffold(
          backgroundColor: context.primaryBackgroundColor,
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [

                 Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 50,
                      ),
                      CustomText(
                        text: 'Start you Meeting Now !',
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
                            'Entering your email to start your meeting hub today',
                        fontFamily: 'Gilroy',
                        fontWeight: FontWeight.w200,
                        color: context.thirdTextColor,
                        fontSize: 16,
                      ),
                      const SizedBox(
                        height: 20,
                      ),

                      const SignUpSection(),

                      AcceptTerms(
                        cubit: authCubit,
                        onTap: () {
                          authCubit.acceptTermsRigster();
                        },
                        isAcceptTerms: authCubit.isAcceptTermsRegister,
                      ),

                    ],
                  ),
                ),

                CustomButton(
                  onTap: (){
                    if(authCubit.signKey.currentState!.validate()){
                       authCubit.sendOtp( authCubit.userPhoneNumber.text);
                        Navigator.pushNamed(context, RouteConst.verify);
                    }
                  },
                    textColor: AppColor.white,
                    borderColor: AppColor.lightGrey,
                    backgroundColor: authCubit.isAcceptTermsRegister
                        ? AppColor.primaryBlue
                        : AppColor.darkGrey,
                    isClickable: authCubit.isAcceptTermsRegister ? 1 : 0,
                    text: CustomText(
                      text: 'Next',
                      fontFamily: 'Gilroy',
                      fontWeight: FontWeight.bold,
                      color: AppColor.white,
                      fontSize: MediaQuery.of(context).size.width * 0.04,
                    ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
