import 'package:flutter/material.dart';

extension ThemeContext on BuildContext {
  Color? get primaryTextColor => Theme.of(this).textTheme.bodyMedium?.color;
  Color? get secondaryTextColor => Theme.of(this).textTheme.bodySmall?.color;
  Color? get thirdTextColor => Theme.of(this).textTheme.bodyLarge?.color;

  Color? get filledColor => Theme.of(this).textTheme.headlineLarge?.color;
  Color? get filledColor2 => Theme.of(this).textTheme.headlineMedium?.color;



  Color get primaryBackgroundColor => Theme.of(this).scaffoldBackgroundColor;
  Color? get primaryButtonColor => Theme.of(this).buttonTheme.colorScheme?.background!;
  Color? get primaryButtonTextColor => Theme.of(this).buttonTheme.colorScheme?.primary!;
  Color? get secondaryButtonColor => Theme.of(this).buttonTheme.colorScheme?.secondary!;
  Color? get primaryIconColor => Theme.of(this).iconTheme.color;
  Color? get primaryAppBarColor => Theme.of(this).appBarTheme.backgroundColor;
}
