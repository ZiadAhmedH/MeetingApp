import 'package:fancy_password_field/fancy_password_field.dart';
import 'package:flutter/material.dart';
import 'package:meeting_app/utils/RegexConst.dart';
import '../../../model/components/CustomText.dart';
import '../../../model/components/TextFormFeild.dart';
import '../../../utils/AppColor.dart';
import '../../../viewModel/bloc/AuthCubit/auth_cubit.dart';
class PasswordScreen extends StatelessWidget {
  const PasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var authCubit = AuthCubit.get(context);
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

                  FancyPasswordField(
                    decoration: InputDecoration(
                      hintText: 'Enter your password',
                      hintStyle: const TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: AppColor.lightBlack, // Dark background color
                      contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: const BorderSide(
                          color: AppColor.grey,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: const BorderSide(
                            color: AppColor.grey
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: const BorderSide(
                          color: Colors.blue,
                        ),
                      ),
                    ),
                    style: const TextStyle(color: AppColor.white), // Text color
                    controller: authCubit.passwordController,
                    validationRules: {
                      DigitValidationRule(),
                      UppercaseValidationRule(),
                      LowercaseValidationRule(),
                      SpecialCharacterValidationRule(),
                      MinCharactersValidationRule(6),
                      MaxCharactersValidationRule(12),
                    },

                  ),
                const SizedBox(
                  height: 20,
                ),
                  CustomTextFormField(
                    hintText: 'Enter your password',
                    controller: authCubit.confirmPasswordController,
                    obscureText: false,
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
          ],
        ),
      ),
    );
  }
}
