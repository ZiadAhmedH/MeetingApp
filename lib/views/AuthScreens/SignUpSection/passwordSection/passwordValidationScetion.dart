import 'package:fancy_password_field/fancy_password_field.dart';
import 'package:flutter/material.dart';

import '../../../../utils/AppColor.dart';
import '../../../../viewModel/bloc/AuthCubit/auth_cubit.dart';
class PasswordValidationSection extends StatelessWidget {
  const PasswordValidationSection({super.key});

  @override
  Widget build(BuildContext context) {
    var authCubit = AuthCubit.get(context);
    return SizedBox(
      width: 400,
      child: FancyPasswordField(
        style: const TextStyle(color: AppColor.white),
        decoration: InputDecoration(
          hintText: 'Enter your password',
          hintStyle: const TextStyle(color: AppColor.white),
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
        controller: authCubit.passwordController,
        validationRules: {
          DigitValidationRule(),
          UppercaseValidationRule(),
          LowercaseValidationRule(),
          SpecialCharacterValidationRule(),
          MinCharactersValidationRule(8),
        },
        validationRuleBuilder: (rules, value) {
          if (value.isEmpty) {
            return const SizedBox.shrink();
          }
          authCubit.passwordStrength = rules.every((rule) => rule.validate(value));
          print("password STTTTTTT : ${authCubit.passwordStrength}");
          return ListView(
            shrinkWrap: true,
            children: rules
                .map((rule) => rule.validate(value)  ? Row(
                children: [
                  const Icon(
                    Icons.check,
                    color: Colors.green,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    rule.name,
                    style: const TextStyle(
                      color: Colors.green,
                    ),
                  ),
                ],
              ) : Row(
                children: [
                  const Icon(
                    Icons.close,
                    color: Colors.red,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    rule.name,
                    style: const TextStyle(
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            )
                .toList(),
          );

        },
      ),
    );
  }
}
