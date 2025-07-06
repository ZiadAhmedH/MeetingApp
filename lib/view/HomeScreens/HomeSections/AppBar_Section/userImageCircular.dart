import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:meeting_app/Routers/RouterContstants.dart';

import '../../../../utils/AppColor.dart';
import '../../../../viewModel/bloc/ProfileCubit/profile_cubit.dart';

class UserImageCircular extends StatelessWidget {
  const UserImageCircular({super.key});

  @override
  Widget build(BuildContext context) {
    var profileCubit = ProfileCubit.get(context);
    return InkWell(
      borderRadius: BorderRadius.circular(50),
      onTap: () {
        Navigator.pushNamed(context, RouteConst.profile ,
            arguments: profileCubit.User);
      },
      child: Container(
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColor.grey,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppColor.lightGrey,
            width: 2,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: profileCubit.User?.profileImage != null
              ? CachedNetworkImage(
                  imageUrl: profileCubit.User!.profileImage!,
                  width: 30,
                  height: 30,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Center(
                    child: LoadingAnimationWidget.hexagonDots(
                      color: AppColor.blue,
                      size: 30,
                    ),
                  ),
                  errorWidget: (context, url, error) => const Icon(
                    Icons.error,
                    size: 40,
                    color: AppColor.white,
                  ),
                )
              : const Icon(
                  Icons.person,
                  size: 30,
                  color: AppColor.white,
                ),
        ),
      ),
    );
  }
}
