import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meeting_app/model/components/TextFormFeild.dart';
import 'package:meeting_app/utils/AppColor.dart';
import 'package:meeting_app/utils/RegexConst.dart';
import 'package:meeting_app/utils/ThemeExtension.dart';
import 'package:meeting_app/viewModel/bloc/AuthCubit/auth_cubit.dart';

class LoginSection extends StatelessWidget {
  const LoginSection({super.key});

  @override
  Widget build(BuildContext context) {
    var authCubit = AuthCubit.get(context);

    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        return Form(
          key: authCubit.loginKey,
          child: Column(
            children: [
              CustomTextFormField(
                hintText: 'Enter your email address',
                controller: authCubit.loginEmail,
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
                icon: Icon(
                  Icons.meeting_room,
                  color: context.primaryTextColor,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              CustomTextFormField(
                  hintText: 'Enter your password',
                  controller: authCubit.loginPassword,
                  obscureText: authCubit.isPassWordShowed,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your password';
                    }
                    if (value.length < 8) {
                      return 'Password must have at least 8 characters';
                    }
                    return null;
                  },
                  icon: InkWell(
                    onTap: () => authCubit.showPassword(),
                    child: Icon(
                      authCubit.isPassWordShowed
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: AppColor.lightGrey,
                    ),
                  )),
            ],
          ),
        );
      },
    );
  }
}
