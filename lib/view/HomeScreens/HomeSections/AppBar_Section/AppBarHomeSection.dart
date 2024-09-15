import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meeting_app/utils/ThemeExtension.dart';
import 'package:meeting_app/view/HomeScreens/HomeSections/AppBar_Section/userImageCircular.dart';
import 'package:meeting_app/viewModel/data/SharedKeys.dart';
import 'package:meeting_app/viewModel/data/SharedPrefrences.dart';

import '../../../../model/components/CustomText.dart';
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
        SizedBox(height: MediaQuery.of(context).size.height * 0.05,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [

            Row(
              children: [
                 UserImageCircular(),
                CustomText(text:"Meeting ",fontFamily: 'Gilory',fontWeight: FontWeight.bold,fontSize: 25,color: context.thirdTextColor, ),
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
                  onPressed: () {},
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
