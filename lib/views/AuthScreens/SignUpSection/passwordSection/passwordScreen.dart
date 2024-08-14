import 'package:fancy_password_field/fancy_password_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:meeting_app/Routeres/RouterContstants.dart';
import 'package:meeting_app/model/components/CustomBtn.dart';
import 'package:meeting_app/utils/RegexConst.dart';
import 'package:meeting_app/views/AuthScreens/SignUpSection/passwordSection/passwordValidationScetion.dart';
import '../../../../model/components/CustomBtnRouter.dart';
import '../../../../model/components/CustomText.dart';
import '../../../../model/components/TextFormFeild.dart';
import '../../../../utils/AppColor.dart';
import '../../../../viewModel/bloc/AuthCubit/auth_cubit.dart';

class PasswordScreen extends StatelessWidget {
  const PasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var authCubit = AuthCubit.get(context);
    authCubit.passwordListener();
    return Scaffold(
      backgroundColor: AppColor.primaryColor,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 50,
                  ),
                  CustomText(
                    text: 'Enter Password',
                    fontFamily: 'Gilroy',
                    fontWeight: FontWeight.bold,
                    color: AppColor.white,
                    fontSize: 20,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  CustomText(
                    text:
                        'Your password must be a combination of numbers and English letters or symbols, including at least 8 characters.',
                    fontFamily: 'Gilroy',
                    fontWeight: FontWeight.normal,
                    color: AppColor.white,
                    fontSize: 14,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  PasswordValidationSection(),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
            BlocBuilder<AuthCubit, AuthState>(
              builder: (context, state) {
                return  CustomButton(
                    borderColor: AppColor.darkGrey,
                    backgroundColor: (authCubit.passwordStrength &&
                        authCubit.passwordController.text ==
                            authCubit.confirmPasswordController.text)
                        ? AppColor.primaryBlue
                        : AppColor.darkGrey,
                    text: 'Next',
                    isClickable: (authCubit.passwordStrength &&
                        authCubit.passwordController.text ==
                            authCubit.confirmPasswordController.text) ? 1 : 0,
                    onTap: () {
                      authCubit.signUpWithFire();
                    },
                    textColor: AppColor.white);
              },
            ),

          ],
        ),
      ),
    );
  }
}
