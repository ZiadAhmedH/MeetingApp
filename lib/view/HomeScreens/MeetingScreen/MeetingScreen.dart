import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_video_conference/zego_uikit_prebuilt_video_conference.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../utils/ZigoCloudConst.dart';
import '../../../viewModel/bloc/MeetingCubit/meeting_cubit.dart';
import '../../../viewModel/data/SharedKeys.dart';
import '../../../viewModel/data/SharedPrefrences.dart';

class MeetingScreen extends StatefulWidget {
  final String meetingId;

  const MeetingScreen({super.key, required this.meetingId});

  @override
  State<MeetingScreen> createState() => _MeetingScreenState();
}

class _MeetingScreenState extends State<MeetingScreen> {
  String? zegoKitToken;
  bool _isError = false;

  @override
  void initState() {
    super.initState();
    fetchZegoKitToken();
  }

  Future<void> fetchZegoKitToken() async {
    try {
      final response = await Supabase.instance.client.functions.invoke(
        'generate-zego-token',
        // ❌ DO NOT send user_id manually; token function reads from JWT
      );

      if (response.status == 200 && response.data['token'] != null) {
        setState(() {
          zegoKitToken = response.data['token'] as String;
        });
      } else {
        debugPrint("❌ Token fetch failed: ${response.data}");
        setState(() {
          _isError = true;
        });
      }
    } catch (e) {
      debugPrint("❌ Token fetch exception: $e");
      setState(() {
        _isError = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final userID = LocalData.getData(key: SharedKey.uid);
    final userName = LocalData.getData(key: SharedKey.email) ?? "User";
    final meetingCubit = MeetingCubit.get(context);

    // 🔍 Print debug values
    print('🧾 userID: $userID');
    print('🧾 conferenceID: ${widget.meetingId}');
    print('🧾 zegoToken: $zegoKitToken');

    // Token or userID not ready
    if (_isError) {
      return const Scaffold(
        body: Center(
          child: Text("Failed to join the meeting. Please try again."),
        ),
      );
    }

    if (zegoKitToken == null || userID == null || userID.isEmpty) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return SafeArea(
      child: ZegoUIKitPrebuiltVideoConference(
    appSign: "",
  appID: ZigoCloud.ZEGO_APP_ID,
  userID: userID,
  userName: userName,
  conferenceID: widget.meetingId,
  config: ZegoUIKitPrebuiltVideoConferenceConfig(
    turnOnCameraWhenJoining: meetingCubit.isCameraOn,
    turnOnMicrophoneWhenJoining: meetingCubit.isMicrophoneOn,
    useSpeakerWhenJoining: meetingCubit.isSpeakerOn,
    leaveConfirmDialogInfo: ZegoLeaveConfirmDialogInfo(
      title: "Leave the Meeting?",
      message: "Are you sure to leave the meeting?",
      cancelButtonName: "Cancel",
      confirmButtonName: "Confirm",
    ),
  ),
)

    );
  }
}




