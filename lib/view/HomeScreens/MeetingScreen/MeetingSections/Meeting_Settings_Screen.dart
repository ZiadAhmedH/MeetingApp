import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meeting_app/core/components/CustomBtn.dart';
import 'package:meeting_app/core/components/CustomText.dart';
import 'package:meeting_app/core/utils/ThemeExtension.dart';
import 'package:meeting_app/view/HomeScreens/MeetingScreen/MeetingScreen.dart';
import 'package:meeting_app/viewModel/bloc/MeetingCubit/meeting_cubit.dart';
import '../../../../core/utils/AppColor.dart';

class MeetingSettings extends StatelessWidget {
  const MeetingSettings({super.key});

  @override
  Widget build(BuildContext context) {
    var meetingCubit = MeetingCubit.get(context)..generateRandomId();

    return BlocBuilder<MeetingCubit, MeetingState>(
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
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CustomText(
                    text: "Meeting ID",
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: context.thirdTextColor,
                  ),
                  const SizedBox(height: 10),
                  CustomText(
                    text: meetingCubit.meetingId,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColor.primaryBlue,
                  ),
                  const SizedBox(height: 20),

                  // Camera toggle
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                        text: "Camera",
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: context.thirdTextColor,
                      ),
                      CupertinoSwitch(
                        value: meetingCubit.isCameraOn,
                        onChanged: (_) => meetingCubit.toggleCamera(),
                        activeTrackColor: AppColor.primaryBlue,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Microphone toggle
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                        text: "Microphone",
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: context.thirdTextColor,
                      ),
                      CupertinoSwitch(
                        value: meetingCubit.isMicrophoneOn,
                        onChanged: (_) => meetingCubit.toggleMicrophone(),
                        activeTrackColor: AppColor.primaryBlue,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Speaker toggle
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                        text: "Speaker",
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: context.thirdTextColor,
                      ),
                      CupertinoSwitch(
                        value: meetingCubit.isSpeakerOn,
                        onChanged: (_) => meetingCubit.toggleSpeaker(),
                        activeTrackColor: AppColor.primaryBlue,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  const CustomText(
                    text: "Meeting Duration",
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: AppColor.primaryBlue,
                  ),
                  const SizedBox(height: 10),
                  const CustomText(
                    text: "60 Minutes",
                    fontSize: 16.0,
                    fontWeight: FontWeight.normal,
                    color: AppColor.primaryBlue,
                  ),
                  const SizedBox(height: 30),

                  // Join Button
                  CustomButton(
                    borderColor: AppColor.lightGrey,
                    backgroundColor: AppColor.darkGrey,
                    textColor: AppColor.white,
                    isClickable: 1,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => MeetingScreen(
                            meetingId: meetingCubit.meetingId,
                            isCameraOn: meetingCubit.isCameraOn,
                            isMicOn: meetingCubit.isMicrophoneOn,
                          ),
                        ),
                      );
                    },
                    text: CustomText(
                      text: "GO TO MEETING",
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: AppColor.white,
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
