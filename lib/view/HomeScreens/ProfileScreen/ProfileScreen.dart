import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meeting_app/model/Models/UserModel.dart';
import 'package:meeting_app/view/HomeScreens/ProfileScreen/widgets/profile_body_view.dart';
import 'package:meeting_app/viewModel/bloc/ProfileCubit/profile_cubit.dart';

class ProfileView extends StatelessWidget {
  final UserModel user;

  const ProfileView({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProfileCubit()..getUserInfo(),
      child: ProfileBodyView(user: user),
    );
  }
}
