import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meeting_app/model/Models/UserModel.dart';
import 'package:meeting_app/model/components/TextFormFeild.dart';
import 'package:meeting_app/utils/AppColor.dart';
import 'package:meeting_app/viewModel/bloc/ProfileCubit/profile_cubit.dart';
import 'package:meeting_app/utils/ThemeExtension.dart';
import 'package:meeting_app/viewModel/data/SharedKeys.dart';
import 'package:meeting_app/viewModel/data/SharedPrefrences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileScreen extends StatelessWidget {
  final UserModel? user;

  const ProfileScreen({super.key,required this.user});

  @override
  Widget build(BuildContext context) {
    final cubit = ProfileCubit.get(context);

    return Scaffold(
       backgroundColor: context.primaryBackgroundColor,
      body: SafeArea(
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
                        icon: const Icon(Icons.settings),
                        onPressed: () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  /// Profile Image with edit icon
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: Theme.of(context).primaryColorLight,
                        backgroundImage: cubit.image != null
                            ? FileImage(File(cubit.image!.path))
                            : user?.profileImage != null
                                ? NetworkImage(user!.profileImage!) as ImageProvider<Object>
                                : null,
                        child: (cubit.image == null && user?.profileImage == null)
                            ? const Icon(Icons.person, size: 50, color: Colors.white)
                            : null,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 4,
                        child: GestureDetector(
                          onTap: () {
                            cubit
                                .pickImageFromGallery(
                                  uid: LocalData.getData(key: SharedKey.uid),
                                  email: LocalData.getData(key: SharedKey.email),
                                )
                                .then((_) {
                              if (cubit.image != null) {
                                cubit.uploadPImage(
                                  image: cubit.image!,
                                  email: Supabase.instance.client.auth.currentUser!.email!,
                                  uid: Supabase.instance.client.auth.currentUser!.id,
                                );
                              }
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                              color: AppColor.primaryBlue,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.edit, size: 16, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),
                  const Text("GFXAgency", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                  const Text("UI UX DESIGN", style: TextStyle(color: Colors.grey)),
                  const SizedBox(height: 30),

                  _buildLabel("First Name"),
                  CustomTextFormField(
                    hintText: "First Name",
                    controller: ProfileCubit.firstName,
                    icon: const Icon(Icons.person_outline),
                    readOnly: true,
                  ),
                  const SizedBox(height: 15),

                  _buildLabel("Last Name"),
                  CustomTextFormField(
                    hintText: "Last Name",
                    controller: ProfileCubit.lastName,
                    icon: const Icon(Icons.person_outline),
                    readOnly: true,
                  ),
                  const SizedBox(height: 15),

                  _buildLabel("Location"),
                  CustomTextFormField(
                    hintText: "Location",
                    controller: ProfileCubit.userLocation,
                    icon: const Icon(Icons.location_on_outlined),
                    readOnly: true,
                  ),
                  const SizedBox(height: 15),

                  _buildLabel("Job Title"),
                  CustomTextFormField(
                    hintText: ProfileCubit.currentStatus,
                    icon: const Icon(Icons.work_outline),
                    readOnly: true,
                  ),

                  const Spacer(),

                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColor.primaryBlue,
                        side: const BorderSide(color: AppColor.primaryBlue, width: 2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text("Logout", style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          text,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
