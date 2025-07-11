import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meeting_app/view/searchView/widgets/search_body_view.dart';
import 'package:meeting_app/viewModel/bloc/ProfileCubit/profile_cubit.dart';

class SearchView extends StatelessWidget {
  const SearchView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => ProfileCubit(),
        child: const SearchBodyView(),
      ),
    );
  }
}
