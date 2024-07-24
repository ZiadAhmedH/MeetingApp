import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meeting_app/Routeres/RouterContstants.dart';
import 'package:meeting_app/model/components/CustomBtn.dart';
import 'package:meeting_app/model/components/CustomRadio.dart';
import 'package:meeting_app/model/components/CustomText.dart';
import 'package:meeting_app/model/components/TextFormFeild.dart';
import 'package:meeting_app/utils/AppColor.dart';
import 'package:meeting_app/viewModel/bloc/AuthCubit/auth_cubit.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var authCubit = AuthCubit.get(context);

    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {},
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
                        text: 'Welcome Back !',
                        fontFamily: 'Gilroy',
                        fontWeight: FontWeight.bold,
                        color: AppColor.white,
                        fontSize: 20,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const CustomText(
                        text: 'Plearse log in to join the meeting hub',
                        fontFamily: 'Gilroy',
                        fontWeight: FontWeight.w200,
                        color: AppColor.white,
                        fontSize: 16,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      CustomTextFormField(
                        hintText: 'Enter your email address',
                        controller: null,
                        obscureText: false,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      CustomRadioButton(
                          onTap: () {
                            authCubit.acceptTerms();
                          },
                          value: authCubit.isAcceptTerms ? 1 : 0,
                          groupValue: 1,
                          onChanged: (value) {
                            authCubit.acceptTerms();
                          },
                          labelText: 'Remember me'),
                    ],
                  ),
                ),
                CustomButton(
                    borderColor: AppColor.darkGrey,
                    backgroundColor: authCubit.isAcceptTerms 
                        ? AppColor.primaryBlue
                        : AppColor.darkGrey,
                    routeName: RouteConst.home,
                    isClickable: authCubit.isAcceptTerms? 1 : 0,
                    text: "Next"),
              ],
            ),
          ),
        );
      },
    );
  }
}
