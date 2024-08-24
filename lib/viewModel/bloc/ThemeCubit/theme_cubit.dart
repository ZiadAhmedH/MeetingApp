import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../utils/AppColor.dart';

class ThemeCubit extends Cubit<ThemeData> {
  ThemeCubit() : super(darkTheme);

  final ThemeData currentTheme = darkTheme ;

  static final lightTheme = ThemeData(
    primaryColor: AppColor.white,
    brightness: Brightness.light,
    textTheme: const TextTheme(
      bodyText1: TextStyle(fontSize: 16.0, color: Colors.black),
    ),
  );

  static final darkTheme = ThemeData(
    primaryColor: AppColor.primaryColor,
    brightness: Brightness.dark,
    textTheme: const TextTheme(
      bodyText1: TextStyle(fontSize: 16.0, color: Colors.white),
    ),
  );

  void toggleTheme() {


  }
}
