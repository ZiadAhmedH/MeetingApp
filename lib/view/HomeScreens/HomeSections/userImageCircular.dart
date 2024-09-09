import 'package:flutter/material.dart';

import '../../../utils/AppColor.dart';
import '../../../viewModel/bloc/ProfileCubit/profile_cubit.dart';
class UserImageCircular extends StatelessWidget {
  const UserImageCircular({super.key});

  @override
  Widget build(BuildContext context) {
    var profileCubit = ProfileCubit.get(context);

    return Container(
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColor.grey,
        borderRadius: BorderRadius.circular(20),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: profileCubit.User?.profileImage != null
            ? Image.network(
          profileCubit.User!.profileImage!,
          width: 30,
          height: 30,
          fit: BoxFit.cover,
        )
            : const Icon(
          Icons.person,
          size: 40,
          color: AppColor.white,
        ),
      ),
    );
  }
}
