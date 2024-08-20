import 'package:flutter/material.dart';
import 'package:meeting_app/utils/RegexConst.dart';
import 'package:meeting_app/viewModel/bloc/VerfiyCubit/verfiy_cubit.dart';
import 'package:meeting_app/views/AuthScreens/SignUpSection/VerifyScreen.dart';
import '../../../../model/components/TextFormFeild.dart';
import '../../../../utils/AppColor.dart';
import '../../../../viewModel/bloc/AuthCubit/auth_cubit.dart';

class SignUpSection extends StatelessWidget {
  const SignUpSection({super.key});

  @override
  Widget build(BuildContext context) {
    var authCubit = AuthCubit.get(context);
    var verifyCubit = VerfiyCubit.get(context);
    return Form(
        key: authCubit.signKey,
        child: Column(
          children: [
            CustomTextFormField(
              hintText: 'Enter your email address',
              controller: authCubit.signUpEmail,
              obscureText: false,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter your email';
                }
                RegExp regex = RegExp(RegexConst.email);
                if (!regex.hasMatch(value)) {
                  return 'Please enter a valid email address';
                }
                return null;
              },
              icon: const Icon(
                Icons.meeting_room,
                color: AppColor.lightBlack,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            CustomTextFormField(
              hintText: 'Enter your Phone number',
              controller: VerfiyCubit.userPhoneNumber,
              obscureText: false,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter your Number';
                }
                RegExp regex = RegExp(RegexConst.phoneNumber);
                if (!regex.hasMatch(value)) {
                  return 'Please enter a valid Number';
                }
                return null;
              },
              icon: const Icon(
                Icons.phone,
                color: AppColor.darkGrey,
              ),
            ),
          ],
        ));
  }
}
