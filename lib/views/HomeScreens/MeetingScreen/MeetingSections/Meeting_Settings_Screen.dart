import 'package:flutter/material.dart';
import 'package:meeting_app/model/components/CustomBtn.dart';
import 'package:meeting_app/model/components/CustomText.dart';
import 'package:meeting_app/utils/ThemeExtension.dart';
import 'package:meeting_app/views/HomeScreens/MeetingScreen/MeetingScreen.dart';

import '../../../../utils/AppColor.dart';

class MeetingSettings extends StatelessWidget {
  const MeetingSettings({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController meetingIdController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: context.primaryBackgroundColor,
        title: CustomText(
          text: "Meeting Settings",
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
          color: context.thirdTextColor,
        ),
      ),
      body: Container(
        color: context.primaryBackgroundColor,
        child: Center(
            child: Column(
          children: [
            TextField(
              controller: meetingIdController,
              decoration: InputDecoration(
                hintText: "Enter Meeting ID",
                hintStyle: TextStyle(color: context.thirdTextColor),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: AppColor.lightGrey),
                ),
              ),
            ),
            SizedBox(height: 20),
            CustomButton(
                borderColor: AppColor.lightGrey,
                backgroundColor: AppColor.darkGrey,
                textColor: AppColor.white,
                isClickable: 1,
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return MeetingScreen(meetingId:meetingIdController.text ,);
                  }));
                },
                text: "GO TO MEETING")
          ],
        )),
      ),
    );
  }
}
