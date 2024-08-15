import 'dart:io';

import 'package:flutter/material.dart';

import '../../../../utils/AppColor.dart';
import '../../../../viewModel/bloc/ProfileCubit/profile_cubit.dart';

class ImageSection extends StatelessWidget {
  const ImageSection({super.key});

  @override
  Widget build(BuildContext context) {
    var profileCubit = ProfileCubit.get(context);
    return SizedBox(
      child: InkWell(
        onTap: () {
          profileCubit.pickImageFromGallery();
        },
        child: CircleAvatar(
          radius: 50,
          backgroundColor: AppColor.grey,
          child: profileCubit.image == null
              ? const Icon(
                  Icons.person,
                  size: 50,
                  color: AppColor.white,
                )
              : ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Image.file(
                    File(profileCubit.image!.path),
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
        ),
      ),
    );
  }
}
