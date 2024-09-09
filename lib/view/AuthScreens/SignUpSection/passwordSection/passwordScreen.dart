
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:meeting_app/Routeres/RouterContstants.dart';
import 'package:meeting_app/model/components/CustomBtn.dart';
import 'package:meeting_app/utils/ThemeExtension.dart';
import 'package:meeting_app/view/AuthScreens/SignUpSection/passwordSection/passwordValidationScetion.dart';
import '../../../../model/components/CustomText.dart';
import '../../../../utils/AppColor.dart';
import '../../../../viewModel/bloc/AuthCubit/auth_cubit.dart';


class PasswordScreen extends StatelessWidget {
  const PasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var authCubit = AuthCubit.get(context);
    authCubit.passwordListener();
    return Scaffold(
      backgroundColor: context.primaryBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child:  Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 50,
                  ),
                  CustomText(
                    text: 'Enter Password',
                    fontFamily: 'Gilroy',
                    fontWeight: FontWeight.bold,
                    color: context.thirdTextColor,
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
                    color: context.thirdTextColor,
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
                return CustomButton(
                    borderColor: AppColor.lightGrey,
                    backgroundColor: (authCubit.passwordStrength &&
                        authCubit.passwordController.text ==
                            authCubit.confirmPasswordController.text && authCubit.passwordController.text.isNotEmpty)
                        ? AppColor.primaryBlue
                        : AppColor.lightGrey,
                    text: 'Next',
                  onTap: () {
                    if (authCubit.passwordStrength &&
                        authCubit.passwordController.text ==
                            authCubit.confirmPasswordController.text) {
                      context.pushNamed(RouteConst.inputProfileInfo);
                    }
                  },
                    isClickable: (authCubit.passwordStrength &&
                        authCubit.passwordController.text ==
                            authCubit.confirmPasswordController.text) ? 1 : 0,  textColor: context.thirdTextColor!,
                  );
              },
            ),
          ],
        ),
      ),
    );
  }
}
