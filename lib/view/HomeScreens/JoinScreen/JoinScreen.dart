import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meeting_app/core/components/CustomText.dart';
import 'package:meeting_app/core/components/TextFormFeild.dart';
import 'package:meeting_app/core/utils/ThemeExtension.dart';
import 'package:meeting_app/core/utils/ZigoCloudConst.dart';
import 'package:meeting_app/viewModel/bloc/MeetingCubit/meeting_cubit.dart';
import 'package:meeting_app/viewModel/data/SharedKeys.dart';
import 'package:meeting_app/viewModel/data/SharedPrefrences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

class JoinScreen extends StatefulWidget {
  const JoinScreen({super.key});

  @override
  State<JoinScreen> createState() => _JoinScreenState();
}

class _JoinScreenState extends State<JoinScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _meetingIdController = TextEditingController();

  @override
  void dispose() {
    _meetingIdController.dispose();
    super.dispose();
  }

  Future<void> _joinMeeting(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      final meetingCubit = MeetingCubit.get(context);
      final callId = _meetingIdController.text.trim();
      final userId = LocalData.getData(key: SharedKey.uid);

      // Check if meeting exists in Supabase
    final response = await Supabase.instance.client
        .from('meetings')
        .select('id')
        .eq('id', callId)
        .maybeSingle();

    if (response == null) {
      // Meeting not found
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Meeting ID not found')),
      );
      return;
    }


      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ZegoUIKitPrebuiltCall(
            appID: ZigoCloud.ZEGO_APP_ID, // Replace with your real App ID
            appSign: ZigoCloud.ZEGO_APP_SIGN, // Replace with your real App Sign
            userID: userId,
            userName: LocalData.getData(key: SharedKey.email),
              
            callID: callId,
            config: ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall()
              ..turnOnCameraWhenJoining = meetingCubit.isCameraOn
              ..turnOnMicrophoneWhenJoining = meetingCubit.isMicrophoneOn
              ..useSpeakerWhenJoining = meetingCubit.isSpeakerOn,
            events: ZegoUIKitPrebuiltCallEvents(
              onCallEnd: (event, defaultAction) {
                meetingCubit.logJoinEvent(meetingId: callId);
                defaultAction();
              },
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.primaryBackgroundColor,
      appBar: AppBar(
        backgroundColor: context.primaryBackgroundColor,
        title: CustomText(
          text: 'Join Meeting',
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
          color: context.thirdTextColor,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: 'Enter Meeting ID',
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: context.thirdTextColor,
              ),
              const SizedBox(height: 20),
              CustomTextFormField(
                controller: _meetingIdController,
                hintText: "Meeting ID",
                icon: const Icon(Icons.video_call),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Meeting ID is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  onPressed: () => _joinMeeting(context),
                  style: ButtonStyle(
                    backgroundColor:
                        WidgetStateProperty.all(context.thirdTextColor),
                    padding: WidgetStateProperty.all(
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                  ),
                  child: CustomText(
                    text: 'Join Meeting',
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: context.primaryBackgroundColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
