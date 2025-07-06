import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meeting_app/Routers/RouterContstants.dart';
import 'package:meeting_app/model/components/CustomBtn.dart';
import 'package:meeting_app/utils/ThemeExtension.dart';
import 'package:meeting_app/view/AuthScreens/SignUpSection/userInfoSection/profileSection.dart';

import '../../../../model/components/CustomText.dart';
import '../../../../utils/AppColor.dart';
import '../../../../viewModel/bloc/AuthCubit/auth_cubit.dart';
import '../../../../viewModel/bloc/ProfileCubit/profile_cubit.dart';
import 'imageSection.dart';

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
          backgroundColor: context.primaryBackgroundColor,
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
                          color: context.thirdTextColor,
                          fontSize: screenWidth * 0.05,
                        ),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    const ImageSection(),
                    SizedBox(height: screenHeight * 0.02),
                    const ProfileInputSection(),
                  ],
                ),
                SizedBox(height: screenHeight * 0.3),
                Padding(
                  padding: EdgeInsets.only(bottom: screenHeight * 0.02),

                  // add loading animation

                  child: BlocConsumer<AuthCubit, AuthState>(
  listener: (context, state) {
    if (state is SuccessRegisterState) {
      // Navigate safely
      Navigator.pushNamedAndRemoveUntil(
        context,
        RouteConst.signMain,
        (route) => false,
      );

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Registration Successful"),
          backgroundColor: AppColor.green,
        ),
      );
    }

    if (state is ErrorRegisterState) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.message),
          backgroundColor: Colors.red,
        ),
      );
    }
  },
  builder: (context, state) {
    if (state is LoadingRegisterState) {
      return const Center(child: CircularProgressIndicator());
    }

    return CustomButton(
      borderColor: AppColor.grey,
      backgroundColor: profileCubit.isAcceptTerms
          ? AppColor.primaryBlue
          : AppColor.grey,
      text: "Create Account",
      isClickable: profileCubit.isAcceptTerms ? 1 : 0,
      textColor: AppColor.white,
      onTap: () async {
        if (profileCubit.profileKey.currentState!.validate()) {
          await authCubit.signUpWithFire();
          if (profileCubit.image != null) {
            await profileCubit.uploadPImage(
              image: profileCubit.image!,
              email: authCubit.signUpEmail.text,
              uid: authCubit.currentUid,
            );
          }
          authCubit.clearControllers();
          profileCubit.disposeController();
        }
      },
    );
  },
)
),
              ],
            ),
          ),
        );
      },
    );
  }
}
