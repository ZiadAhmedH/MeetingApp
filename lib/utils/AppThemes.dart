import 'package:flutter/material.dart';
import 'package:meeting_app/utils/AppColor.dart';

class AppThemes {
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: AppColor.lightWhite,
    scaffoldBackgroundColor: AppColor.lightWhite,
    appBarTheme: const AppBarTheme(
      color: Colors.blue,
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(color: AppColor.black),
    ),
    textTheme:  TextTheme(
      bodyText1:  TextStyle(color: AppColor.white),
      bodyText2:  TextStyle(color: AppColor.primaryBlue),
      bodyMedium:  TextStyle(color: AppColor.black),
    ),
    buttonTheme: const ButtonThemeData(
      buttonColor: AppColor.primaryBlue,
      textTheme: ButtonTextTheme.normal,
    ),
    // Add other light theme properties as needed
  );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: AppColor.primaryColor,
    scaffoldBackgroundColor: AppColor.primaryColor,
    appBarTheme: AppBarTheme(
      color: Colors.grey[900],
      iconTheme: const IconThemeData(color: Colors.white),),
    textTheme:  TextTheme(
      bodyText1: TextStyle(color: AppColor.white),
      bodyText2: TextStyle(color: AppColor.white),
      bodyMedium: TextStyle(color: AppColor.white),
    ),
    buttonTheme: const ButtonThemeData(
      buttonColor: AppColor.primaryBlue,
      textTheme: ButtonTextTheme.primary,
    ),
    // Add other dark theme properties as needed
  );
}
