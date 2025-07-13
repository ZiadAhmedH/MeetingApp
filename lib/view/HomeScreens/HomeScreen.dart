import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:meeting_app/view/HomeScreens/HomeSections/AppBar_Section/AppBarHomeSection.dart';
import 'package:meeting_app/viewModel/bloc/NavigationCubit/navigation_cubit.dart';
import 'package:meeting_app/viewModel/bloc/ProfileCubit/profile_cubit.dart';

import 'HomeSections/DownBar_Section/FloatActionSection.dart';
import 'HomeSections/DownBar_Section/NavigationSection.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final navigationCubit = NavigationCubit.get(context);

    return Scaffold(
      body: Column(
        children: [
          BlocBuilder<ProfileCubit, ProfileState>(
            bloc: ProfileCubit.get(context)..getUserInfo(),
            builder: (context, state) {
              return const AppBarHomeSection();
            },
          ),
          BlocBuilder<NavigationCubit, NavigationState>(
            builder: (context, state) {
              return Expanded(
                child: PageView(
                  controller: navigationCubit.pageController,
                  onPageChanged: navigationCubit.onPageChanged,
                  children: navigationCubit.pages,
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: const FloatingActionSection(),
      floatingActionButtonLocation: ExpandableFab.location,
      bottomNavigationBar: NavigationSection(),
    );
  }
}
