import 'package:flutter/material.dart';
import 'package:meeting_app/utils/AppColor.dart';

class CustomTextFormField extends StatelessWidget {
  final String? hintText;
  final TextEditingController? controller;
  final bool obscureText;
  final String? Function(String?)? validator;
  final Function(String)? onChanged;
  Icon icon;
  final bool readOnly;
  final TextInputType? keyboardType;


  CustomTextFormField({
    super.key,
    required this.hintText,
    this.controller,
    this.obscureText = false,
    this.keyboardType, // Optional and nullable
    this.validator,
    this.readOnly = false,
    this.onChanged,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
       readOnly: readOnly,
      controller: controller,
      obscureText: obscureText,
      validator: validator,
      onChanged: onChanged,
      keyboardType: keyboardType ,
      decoration: InputDecoration(
        suffixIcon: icon ,
        hintText: hintText,
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
    );
  }
}