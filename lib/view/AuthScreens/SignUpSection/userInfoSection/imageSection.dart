import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../utils/AppColor.dart';
import '../../../../viewModel/bloc/AuthCubit/auth_cubit.dart';
import '../../../../viewModel/bloc/ProfileCubit/profile_cubit.dart';

class ImageSection extends StatelessWidget {
  const ImageSection({super.key});

  @override
  Widget build(BuildContext context) {
    var profileCubit = ProfileCubit.get(context);
    var authCubit = AuthCubit.get(context);
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        return SizedBox(
          child: InkWell(
            onTap: () {
              profileCubit.pickImageFromGallery(email:authCubit.signUpEmail.text , uid: authCubit.currentUid);

            },
            child: CircleAvatar(
              radius: 50,
              backgroundColor: AppColor.grey,
              child: ProfileCubit.image == null
                  ? const Icon(
                Icons.person,
                size: 50,
                color: AppColor.white,
              )
                  : ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Image.file(
                  File(ProfileCubit.image!.path),
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
