import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:meeting_app/core/components/CustomText.dart';
import 'package:meeting_app/core/components/TextFormFeild.dart';
import 'package:meeting_app/core/utils/ThemeExtension.dart';
import 'package:meeting_app/viewModel/bloc/MeetingCubit/meeting_cubit.dart';
import 'package:meeting_app/viewModel/data/SharedKeys.dart';
import 'package:meeting_app/viewModel/data/SharedPrefrences.dart';

class JoinScreen extends StatefulWidget {
  const JoinScreen({super.key});

  @override
  State<JoinScreen> createState() => _JoinScreenState();
}

class _JoinScreenState extends State<JoinScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _meetingIdController = TextEditingController();

  final _localRenderer = RTCVideoRenderer();
  final _remoteRenderer = RTCVideoRenderer();

  @override
  void initState() {
    super.initState();
    _initializeRenderers();
  }

  Future<void> _initializeRenderers() async {
    await _localRenderer.initialize();
    await _remoteRenderer.initialize();
  }

  Future<void> _joinMeeting() async {
    if (!_formKey.currentState!.validate()) return;

    final meetingId = _meetingIdController.text.trim();
    final userId = LocalData.getData(key: SharedKey.uid);

    final cubit = context.read<MeetingCubit>();

    await cubit.initSignaling(
      meetingId: meetingId,
      isCameraOn: true,
      isMicOn: true,
      onLocalStream: (stream) {
        setState(() {
          _localRenderer.srcObject = stream;
        });
      },
      onRemoteStream: (stream) {
        setState(() {
          _remoteRenderer.srcObject = stream;
        });
      },
      onDisconnected: () {
        if (mounted) Navigator.of(context).pop();
      },
    );
  }

  @override
  void dispose() {
    _meetingIdController.dispose();
    _localRenderer.dispose();
    _remoteRenderer.dispose();
    context.read<MeetingCubit>().disposeSignaling();
    super.dispose();
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
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: CustomTextFormField(
                controller: _meetingIdController,
                hintText: "Enter Meeting ID",
                icon: const Icon(Icons.video_call),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Meeting ID is required';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _joinMeeting,
              child: const Text("Join"),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Stack(
                children: [
                  Positioned.fill(child: RTCVideoView(_remoteRenderer)),
                  Positioned(
                    top: 10,
                    right: 10,
                    width: 120,
                    height: 160,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: RTCVideoView(_localRenderer, mirror: true),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
