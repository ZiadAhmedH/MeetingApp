import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:meeting_app/model/components/CustomText.dart';
import 'package:meeting_app/utils/ThemeExtension.dart';
import 'package:meeting_app/viewModel/bloc/ProfileCubit/profile_cubit.dart';
import 'package:meeting_app/viewModel/data/SharedKeys.dart';
import 'package:meeting_app/viewModel/data/SharedPrefrences.dart';
import 'package:meeting_app/views/HomeScreen/meetingSection/MeetingSection.dart';

import '../../../viewModel/bloc/ThemeCubit/theme_cubit.dart';
import '../../utils/AppColor.dart';
import '../../viewModel/bloc/AuthCubit/auth_cubit.dart';
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    var themeCubit = ThemesCubit.get(context);
    var profileCubit = ProfileCubit.get(context);
    var authCubit = AuthCubit.get(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: context.primaryBackgroundColor,

        title: CustomText(
          text: 'Meeting',
          fontFamily: 'Gilroy',
          fontWeight: FontWeight.w500,
          color: context.thirdTextColor,
          fontSize: 25,
        ),

        leading: CircleAvatar(
          radius: 20,
          backgroundColor: AppColor.grey,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child:  profileCubit.User?.profileImage != null ?  Image.network(
              profileCubit.User!.profileImage!,
              width: 30,
              height: 30,
              fit: BoxFit.cover,
            ) : const Icon(
              Icons.person,
              size: 40,
              color: AppColor.white,
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
            },
            icon: Icon(
              Icons.brightness_4,
              color: context.thirdTextColor,
            ),
          ),
          IconButton(
            onPressed: () {
            },
            icon: Icon(
              Icons.logout,
              color: context.thirdTextColor,
            ),
          ),
        ],
      ),


      body: Column(
        children: [

           // Meeting Buttons and Functions

          MeetingSection(),

          Divider(color: AppColor.grey,thickness: 1,)

        ],

      ),

      bottomNavigationBar: BottomNavigationBar(
        elevation: 1,
        backgroundColor: context.primaryBackgroundColor,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.video),
            label: 'Meeting'
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
        selectedItemColor: context.primaryTextColor,
        unselectedItemColor: context.thirdTextColor,
        onTap: (index) {
          if (index == 0) {
          } else if (index == 1) {
          } else if (index == 2) {
          }
        },
      ),
    ) ;
  }
}
