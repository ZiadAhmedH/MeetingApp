import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:meeting_app/viewModel/bloc/NavigationCubit/navigation_cubit.dart';

import 'HomeSections/DownBar_Section/FloatActionSection.dart';
import 'HomeSections/DownBar_Section/NavigationSection.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var navigationCubit = NavigationCubit.get(context);
    return BlocConsumer<NavigationCubit, NavigationState>(
      listener: (context, state) {

      },
      builder: (context, state) {
        return Scaffold(
          body: navigationCubit.pages[navigationCubit.currentIndex],
          floatingActionButton: const FloatingActionSection(),
          floatingActionButtonLocation: ExpandableFab.location,
          bottomNavigationBar:  NavigationSection(),
        );
      },
    );
  }
}
