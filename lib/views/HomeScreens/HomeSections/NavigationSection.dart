import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:meeting_app/utils/AppColor.dart';
import 'package:meeting_app/utils/ThemeExtension.dart';

import '../../../viewModel/bloc/NavigationCubit/navigation_cubit.dart';
class NavigationSection extends StatelessWidget {
  const NavigationSection({super.key});

  @override
  Widget build(BuildContext context) {

    var navigationCubit = NavigationCubit.get(context);
    return BottomNavigationBar(
      elevation: 1,
      useLegacyColorScheme: true,
      backgroundColor: context.primaryBackgroundColor,
      currentIndex: navigationCubit.currentIndex,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(FontAwesomeIcons.video),
          label: 'Meeting',
        ),
        BottomNavigationBarItem(
          icon: Icon(FontAwesomeIcons.comments),
          label: 'Chats',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
      selectedItemColor: AppColor.primaryBlue,
      unselectedItemColor: context.thirdTextColor,
      onTap: (index) {
        navigationCubit.changeIndex(index);
      },
    );
  }
}
