
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:meeting_app/Routeres/RouterContstants.dart';
import 'package:meeting_app/model/components/CustomBtn.dart';
import 'package:meeting_app/model/components/CustomBtnRouter.dart';
import 'package:meeting_app/model/components/CustomRadio.dart';
import 'package:meeting_app/model/components/CustomText.dart';
import 'package:meeting_app/model/components/TextFormFeild.dart';
import 'package:meeting_app/utils/AppColor.dart';
import 'package:meeting_app/utils/ThemeExtension.dart';
import 'package:meeting_app/viewModel/bloc/AuthCubit/auth_cubit.dart';
import 'package:meeting_app/views/AuthScreens/LoginSection/loginSection.dart';
import 'package:meeting_app/views/AuthScreens/SignUpSection/userInfoSection/AcceptTermsSection.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var authCubit = AuthCubit.get(context);

    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {},
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
                          authCubit.acceptTerms();
                        },
                        isAcceptTerms: authCubit.isAcceptTerms,
                      ),
                    ],
                  ),
                ),
                CustomButton(
                    borderColor: AppColor.darkGrey,
                    backgroundColor: authCubit.isAcceptTerms
                        ? AppColor.primaryBlue
                        : AppColor.darkGrey,
                    textColor: AppColor.white,
                    isClickable: authCubit.isAcceptTerms? 1 : 0,
                    onTap: () {
                      if (authCubit.loginKey.currentState!.validate()) {
                        authCubit.fireAuthLogin().then((value) {
                          context.pushReplacementNamed(RouteConst.home);
                        });
                      }
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
