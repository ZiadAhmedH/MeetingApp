
import 'package:flutter/material.dart';
import 'package:meeting_app/model/components/TextFormFeild.dart';
import 'package:meeting_app/viewModel/bloc/AuthCubit/auth_cubit.dart';

class LoginSection extends StatelessWidget {
  const LoginSection({super.key});

  @override
  Widget build(BuildContext context) {
    var authCubit = AuthCubit.get(context);

    return  Form(
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
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            CustomTextFormField(
                              hintText: 'Enter your password',
                              controller: authCubit.loginPassword,
                              obscureText: true,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter your password';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      );
  }
}