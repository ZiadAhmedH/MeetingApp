import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meeting_app/model/components/CustomBtn.dart';
import 'package:meeting_app/model/components/CustomText.dart';
import 'package:meeting_app/utils/ThemeExtension.dart';
import 'package:meeting_app/viewModel/bloc/MeetingCubit/meeting_cubit.dart';
import '../../../../utils/AppColor.dart';
import '../MeetingScreen.dart';

class MeetingSettings extends StatelessWidget {
  const MeetingSettings({super.key});

  @override
  Widget build(BuildContext context) {
    var meetingCubit = MeetingCubit.get(context);
    return BlocBuilder<MeetingCubit, MeetingState>(
      bloc: MeetingCubit.get(context)..generateRandomId(),
      builder: (context, state) {
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
            CustomText(
                text: "Enter Meeting ID",
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: context.thirdTextColor),
            CustomText(
                text: meetingCubit.meetingId,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColor.primaryBlue),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                    text: "Camera",
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: context.thirdTextColor),
                CupertinoSwitch(
                  value: meetingCubit.isCameraOn,
                  onChanged: (value) {
                    meetingCubit.toggleCamera();
                  },
                  activeColor: AppColor.primaryBlue,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                    text: "Microphone",
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: context.thirdTextColor),
                CupertinoSwitch(
                  value: meetingCubit.isMicrophoneOn,
                  onChanged: (value) {
                    meetingCubit.toggleMicrophone();
                  } ,
                  activeColor: AppColor.primaryBlue,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                    text: "Speaker",
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: context.thirdTextColor),
                CupertinoSwitch(
                  value: meetingCubit.isSpeakerOn,
                  onChanged: (value) {
                    meetingCubit.toggleSpeaker();
                  },
                  activeColor: AppColor.primaryBlue,
                ),
              ],
            ),

            CustomText(text: "Meeting Duration", fontSize: 20.0, fontWeight: FontWeight.bold, color: context.thirdTextColor),

            // SizedBox(
            //   height: MediaQuery.of(context).size.height / 10,
            //   width: MediaQuery.of(context).size.width - 80,
            //   child: Row(
            //     mainAxisSize: MainAxisSize.min,
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: [
            //       Expanded(
            //         child: ListView.separated(
            //           scrollDirection: Axis.horizontal,
            //             itemCount: meetingCubit.durationList.length,
            //             itemBuilder: (context, index) {
            //           return TextSelectable(text: meetingCubit.durationList[index], borderColor:meetingCubit.selectedDuration == index ? AppColor.primaryBlue : AppColor.lightGrey, index: index);
            //         },
            //         separatorBuilder: (context, index) {
            //           return const SizedBox(width: 10,);
            //         },
            //         ),
            //       ),
            //     ],
            //   ),
            // ),

            const CustomText(text: "60 Minutes", fontSize: 20.0, fontWeight: FontWeight.bold, color: AppColor.primaryBlue),

            const SizedBox(height: 20),

            CustomButton(
                borderColor: AppColor.lightGrey,
                backgroundColor: AppColor.darkGrey,
                textColor: AppColor.white,
                isClickable: 1,
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) {
                    return MeetingScreen(
                      meetingId: meetingCubit.meetingId,
                    );
                  }));
                },
                text: "GO TO MEETING")
                          ],
                        ),
          ),
        );
      },
    );
  }
}
