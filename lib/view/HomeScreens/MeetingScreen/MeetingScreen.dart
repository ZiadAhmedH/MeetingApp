import 'package:flutter/material.dart';
import 'package:meeting_app/viewModel/data/SharedKeys.dart';
import 'package:meeting_app/viewModel/data/SharedPrefrences.dart';
import 'package:zego_uikit_prebuilt_video_conference/zego_uikit_prebuilt_video_conference.dart';
import '../../../utils/ZigoCloudConst.dart';
import '../../../viewModel/bloc/MeetingCubit/meeting_cubit.dart';
import '../../../viewModel/bloc/ProfileCubit/profile_cubit.dart';
class MeetingScreen extends StatelessWidget {


  final String meetingId;

  const MeetingScreen({super.key, required this.meetingId});

  @override
  Widget build(BuildContext context) {
    var meetingCubit = MeetingCubit.get(context);
    var profileCubit = ProfileCubit.get(context);
    return  SafeArea(
      child: ZegoUIKitPrebuiltVideoConference(
        appID: ZigoCloud.ZEGO_APP_ID,
        appSign: ZigoCloud.ZEGO_APP_SIGN,
        userID:LocalData.getData(key: SharedKey.uid),
        userName:profileCubit.User?.userName ?? "User Name Not Found",
        conferenceID: meetingId,
        config: ZegoUIKitPrebuiltVideoConferenceConfig(
          avatarBuilder: (context, size, user, extraInfo) {
            return CircleAvatar(
              radius: size.width / 2,
              backgroundImage: NetworkImage(profileCubit.User!.profileImage ?? "https://www.pngitem.com/pimgs/m/146-1468479_my-profile-icon-blank-profile-picture-circle-hd.png"),
            );
          },
          turnOnCameraWhenJoining:meetingCubit.isCameraOn,
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
