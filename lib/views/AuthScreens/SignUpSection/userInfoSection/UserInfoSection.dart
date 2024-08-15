import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meeting_app/views/AuthScreens/SignUpSection/userInfoSection/imageSection.dart';

import '../../../../model/components/CustomText.dart';
import '../../../../utils/AppColor.dart';
import '../../../../viewModel/bloc/ProfileCubit/profile_cubit.dart';

class UserInfoSection extends StatelessWidget {
  const UserInfoSection({super.key});

  @override
  Widget build(BuildContext context) {
    var profileCubit = ProfileCubit.get(context);
    return Scaffold(
      backgroundColor: AppColor.primaryColor,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 50,
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CustomText(
                        text: 'Enter User Information',
                        fontFamily: 'Gilroy',
                        fontWeight: FontWeight.bold,
                        color: AppColor.white,
                        fontSize: 20,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),

                  BlocBuilder(
                       bloc: profileCubit,
                      builder: (context, state) {
                    return ImageSection();
                  }),

                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}
