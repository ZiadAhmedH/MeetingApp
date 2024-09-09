import 'package:flutter/material.dart';
import 'package:meeting_app/viewModel/data/SharedKeys.dart';
import 'package:meeting_app/viewModel/data/SharedPrefrences.dart';
import 'package:zego_uikit_prebuilt_video_conference/zego_uikit_prebuilt_video_conference.dart';
import '../../../utils/ZigoCloudConst.dart';
class MeetingScreen extends StatelessWidget {


  final String meetingId;

  const MeetingScreen({super.key, required this.meetingId});
  @override
  Widget build(BuildContext context) {
    return  SafeArea(
      child: ZegoUIKitPrebuiltVideoConference(
        appID: ZigoCloud.ZEGO_APP_ID,
        appSign: ZigoCloud.ZEGO_APP_SIGN,
        userID:LocalData.getData(key: SharedKey.uid),
        userName: LocalData.getData(key: SharedKey.email),
        conferenceID: meetingId,
        config: ZegoUIKitPrebuiltVideoConferenceConfig(
          turnOnCameraWhenJoining: false,
          turnOnMicrophoneWhenJoining: false,
          leaveConfirmDialogInfo: ZegoLeaveConfirmDialogInfo(
            title: "Leave the Meeting?",
            message: "Are you sure to leave the meeting ?",
            cancelButtonName: "Cancel",
            confirmButtonName: "Confirm",
          ),
        ),

      ),
    );
  }
}
