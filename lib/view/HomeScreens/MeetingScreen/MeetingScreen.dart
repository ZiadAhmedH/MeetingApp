import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_video_conference/zego_uikit_prebuilt_video_conference.dart';

import '../../../utils/ZigoCloudConst.dart';
import '../../../viewModel/bloc/MeetingCubit/meeting_cubit.dart';
import '../../../viewModel/bloc/ProfileCubit/profile_cubit.dart';
import '../../../viewModel/data/SharedKeys.dart';
import '../../../viewModel/data/SharedPrefrences.dart';
class MeetingScreen extends StatelessWidget {
  final String meetingId;

  const MeetingScreen({super.key, required this.meetingId});

  @override
  Widget build(BuildContext context) {
    var profileCubit = ProfileCubit.get(context);
    var meetingCubit = MeetingCubit.get(context);
    return SafeArea(
      child: ZegoUIKitPrebuiltVideoConference(
        appID: ZigoCloud.ZEGO_APP_ID,
        appSign: ZigoCloud.ZEGO_APP_SIGN,
        userID:LocalData.getData(key: SharedKey.uid),
        userName: LocalData.getData(key: SharedKey.email),
        conferenceID: meetingId,
        config: ZegoUIKitPrebuiltVideoConferenceConfig(
          turnOnCameraWhenJoining: meetingCubit.isCameraOn,
          turnOnMicrophoneWhenJoining: meetingCubit.isMicrophoneOn,
          useSpeakerWhenJoining: meetingCubit.isSpeakerOn,
          leaveConfirmDialogInfo: ZegoLeaveConfirmDialogInfo(
            title: "Leave the Meeting?",
            message: "Are you sure to leave the meeting ?",
            cancelButtonName: "Cancel",
            confirmButtonName: "Confirm",
          ),
        ),
      )
    );
  }
}
