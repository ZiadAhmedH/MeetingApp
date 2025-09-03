import 'package:flutter/material.dart';
import 'package:videosdk/videosdk.dart';
import 'package:videosdk/videosdk.dart' as rtc; // for RTCVideoView & Stream

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

  /// Track participants’ *video* streams for rendering
  final Map<String, rtc.Stream?> _videoStreams = {};

  /// Local UI state for mic/cam buttons
  bool _micEnabled = true;
  bool _camEnabled = true;

  @override
  void initState() {
    super.initState();
    _initMeeting();
  }

  void _initMeeting() {
    _room = VideoSDK.createRoom(
      roomId: widget.meetingId,
      token: widget.token,
      displayName: widget.displayName,
      micEnabled: _micEnabled,
      camEnabled: _camEnabled,
      // optional extras:
      // maxResolution: 'hd',
      // defaultCameraIndex: 1,
    );

    // Set up room-level listeners
    _room?.on(Events.roomJoined, _onRoomJoined);
    _room?.on(Events.participantJoined, _onParticipantJoined);
    _room?.on(Events.participantLeft, _onParticipantLeft);
    _room?.on(Events.roomLeft, _onRoomLeft);
    _room?.on(Events.error, (err) {
      debugPrint("VIDEOSDK ERROR :: ${err['code']} :: ${err['name']} :: ${err['message']}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("VideoSDK error: ${err['message']}")),
      );
    });

    // Join the room
    _room?.join();
  }

  void _onRoomJoined() {
    debugPrint("✅ Meeting Joined");

    // Start listening to local participant streams
    _attachParticipantStreamListeners(_room!.localParticipant);

    // If local participant already has a video stream, store it so it renders immediately
    for (final s in _room!.localParticipant.streams.values) {
      if (s.kind == 'video') {
        setState(() => _videoStreams[_room!.localParticipant.id] = s as rtc.Stream?);
      }
      if (s.kind == 'audio') {
        setState(() => _micEnabled = true);
      }
    }
  }

  void _onParticipantJoined(Participant participant) {
    debugPrint("👤 Participant Joined: ${participant.displayName}");
    _attachParticipantStreamListeners(participant);
  }

  void _onParticipantLeft(String participantId) {
    debugPrint("🚪 Participant Left: $participantId");
    setState(() {
      _videoStreams.remove(participantId);
    });
  }

  void _onRoomLeft() {
    debugPrint("❌ Meeting Left");
    _videoStreams.clear();
    if (mounted) Navigator.pop(context);
  }

  /// Listen to a participant’s media stream events and keep our UI state in sync.
  void _attachParticipantStreamListeners(Participant participant) {
    // When a new stream is enabled (published)
    participant.on(Events.streamEnabled, (rtc.Stream stream) {
      if (stream.kind == 'video') {
        setState(() => _videoStreams[participant.id] = stream);
        if (_room != null && participant.id == _room!.localParticipant.id) {
          _camEnabled = true; // reflect local cam state
        }
      } else if (stream.kind == 'audio') {
        if (_room != null && participant.id == _room!.localParticipant.id) {
          setState(() => _micEnabled = true);
        }
      }
    });

    // When a stream is disabled (unpublished)
    participant.on(Events.streamDisabled, (rtc.Stream stream) {
      if (stream.kind == 'video') {
        setState(() => _videoStreams.remove(participant.id));
        if (_room != null && participant.id == _room!.localParticipant.id) {
          _camEnabled = false;
        }
      } else if (stream.kind == 'audio') {
        if (_room != null && participant.id == _room!.localParticipant.id) {
          setState(() => _micEnabled = false);
        }
      }
    });

    // If participant already has an active video stream when we attach listeners
    for (final s in participant.streams.values) {
      final stream = s as rtc.Stream;
      if (stream.kind == 'video') {
        setState(() => _videoStreams[participant.id] = stream);
      }
    }
  }

  @override
  void dispose() {
    // Clean up
    _room?.leave();
    super.dispose();
  }

  // --- Controls ---

  void _toggleMic() {
    if (_room == null) return;
    if (_micEnabled) {
      _room!.muteMic();
      setState(() => _micEnabled = false);
    } else {
      _room!.unmuteMic();
      setState(() => _micEnabled = true);
    }
  }

  void _toggleCam() {
    if (_room == null) return;
    if (_camEnabled) {
      _room!.disableCam();
      setState(() => _camEnabled = false);
    } else {
      _room!.enableCam();
      setState(() => _camEnabled = true);
    }
  }

  void _leave() => _room?.leave();

  @override
  Widget build(BuildContext context) {
    final tiles = _videoStreams.values
        .where((s) => s != null)
        .map((s) => _VideoTile(stream: s!))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text("Meeting: ${widget.meetingId}"),
      ),
      body: tiles.isEmpty
          ? const Center(child: Text('Waiting for video…'))
          : GridView.builder(
              padding: const EdgeInsets.all(8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 16 / 9,
              ),
              itemCount: tiles.length,
              itemBuilder: (context, index) => tiles[index],
            ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // Leave
              FloatingActionButton(
                heroTag: 'leave',
                backgroundColor: Colors.red,
                onPressed: _leave,
                child: const Icon(Icons.call_end, color: Colors.white),
              ),
              // Mic
              FloatingActionButton(
                heroTag: 'mic',
                onPressed: _toggleMic,
                child: Icon(_micEnabled ? Icons.mic : Icons.mic_off),
              ),
              // Camera
              FloatingActionButton(
                heroTag: 'cam',
                onPressed: _toggleCam,
                child: Icon(_camEnabled ? Icons.videocam : Icons.videocam_off),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Renders a single participant video stream.
/// IMPORTANT: requires `package:videosdk/rtc.dart`.
class _VideoTile extends StatelessWidget {
  final rtc.Stream stream;
  const _VideoTile({required this.stream});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      color: Colors.black,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // This fixes the “black camera” — we actually render the video track.
          rtc.RTCVideoView(
            stream.renderer!,
            objectFit: rtc.RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
          ),
        ],
      ),
    );
  }
}
