import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meeting_app/Routeres/RouterContstants.dart';
import 'package:meeting_app/model/components/CustomBtn.dart';
import 'package:meeting_app/model/components/CustomText.dart';
import 'package:meeting_app/utils/AppColor.dart';
import 'package:meeting_app/utils/ThemeExtension.dart';
import 'package:meeting_app/viewModel/bloc/AuthCubit/auth_cubit.dart';
import 'package:meeting_app/viewModel/data/SharedKeys.dart';
import 'package:meeting_app/viewModel/data/SharedPrefrences.dart';

import '../SignUpSection/userInfoSection/AcceptTermsSection.dart';
import 'loginSection.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var authCubit = AuthCubit.get(context);

    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        if (state is ErrorLoginState) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          });
        }

       if (state is SuccessLoginState) {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text("Login Successful"),
        backgroundColor: AppColor.green,
      ),
    );

    Navigator.pushNamedAndRemoveUntil(
      context,
      RouteConst.home,
      (route) => false,
    );
    LocalData.setData(key: SharedKey.isLogin, value: true);
  });
}

        

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
                      const SizedBox(
                        height: 50,
                      ),
                      CustomText(
                        text: 'Welcome Back !',
                        fontFamily: 'Gilroy',
                        fontWeight: FontWeight.bold,
                        color: context.thirdTextColor,
                        fontSize: 20,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      CustomText(
                        text: 'Plearse log in to join the meeting hub',
                        fontFamily: 'Gilroy',
                        fontWeight: FontWeight.w200,
                        color: context.thirdTextColor,
                        fontSize: 16,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const LoginSection(),
                      const SizedBox(
                        height: 20,
                      ),
                      AcceptTerms(
                        cubit: authCubit,
                        onTap: () {
                          authCubit.acceptTermsLogin();
                        },
                        isAcceptTerms: authCubit.isAcceptTermsLogin,
                      ),
                    ],
                  ),
                ),
                CustomButton(
                    borderColor: AppColor.lightGrey,
                    backgroundColor: authCubit.isAcceptTermsLogin
                        ? AppColor.primaryBlue
                        : AppColor.darkGrey,
                    textColor: AppColor.white,
                    isClickable: authCubit.isAcceptTermsLogin ? 1 : 0,
                    onTap: () {
                      if (authCubit.loginKey.currentState!.validate()) {authCubit.fireAuthLogin(); }
                    },
                    text: "Next")
              ],
            ),
          ),
        );
      },
    );
  }
}
