import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meeting_app/view/HomeScreens/HomeBodyVeiw.dart';
import 'package:meeting_app/view/searchView/widgets/search_body_view.dart';
import 'package:meeting_app/viewModel/bloc/NavigationCubit/navigation_cubit.dart';
import 'package:meeting_app/viewModel/bloc/ProfileCubit/profile_cubit.dart';

class HomeVeiw extends StatelessWidget {
  const HomeVeiw({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => NavigationCubit(),
        child: const HomeBodyView(),
      ),
    );
  }
}
