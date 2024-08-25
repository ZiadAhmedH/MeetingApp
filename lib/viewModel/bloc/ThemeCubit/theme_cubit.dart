
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../utils/AppThemes.dart';

class ThemesCubit extends Cubit<ThemeData> {
  ThemesCubit() : super(AppThemes.darkTheme) {
    _getThemeFromPrefs();
  }

  static ThemesCubit get(context) => BlocProvider.of(context);


  Future<void> _saveThemeToPrefs({required Brightness brightness}) async {
    final themeIndex = brightness == Brightness.light ? 0 : 1;
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setInt('theme', themeIndex);
  }

  Future<void> _getThemeFromPrefs() async {
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final savedThemeIndex = sharedPreferences.getInt('theme') ?? 0;
    final savedTheme = savedThemeIndex == 0 ? AppThemes.lightTheme : AppThemes.darkTheme;
    emit(savedTheme);
  }

  void toggleTheme() {
    emit(state.brightness == Brightness.light ? AppThemes.darkTheme : AppThemes.lightTheme);
    _saveThemeToPrefs(brightness: state.brightness);
  }
}