import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meeting_app/utils/ThemeExtension.dart';
import 'package:meeting_app/viewModel/bloc/ProfileCubit/profile_cubit.dart';
import '../../../model/components/CustomText.dart';
import '../../../utils/AppColor.dart';
import 'AppBar_Section/AppBarHomeSection.dart';
import 'AppBar_Section/NavBar.dart';

class MainHomeSection extends StatelessWidget {
  const MainHomeSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      bloc: ProfileCubit.get(context)..getUserInfoFire(),
      builder: (context, state) {
        return Column(
          children: [


            const AppBarHomeSection(),
            const MeetingSection(),

            const Divider(color: AppColor.darkGrey, thickness: 1),

            // Add any additional content here
            Expanded(
              child: Container(
                  color: context.primaryBackgroundColor,
                  child: Column(
                    children: [
                      const SizedBox(height: 100),
                      Center(
                        child: Column(
                          children: [
                            Image.asset(
                              "assets/images/people.png", width: 250,),
                            CustomText(
                              text: 'No Meeting Scheduled',
                              fontSize: 20,
                              fontWeight: FontWeight.normal,
                              color: context.thirdTextColor,
                              fontFamily: 'Gilroy',
                            ),
                          ],
                        ),
                      ),

                    ],
                  )
              ),
            ),
            const Divider(color: AppColor.darkGrey, thickness: 1),

          ],
        );
      },
    );
  }
}
