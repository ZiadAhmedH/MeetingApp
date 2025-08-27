import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:meeting_app/core/services/auth/state_user_service.dart';
import 'package:meeting_app/model/Models/UserModel.dart';
import 'package:meeting_app/core/components/CustomBtn.dart';
import 'package:meeting_app/core/components/CustomText.dart';
import 'package:meeting_app/core/components/TextFormFeild.dart';
import 'package:meeting_app/core/utils/AppColor.dart';
import 'package:meeting_app/core/utils/ThemeExtension.dart';
import 'package:meeting_app/view/HomeScreens/FriendRequestScreen/friendRequestView.dart';
import 'package:meeting_app/viewModel/bloc/ProfileCubit/profile_cubit.dart';

class ProfileBodyView extends StatelessWidget {
  final UserModel user;

  const ProfileBodyView({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final cubit = ProfileCubit.get(context);

    return Scaffold(
      body: SafeArea(
        child: BlocListener<ProfileCubit, ProfileState>(
          listener: (context, state) {
            if (state is UserInfoUpdatedSuccessfully) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('✅ Profile updated')),
              );
            } else if (state is UserInfoUpdateError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          child: BlocBuilder<ProfileCubit, ProfileState>(
            builder: (context, state) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back),
                          onPressed: () => Navigator.pop(context),
                        ),
                        const Spacer(),
                        IconButton(
                          icon: FaIcon(FontAwesomeIcons.userPlus),
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) => FriendRequestsView(),
                            ));
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: cubit.image != null
                              ? FileImage(File(cubit.image!.path))
                              : cubit.User?.profileImage != null
                                  ? NetworkImage(cubit.User!.profileImage!)
                                      as ImageProvider
                                  : null,
                          child: (cubit.image == null &&
                                  cubit.User?.profileImage == null)
                              ? const Icon(Icons.person, size: 50)
                              : null,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 4,
                          child: GestureDetector(
                            onTap: () async {
                              await cubit.pickImageFromGallery(
                                email: user.email,
                                uid: user.uid,
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: const BoxDecoration(
                                color: Colors.orange,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.edit,
                                  size: 16, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    CustomText(
                      text: user.email,
                      fontFamily: "Gilroy",
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: context.thirdTextColor,
                    ),

                    const SizedBox(height: 10),

                    CustomTextFormField(
                      hintText: "First Name",
                      controller: ProfileCubit.firstName,
                      icon: const Icon(Icons.person_outline),
                    ),
                    const SizedBox(height: 15),
                    CustomTextFormField(
                      hintText: "Last Name",
                      controller: ProfileCubit.lastName,
                      icon: const Icon(Icons.person_outline),
                    ),
                    const SizedBox(height: 15),
                    CustomTextFormField(
                      hintText: "Location",
                      controller: ProfileCubit.userLocation,
                      icon: const Icon(Icons.location_on_outlined),
                    ),
                    const SizedBox(height: 15),
                    CustomTextFormField(
                      hintText: "Job Title",
                      icon: const Icon(Icons.work_outline),
                      controller: ProfileCubit.jobtitle,
                      readOnly: true,
                    ),
                    const SizedBox(height: 25),
                    CustomButton(
                      text: state is LoadingUserInfoState
                          ? LoadingAnimationWidget.progressiveDots(
                              color: AppColor.white, size: 20)
                          : const Text(
                              "Update Profile",
                              style: TextStyle(
                                color: AppColor.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                      onTap: () {
                        if (!cubit.hasChanges()) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  '⚠ Please change something before updating.'),
                              backgroundColor: Colors.orange,
                            ),
                          );
                          return;
                        }

                        cubit.updateUserInfo(
                          username:
                              "${ProfileCubit.firstName.text.trim()} ${ProfileCubit.lastName.text.trim()}",
                          uid: user.uid,
                          location: ProfileCubit.userLocation.text.trim(),
                        );
                      },
                      isClickable: 1,
                      backgroundColor: AppColor.blueAccent,
                      textColor: AppColor.white,
                      borderColor: AppColor.blueAccent,
                    ),
                    const Spacer(),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColor.blueAccent,
                          side: const BorderSide(color: AppColor.blueAccent),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text("Logout"),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
