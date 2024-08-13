import 'package:fancy_password_field/fancy_password_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meeting_app/Routeres/RouterContstants.dart';
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
    return Scaffold(
      backgroundColor: AppColor.primaryColor,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocConsumer<AuthCubit, AuthState>(
  listener: (context, state) {
    // TODO: implement listener
  },
  builder: (context, state) {
    return ListView(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 50,
                  ),
                  const CustomText(
                    text: 'Enter Password',
                    fontFamily: 'Gilroy',
                    fontWeight: FontWeight.bold,
                    color: AppColor.white,
                    fontSize: 20,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const CustomText(
                    text: 'Your password must be a combination of numbers and English letters or symbols, including at least 8 characters.',
                    fontFamily: 'Gilroy',
                    fontWeight: FontWeight.normal,
                    color: AppColor.white,
                    fontSize: 14,
                  ),
                  const SizedBox(
                    height: 20,
                  ),

                  const PasswordValidationSection(),

                const SizedBox(
                  height: 20,
                ),
                  CustomTextFormField(
                    hintText: 'R-Enter your password',
                    controller: authCubit.confirmPasswordController,
                    obscureText: true,
                    icon: const Icon(
                      Icons.lock,
                      color: AppColor.lightBlack,
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your password';
                      }
                      if (authCubit.passwordController.text != authCubit.confirmPasswordController.text) {
                        return 'Please enter a valid password';
                      }
                      return null;
                    },),


                ],
              ),
            ),
            CustomButtonRouter(
              borderColor: AppColor.darkGrey,
              backgroundColor:(authCubit.passwordStrength &&authCubit.passwordController.text == authCubit.confirmPasswordController.text  ) ? AppColor.primaryBlue : AppColor.darkGrey,
              text: 'Next',
              routeName: RouteConst.home,
              isClickable: (authCubit.passwordStrength &&authCubit.passwordController.text == authCubit.confirmPasswordController.text  ) ? 1 : 0,
            ),
          ],
        );
  },
),
      ),
    );
  }
}
