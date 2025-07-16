import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:meeting_app/viewModel/bloc/MeetingCubit/meeting_cubit.dart';

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
  final _localRenderer = RTCVideoRenderer();
  final _remoteRenderer = RTCVideoRenderer();

  late final MeetingCubit _cubit; // ✅ Cache cubit for safe dispose()

  @override
  void initState() {
    super.initState();
    _cubit = BlocProvider.of<MeetingCubit>(context);
    _initializeRenderers();
    _initSignalingAfterFrame();
  }

  void _initSignalingAfterFrame() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _cubit.initSignaling(
        meetingId: widget.meetingId,
        isCameraOn: widget.isCameraOn,
        isMicOn: widget.isMicOn,
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
    });
  }

  Future<void> _initializeRenderers() async {
    await _localRenderer.initialize();
    await _remoteRenderer.initialize();
  }

  @override
  void dispose() {
    _localRenderer.dispose();
    _remoteRenderer.dispose();
    _cubit.disposeSignaling(); // ✅ Safe because cached earlier
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          /// Remote Video (Full Screen)
          Positioned.fill(child: RTCVideoView(_remoteRenderer)),

          /// Local Video (Small Window)
          Positioned(
            top: 40,
            right: 20,
            width: 120,
            height: 160,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: RTCVideoView(_localRenderer, mirror: true),
            ),
          ),

          /// Bottom Control Bar
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: BlocBuilder<MeetingCubit, MeetingState>(
              builder: (context, state) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildToggleButton(
                      icon: _cubit.isCameraOn
                          ? Icons.videocam
                          : Icons.videocam_off,
                      onPressed: _cubit.toggleCamera,
                      color: _cubit.isCameraOn ? Colors.green : Colors.red,
                    ),
                    const SizedBox(width: 24),
                    _buildToggleButton(
                      icon: _cubit.isMicrophoneOn
                          ? Icons.mic
                          : Icons.mic_off,
                      onPressed: _cubit.toggleMicrophone,
                      color: _cubit.isMicrophoneOn ? Colors.green : Colors.red,
                    ),
                    const SizedBox(width: 24),
                    _buildToggleButton(
                      icon: Icons.call_end,
                      onPressed: () => Navigator.of(context).pop(),
                      color: Colors.red,
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleButton({
    required IconData icon,
    required VoidCallback onPressed,
    required Color color,
  }) {
    return ClipOval(
      child: Material(
        color: color,
        child: InkWell(
          splashColor: Colors.white,
          onTap: onPressed,
          child: SizedBox(
            width: 56,
            height: 56,
            child: Icon(icon, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
