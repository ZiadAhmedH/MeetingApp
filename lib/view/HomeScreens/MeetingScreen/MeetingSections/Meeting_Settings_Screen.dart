import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meeting_app/core/components/CustomBtn.dart';
import 'package:meeting_app/core/components/CustomText.dart';
import 'package:meeting_app/core/utils/ThemeExtension.dart';
import 'package:meeting_app/core/utils/api_video_sdk.dart';
import 'package:meeting_app/view/HomeScreens/MeetingScreen/MeetingScreen.dart';
import 'package:meeting_app/viewModel/bloc/MeetingCubit/meeting_cubit.dart';
import 'package:meeting_app/core/utils/AppColor.dart';


class MeetingSettings extends StatefulWidget {
  const MeetingSettings({super.key});

  @override
  State<MeetingSettings> createState() => _MeetingSettingsState();
}

class _MeetingSettingsState extends State<MeetingSettings> {
  String? _meetingId;
  String? _token;
  bool _loading = false;

  Future<void> _initMeeting() async {
    setState(() => _loading = true);

    try {
      // 1. Fetch auth token
      final token = await fetchToken(context);

      // 2. Create meeting on VideoSDK server
      final meetingId = await createMeeting(token);

      setState(() {
        _token = token;
        _meetingId = meetingId;
      });
    } catch (e) {
      debugPrint("Error creating meeting: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error creating meeting: $e")),
      );
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  void initState() {
    super.initState();
    _initMeeting(); // fetch meetingId + token when screen loads
  }

  @override
  Widget build(BuildContext context) {
    var meetingCubit = MeetingCubit.get(context);

    return BlocBuilder<MeetingCubit, MeetingState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: context.primaryBackgroundColor,
            title: CustomText(
              text: "Meeting Settings",
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: context.thirdTextColor,
            ),
          ),
          body: Container(
            color: context.primaryBackgroundColor,
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CustomText(
                    text: "Meeting ID",
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: context.thirdTextColor,
                  ),
                  const SizedBox(height: 10),

                  // Show meetingId or loader
                  _loading
                      ? const CircularProgressIndicator()
                      : CustomText(
                          text: _meetingId ?? "No meeting yet",
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColor.primaryBlue,
                        ),
                  const SizedBox(height: 20),

                  // Camera toggle
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                        text: "Camera",
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: context.thirdTextColor,
                      ),
                      CupertinoSwitch(
                        value: meetingCubit.isCameraOn,
                        onChanged: (_) => meetingCubit.toggleCamera(),
                        activeTrackColor: AppColor.primaryBlue,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Microphone toggle
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                        text: "Microphone",
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: context.thirdTextColor,
                      ),
                      CupertinoSwitch(
                        value: meetingCubit.isMicrophoneOn,
                        onChanged: (_) => meetingCubit.toggleMicrophone(),
                        activeTrackColor: AppColor.primaryBlue,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Speaker toggle
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                        text: "Speaker",
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: context.thirdTextColor,
                      ),
                      CupertinoSwitch(
                        value: meetingCubit.isSpeakerOn,
                        onChanged: (_) => meetingCubit.toggleSpeaker(),
                        activeTrackColor: AppColor.primaryBlue,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  const CustomText(
                    text: "Meeting Duration",
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: AppColor.primaryBlue,
                  ),
                  const SizedBox(height: 10),
                  const CustomText(
                    text: "60 Minutes",
                    fontSize: 16.0,
                    fontWeight: FontWeight.normal,
                    color: AppColor.primaryBlue,
                  ),
                  const SizedBox(height: 30),

                  // Join Meeting Button
                  CustomButton(
                    borderColor: AppColor.lightGrey,
                    backgroundColor: AppColor.darkGrey,
                    textColor: AppColor.white,
                    isClickable: (_meetingId != null && _token != null) ? 1 : 0,
                    onTap: () {
                      if (_meetingId != null && _token != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => MeetingScreen(
                              displayName: 'User',
                              token: _token!,
                              meetingId: _meetingId!,
                            ),
                          ),
                        );
                      }
                    },
                    text: CustomText(
                      text: "GO TO MEETING",
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: AppColor.white,
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
