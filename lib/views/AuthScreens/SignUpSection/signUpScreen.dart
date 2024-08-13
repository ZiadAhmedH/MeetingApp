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
          backgroundColor: AppColor.primaryColor,
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
                      const CustomText(
                        text: 'Start you Meeting Now !',
                        fontFamily: 'Gilroy',
                        fontWeight: FontWeight.bold,
                        color: AppColor.white,
                        fontSize: 20,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const CustomText(
                        text:
                            'Entering your email to start your meeting hub today',
                        fontFamily: 'Gilroy',
                        fontWeight: FontWeight.w200,
                        color: AppColor.white,
                        fontSize: 16,
                      ),
                      const SizedBox(
                        height: 20,
                      ),

                      SignUpSection(),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          IconButton(
                              onPressed: () {
                                authCubit.acceptTerms();
                              },
                              icon: Icon(
                                Icons.circle,
                                size: 15,
                                color: authCubit.isAcceptTermsLogin
                                    ? AppColor.primaryBlue
                                    : AppColor.white,
                              )),

                          const Flexible(
                            child:  CustomText(
                              text:
                                  'I have read and accept the Terms of Service and Privacy Policy.',
                              fontFamily: 'Gilroy',
                              fontWeight: FontWeight.w200,
                              color: AppColor.white,
                              fontSize: 12,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                CustomButton(
                  onTap: (){
                    if(authCubit.signKey.currentState!.validate()){
                       verifyCubit.submitPhoneNumber(phone: verifyCubit.userPhoneNumber.text);
                       context.pushNamed(RouteConst.verify);
                    }
                  },
                    textColor: AppColor.white,
                    borderColor: AppColor.darkGrey,
                    backgroundColor: authCubit.isAcceptTermsLogin
                        ? AppColor.primaryBlue
                        : AppColor.darkGrey,
                    isClickable: authCubit.isAcceptTermsLogin ? 1 : 0,
                    text: "Next"),
              ],
            ),
          ),
        );
      },
    );
  }
}
