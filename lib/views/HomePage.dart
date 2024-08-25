import 'package:flutter/material.dart';

import '../viewModel/bloc/ThemeCubit/theme_cubit.dart';
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    var themeCubit = ThemesCubit.get(context);
    return  Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body:  Center(
        child: ElevatedButton(
          onPressed: () {
            themeCubit.toggleTheme();
          },
          child: const Text('Toggle Theme'),
        )
      ),);
  }
}
