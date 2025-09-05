import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:meeting_app/core/components/CustomText.dart';
import 'package:meeting_app/view/HomeScreens/MeetingScreen/widgets/video_tiles.dart';
import 'package:meeting_app/viewModel/bloc/MeetingCubit/meeting_cubit.dart';
import 'package:videosdk/videosdk.dart';
import 'package:videosdk/videosdk.dart' as rtc;

import '../../../core/utils/AppColor.dart';
import 'widgets/participaint_list.dart'; // for RTCVideoView & Stream

class MeetingScreen extends StatefulWidget {
  final String meetingId;
  final String token;
  final String displayName;

  const MeetingScreen({
    Key? key,
    required this.meetingId,
    required this.token,
    required this.displayName,
  }) : super(key: key);

  @override
  State<MeetingScreen> createState() => _MeetingScreenState();
}

class _MeetingScreenState extends State<MeetingScreen> {
  Room? _room;

  // ✅ Track participants
  final Map<String, Participant> _participants = {};

  // ✅ Track video streams
  final Map<String, rtc.Stream?> _videoStreams = {};

  bool _micEnabled = true;
  bool _camEnabled = true;

  @override
  void initState() {
    super.initState();
    _joinMeeting();
  }

  void _joinMeeting() {
    _room = VideoSDK.createRoom(
      roomId: widget.meetingId,
      token: widget.token,
      displayName: widget.displayName,
      micEnabled: _micEnabled,
      camEnabled: _camEnabled,
    );
    context.read<MeetingCubit>().createMeeting(cameraOn: _camEnabled, micOn: _micEnabled, durationMin: 60, meetingId: widget.meetingId);

    // Meeting events
    _room?.on(Events.roomJoined, _onRoomJoined);
    _room?.on(Events.participantJoined, _onParticipantJoined);
    _room?.on(Events.participantLeft, _onParticipantLeft);

    _room?.join();
  }

  void _onRoomJoined() {
    debugPrint("✅ Meeting Joined");

    // Add local participant
    setState(() {
      _participants[_room!.localParticipant.id] = _room!.localParticipant;
    });

    // Attach local streams
    _attachParticipantStreamListeners(_room!.localParticipant);

    for (final s in _room!.localParticipant.streams.values) {
      if (s.kind == 'video') {
        setState(
            () => _videoStreams[_room!.localParticipant.id] = s as rtc.Stream?);
      }
    }

    // Add already connected participants
    _room!.participants.forEach((id, participant) {
      _onParticipantJoined(participant);
    });
  }

  void _onParticipantJoined(Participant participant) {
    debugPrint("👤 Participant Joined: ${participant.displayName}");
    setState(() {
      _participants[participant.id] = participant;
    });
    _attachParticipantStreamListeners(participant);
  }

  void _onParticipantLeft(String participantId) {
    debugPrint("🚪 Participant Left: $participantId");
    setState(() {
      _participants.remove(participantId);
      _videoStreams.remove(participantId);
    });
  }

  void _attachParticipantStreamListeners(Participant participant) {
    participant.on(Events.streamEnabled, (Stream stream) {
      if (stream.kind == 'video') {
        setState(() => _videoStreams[participant.id] = stream as rtc.Stream?);
      }
    });

    participant.on(Events.streamDisabled, (Stream stream) {
      if (stream.kind == 'video') {
        setState(() => _videoStreams.remove(participant.id));
      }
    });
  }

 

  void _leaveMeeting() {
       context.read<MeetingCubit>().deleteOutgoingMeeting(widget.meetingId);
    _room?.leave();
    Navigator.pop(context);
  }

  @override
  void dispose() {
   

    _room?.end();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tiles = videoTiles( _participants, _videoStreams);

    return Scaffold(
      appBar: AppBar(
        title: CustomText(
          text: "Meeting Details",
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColor.blue, AppColor.blueAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.people),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (_) => SizedBox(
                  height: 300,
                  child: ParticipantList( _participants, _room),
                ),
              );
            },
          )
        ],
      ),
      body: tiles.isEmpty
          ? Center(
              child: LoadingAnimationWidget.staggeredDotsWave(
                color: AppColor.blue,
                size: 50,
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 3 / 4,
              ),
              itemCount: tiles.length,
              itemBuilder: (context, index) => tiles[index],
            ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.transparent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              color: AppColor.blue,
              icon: Icon(_micEnabled ? Icons.mic : Icons.mic_off),
               style: TextButton.styleFrom(
                backgroundColor: AppColor.darkGrey,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ) ,
              ),
              onPressed: () {
                setState(() {
                  _micEnabled = !_micEnabled;
                  _micEnabled ? _room?.unmuteMic() : _room?.muteMic();
                });
              },
            ),
            IconButton(
              color: AppColor.blue,
              icon: Icon(_camEnabled ? Icons.videocam : Icons.videocam_off),
              onPressed: () {
                setState(() {
                  _camEnabled = !_camEnabled;
                  _camEnabled ? _room?.enableCam() : _room?.disableCam();
                });
              },
            ),
            IconButton(
              icon: const Icon(Icons.call_end, color: Colors.red),
              onPressed: _leaveMeeting,
            ),
          ],
        ),
      ),
    );
  }
}
