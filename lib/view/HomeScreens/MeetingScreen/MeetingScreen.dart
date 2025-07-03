import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:meeting_app/utils/AppColor.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../utils/ZigoCloudConst.dart';
import '../../../viewModel/bloc/MeetingCubit/meeting_cubit.dart';
import '../../../viewModel/data/SharedKeys.dart';
import '../../../viewModel/data/SharedPrefrences.dart';

class MeetingScreen extends StatefulWidget {
  final String meetingId;
  final bool isCameraOn;
  final bool isMicOn;

  const MeetingScreen({
    super.key,
    required this.meetingId,
    required this.isCameraOn,
    required this.isMicOn,
  });

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

    if (_isError) {
      return const Scaffold(
        body: Center(child: Text("Failed to join the meeting. Please try again.")),
      );
    }

    if (zegoKitToken == null || userID == null || userID.isEmpty) {
      return Scaffold(
        body: Center(
          child: LoadingAnimationWidget.dotsTriangle(
            color: AppColor.blueAccent,
            size: 50,
          ),
        ),
      );
    }

    return SafeArea(
  child: ZegoUIKitPrebuiltCall(
    appID: ZigoCloud.ZEGO_APP_ID,
    appSign: ZigoCloud.ZEGO_APP_SIGN,
    userID: userID,
    userName: userName,
    callID: widget.meetingId,
    token: zegoKitToken!,
    // use your meetingCubit instance, passed via constructor or context
    config: ZegoUIKitPrebuiltCallConfig.groupVideoCall()
      ..turnOnCameraWhenJoining = widget.isCameraOn
      ..turnOnMicrophoneWhenJoining = widget.isMicOn,
    events: ZegoUIKitPrebuiltCallEvents(
      onCallEnd: (event, defaultAction) {
        // 🎯 When the call ends, dispatch a Cubit event:
        BlocProvider.of<MeetingCubit>(context).onMeetingEnded(
          meetingId: widget.meetingId,
          durationMin: BlocProvider.of<MeetingCubit>(context).selectedDuration,
          cameraOn: widget.isCameraOn,
          micOn: widget.isMicOn,
        );
        defaultAction(); 
      },
         

    ),
  ),
);


  }
}
