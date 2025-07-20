import 'package:flutter/material.dart';
import 'package:meeting_app/core/utils/ZigoCloudConst.dart';
import 'package:meeting_app/viewModel/data/SharedKeys.dart';
import 'package:meeting_app/viewModel/data/SharedPrefrences.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:uuid/uuid.dart';

class JoinMeetingScreen extends StatelessWidget {
  final String meetingId;
  final bool isCameraOn;
  final bool isMicOn;

  JoinMeetingScreen({
    super.key,
    required this.meetingId,
    this.isCameraOn = true,
    this.isMicOn = true,
  });

  @override
  Widget build(BuildContext context) {
    final String userID = LocalData.getData(key: SharedKey.uid) ?? const Uuid().v4();
    final String userName = "Participant_${LocalData.getData(key: SharedKey.email) ?? "Guest"}";

    return ZegoUIKitPrebuiltCall(
      appID: ZigoCloud.ZEGO_APP_ID,
      appSign: ZigoCloud.ZEGO_APP_SIGN,
      userID: userID,
      userName: userName,
      callID: meetingId,
      config: ZegoUIKitPrebuiltCallConfig.groupVideoCall()
        ..turnOnCameraWhenJoining = isCameraOn
        ..turnOnMicrophoneWhenJoining = isMicOn,
      events: ZegoUIKitPrebuiltCallEvents(
        onCallEnd: (event, defaultAction) {
          defaultAction.call();
        },
      ),
    );
  }
}
