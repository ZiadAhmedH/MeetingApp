import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

import '../../../utils/ZigoCloudConst.dart';
import '../../../viewModel/bloc/MeetingCubit/meeting_cubit.dart';
import '../../../viewModel/bloc/ProfileCubit/profile_cubit.dart';
import '../../../viewModel/data/SharedKeys.dart';
import '../../../viewModel/data/SharedPrefrences.dart';
class MeetingScreen extends StatefulWidget {
  final String meetingId;

  const MeetingScreen({super.key, required this.meetingId});

  @override
  _MeetingScreenState createState() => _MeetingScreenState();
}

class _MeetingScreenState extends State<MeetingScreen> {
  int minutes = 0;
  int seconds = 0;

  @override
  Widget build(BuildContext context) {
    var profileCubit = ProfileCubit.get(context);
    var meetingCubit = MeetingCubit.get(context);
    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: ZegoUIKitPrebuiltCall(
              appID: ZigoCloud.ZEGO_APP_ID, // Fill in the appID from ZEGOCLOUD Admin Console.
              appSign: ZigoCloud.ZEGO_APP_SIGN, // Fill in the appSign from ZEGOCLOUD Admin Console.
              userID: LocalData.getData(key: SharedKey.uid),
              userName: profileCubit.User?.userName! ?? 'Loading...',
              callID: widget.meetingId,
              events: ZegoUIKitPrebuiltCallEvents(
                onCallEnd: (event, defaultAction) {
                  defaultAction();
                  Navigator.pop(context);
                },
              ),
              onDispose: () {
                meetingCubit.createMeeting(duration:"$minutes min  :  $seconds sec" );
              },

              config: ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall()
                ..duration.onDurationUpdate = (Duration duration) {
                  setState(() {
                    minutes = duration.inMinutes;
                    seconds = duration.inSeconds % 60;
                  });
                },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Duration: $minutes minutes and $seconds seconds'),
          ),
        ],
      ),
    );
  }
}
