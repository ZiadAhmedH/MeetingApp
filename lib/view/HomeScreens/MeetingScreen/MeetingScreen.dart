import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:meeting_app/core/utils/ZigoCloudConst.dart';
import 'package:meeting_app/viewModel/bloc/MeetingCubit/meeting_cubit.dart';
import 'package:meeting_app/viewModel/data/SharedKeys.dart';
import 'package:meeting_app/viewModel/data/SharedPrefrences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

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
  DateTime? _meetingStartTime;

  late final String userID;
  late final String userName;

  @override
  void initState() {
    super.initState();
    userID = LocalData.getData(key: SharedKey.uid)!;
    userName = LocalData.getData(key: SharedKey.email) ?? "User";
    _meetingStartTime = DateTime.now();
    fetchZegoKitToken();
    _createMeetingLog();
  }

  Future<void> fetchZegoKitToken() async {
    try {
      final response = await Supabase.instance.client.functions.invoke(
        'generate-zego-token',
        body: {'room_id': widget.meetingId, 'user_id': userID},
      );

      if (response.status == 200 && response.data['token'] != null) {
        setState(() {
          zegoKitToken = response.data['token'] as String;
        });
        debugPrint("✅ Token fetched successfully: $zegoKitToken");
      } else {
        debugPrint("❌ Token fetch failed: ${response.data}");
        setState(() => _isError = true);
      }
    } catch (e) {
      debugPrint("❌ Token fetch exception: $e");
      setState(() => _isError = true);
    }
  }

  void _createMeetingLog() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final meetingCubit = BlocProvider.of<MeetingCubit>(context);
      meetingCubit.createMeeting(
        meetingId: widget.meetingId,
        durationMin: 0,
        cameraOn: widget.isCameraOn,
        micOn: widget.isMicOn,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isError) {
      return const Scaffold(
        body: Center(
          child: Text("Failed to join the meeting. Please try again."),
        ),
      );
    }

    if (zegoKitToken == null) {
      return Scaffold(
        body: Center(
          child: LoadingAnimationWidget.dotsTriangle(
            color: Colors.blue,
            size: 50,
          ),
        ),
      );
    }

    return ZegoUIKitPrebuiltCall(
      appID: ZigoCloud.ZEGO_APP_ID,
      userID: userID,
      userName: userName,
      callID: widget.meetingId,
      token: zegoKitToken!,
      config: ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall()
        ..turnOnCameraWhenJoining = widget.isCameraOn
        ..turnOnMicrophoneWhenJoining = widget.isMicOn,
      events: ZegoUIKitPrebuiltCallEvents(
        onCallEnd: (event, defaultAction) async {
          final meetingCubit = BlocProvider.of<MeetingCubit>(context);
          final durationMin = _meetingStartTime == null
              ? 0
              : DateTime.now().difference(_meetingStartTime!).inMinutes;
          await meetingCubit.updateMeetingDuration(widget.meetingId, durationMin);
          await meetingCubit.deleteOutgoingMeeting(widget.meetingId);
          defaultAction.call();
        },
      ),
    );
  }
}
