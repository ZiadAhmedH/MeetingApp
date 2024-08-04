import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meeting_app/Routeres/RouterContstants.dart';
import 'package:meeting_app/model/components/CustomBtn.dart';
import 'package:meeting_app/model/components/CustomText.dart';
import 'package:meeting_app/model/components/TextFormFeild.dart';
import 'package:meeting_app/utils/AppColor.dart';
import 'package:meeting_app/viewModel/bloc/AuthCubit/auth_cubit.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var authCubit = AuthCubit.get(context);
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
                      CustomTextFormField(
                        hintText: 'Enter your email address',
                        controller: authCubit.loginEmail,
                        obscureText: false,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your email';
                          }
                          String emailPattern =
                              r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$';
                          RegExp regex = RegExp(emailPattern);
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
                          const CustomText(
                            text:
                                'I have read and accept the Terms of Service and Privacy Policy.',
                            fontFamily: 'Gilroy',
                            fontWeight: FontWeight.w200,
                            color: AppColor.white,
                            fontSize: 12,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                CustomButton(
                    borderColor: AppColor.darkGrey,
                    backgroundColor: authCubit.isAcceptTermsLogin
                        ? AppColor.primaryBlue
                        : AppColor.darkGrey,
                    routeName: RouteConst.home,
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
