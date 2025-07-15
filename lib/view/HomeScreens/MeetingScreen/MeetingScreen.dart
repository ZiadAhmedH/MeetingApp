import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

import '../../../core/utils/AppColor.dart';
import '../../../viewModel/bloc/MeetingCubit/meeting_cubit.dart';
import '../../../viewModel/data/SharedPrefrences.dart';
import '../../../viewModel/data/SharedKeys.dart';
import '../../../core/utils/ZigoCloudConst.dart';

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
  RealtimeChannel? _subscription;

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
      final response = await Supabase.instance.client.functions.invoke('generate-zego-token');
      if (response.status == 200 && response.data['token'] != null) {
        setState(() {
          zegoKitToken = response.data['token'] as String;
        });
      } else {
        debugPrint("❌ Token fetch failed: ${response.data}");
        setState(() => _isError = true);
      }
    } catch (e) {
      debugPrint("❌ Token fetch exception: $e");
      setState(() => _isError = true);
    }
  }


  void _onKickedFromMeeting() {
    if (!mounted) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text("You were removed from the meeting"),
        content: const Text("Another participant has joined this session."),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
              Navigator.of(context).pop(); // Exit screen
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
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
    meetingCubit.putItForOutgoingMeeting(widget.meetingId); 
  });
}


  @override
  void dispose() {
    _subscription?.unsubscribe();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isError) {
      return const Scaffold(
        body: Center(child: Text("Failed to join the meeting. Please try again.")),
      );
    }

    if (zegoKitToken == null) {
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
        config: ZegoUIKitPrebuiltCallConfig.groupVideoCall()
          ..turnOnCameraWhenJoining = widget.isCameraOn
          ..turnOnMicrophoneWhenJoining = widget.isMicOn,
        events: ZegoUIKitPrebuiltCallEvents(
          onCallEnd: (event, defaultAction) async {
            final meetingCubit = BlocProvider.of<MeetingCubit>(context);
            final durationMin = _meetingStartTime == null
                ? 0
                : DateTime.now().difference(_meetingStartTime!).inMinutes;

            await meetingCubit.updateMeetingDuration(widget.meetingId, durationMin);
            await meetingCubit.deleteOutgoingMeeting(widget.meetingId); // ✅


            defaultAction();
          },
        ),
      ),
    );
  }
}