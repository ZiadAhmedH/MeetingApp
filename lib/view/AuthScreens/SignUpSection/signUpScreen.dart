import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:meeting_app/Routeres/RouterContstants.dart';
import 'package:meeting_app/model/components/CustomBtnRouter.dart';
import 'package:meeting_app/model/components/CustomText.dart';
import 'package:meeting_app/model/components/TextFormFeild.dart';
import 'package:meeting_app/utils/AppColor.dart';
import 'package:meeting_app/utils/ThemeExtension.dart';
import 'package:meeting_app/view/AuthScreens/SignUpSection/userInfoSection/AcceptTermsSection.dart';
import 'package:meeting_app/viewModel/bloc/AuthCubit/auth_cubit.dart';
import 'package:meeting_app/viewModel/bloc/VerfiyCubit/verfiy_cubit.dart';

import '../../../model/components/CustomBtn.dart';
import 'signUpSection/SignUpSection.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var authCubit = AuthCubit.get(context);
    var verifyCubit = VerfiyCubit.get(context);
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
                          authCubit.acceptTerms();
                        },
                        isAcceptTerms: authCubit.isAcceptTerms,
                      ),

                    ],
                  ),
                ),

                CustomButton(
                  onTap: (){
                    if(authCubit.signKey.currentState!.validate()){
                       verifyCubit.submitPhoneNumber(phone: VerfiyCubit.userPhoneNumber.text);
                       context.pushNamed(RouteConst.verify);
                    }
                  },
                    textColor: AppColor.white,
                    borderColor: AppColor.lightGrey,
                    backgroundColor: authCubit.isAcceptTerms
                        ? AppColor.primaryBlue
                        : AppColor.darkGrey,
                    isClickable: authCubit.isAcceptTerms ? 1 : 0,
                    text: "Next"),
              ],
            ),
          ),
        );
      },
    );
  }
}
