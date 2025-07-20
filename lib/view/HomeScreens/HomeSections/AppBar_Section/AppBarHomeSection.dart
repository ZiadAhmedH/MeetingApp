import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:meeting_app/core/Routers/RouterContstants.dart';
import 'package:meeting_app/core/components/CustomBtn.dart';
import 'package:meeting_app/core/utils/AppColor.dart';
import 'package:meeting_app/core/utils/ThemeExtension.dart';
import 'package:meeting_app/view/HomeScreens/HomeSections/AppBar_Section/userImageCircular.dart';
import 'package:meeting_app/viewModel/bloc/AuthCubit/auth_cubit.dart';

import '../../../../core/components/CustomText.dart';
import '../../../../viewModel/bloc/ProfileCubit/profile_cubit.dart';
import '../../../../viewModel/bloc/ThemeCubit/theme_cubit.dart';

class AppBarHomeSection extends StatelessWidget {
  const AppBarHomeSection({super.key});

  @override
  Widget build(BuildContext context) {
    var themeCubit = ThemesCubit.get(context);

    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        return Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    UserImageCircular(),
                    CustomText(
                      text: "Meeting ",
                      fontFamily: 'Gilory',
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                      color: context.thirdTextColor,
                    ),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        themeCubit.toggleTheme();
                      },
                      icon: Icon(
                        Icons.brightness_4_outlined,
                        color: context.thirdTextColor,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              content: CustomText(
                                text: 'Are you sure you want to logout?',
                                color: context.thirdTextColor,
                              ),
                              actions: [
                                CustomButton(
                                    borderColor: AppColor.blueAccent,
                                    backgroundColor: AppColor.blueAccent,
                                    text: CustomText(
                                      text: "Cancel",
                                      color: context.thirdTextColor,
                                    ),
                                    isClickable: 1,
                                    onTap: () {
                                      Navigator.of(context).pop();
                                    },
                                    textColor: AppColor.white),
                                const SizedBox(
                                  height: 10,
                                ),
                                BlocBuilder<AuthCubit, AuthState>(
                                  builder: (context, state) {
                                        
                                        if(state is SuccessLogoutState) {
                                          WidgetsBinding.instance.addPostFrameCallback((_) {
                                            Navigator.pushNamedAndRemoveUntil(context, RouteConst.signMain, (route) => false);
                                          });
                                        }

                                        if (state is ErrorLogoutState) {
                                          WidgetsBinding.instance.addPostFrameCallback((_) {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(content: Text(state.message)),
                                            );
                                          });
                                        }

                                    return CustomButton(
                                        borderColor: AppColor.blueAccent,
                                        backgroundColor: AppColor.blueAccent,
                                        text: state is LoadingLogoutState ? LoadingAnimationWidget.progressiveDots(color:AppColor.lightGrey, size: 50) : CustomText(
                                          text: "ok",
                                          color: context.thirdTextColor,
                                        ),
                                        isClickable: 1,
                                        onTap: () {
                                          AuthCubit.get(context).logout();

                                        },
                                        textColor: AppColor.white);
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                      icon: Icon(
                        Icons.logout,
                        color: context.thirdTextColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
