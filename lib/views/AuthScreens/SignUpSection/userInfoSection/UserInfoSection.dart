import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:meeting_app/Routeres/RouterContstants.dart';
import 'package:meeting_app/model/components/CustomBtn.dart';
import 'package:meeting_app/model/components/TextFormFeild.dart';
import 'package:meeting_app/views/AuthScreens/SignUpSection/userInfoSection/imageSection.dart';
import 'package:meeting_app/views/AuthScreens/SignUpSection/userInfoSection/profileSection.dart';
import '../../../../model/components/CustomText.dart';
import '../../../../utils/AppColor.dart';
import '../../../../viewModel/bloc/AuthCubit/auth_cubit.dart';
import '../../../../viewModel/bloc/ProfileCubit/profile_cubit.dart';
import 'AcceptTermsSection.dart';
import 'dropDownSection.dart';

class UserInfoSection extends StatelessWidget {
  const UserInfoSection({super.key});

  @override
  Widget build(BuildContext context) {
    var profileCubit = ProfileCubit.get(context);
    var authCubit = AuthCubit.get(context);
    // Get screen dimensions
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;

    return BlocBuilder<ProfileCubit, ProfileState>(
      bloc: profileCubit..getCountry(),
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColor.primaryColor,
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        CustomText(
                          text: 'Create your Profile',
                          fontFamily: 'Gilroy',
                          fontWeight: FontWeight.bold,
                          color: AppColor.white,
                          fontSize: screenWidth * 0.05, // 5% of screen width
                        ),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.02), // 2% of screen height
                    const ImageSection(),
                    SizedBox(height: screenHeight * 0.02), // 2% of screen height
                    const ProfileInputSection(),
                  ],
                ),
                SizedBox(height: screenHeight * 0.3), // 30% of screen height
                Padding(
                  padding: EdgeInsets.only(bottom: screenHeight * 0.02), // 2% of screen height
                  child: CustomButton(
                    borderColor: AppColor.grey,
                    backgroundColor: profileCubit.isAcceptTerms ? AppColor.primaryBlue : AppColor.grey,
                    text: "Create Account",
                    isClickable: profileCubit.isAcceptTerms ? 1 : 0,
                    onTap: () {
                      if(profileCubit.profileKey.currentState!.validate()) {
                         authCubit.signUpWithFire().then((value) {

                           context.pushReplacement(RouteConst.signMain);
                         }).catchError((e) {
                           ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
                         });
                      }
                    },
                    textColor: AppColor.white,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
