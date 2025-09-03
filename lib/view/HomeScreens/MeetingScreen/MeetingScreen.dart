import 'package:flutter/material.dart';
import 'package:videosdk/videosdk.dart';

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
  final Map<String, Participant> _participants = {};

  @override
  void initState() {
    super.initState();
    _initMeeting();
  }

  void _initMeeting() {
    // Create Room
    _room = VideoSDK.createRoom(
      roomId: widget.meetingId,
      token: widget.token,
      displayName: widget.displayName,
      micEnabled: true,
      camEnabled: true,
    );

    // Listen to meeting events
    _room?.on("meeting-joined" as Events, () {
      debugPrint("✅ Meeting Joined");
      setState(() {
        _participants[_room!.localParticipant.id] = _room!.localParticipant;
      });
    });

    _room?.on("participant-joined" as Events, (Participant participant) {
      debugPrint("👤 Participant Joined: ${participant.displayName}");
      setState(() {
        _participants[participant.id] = participant;
      });
    });

    _room?.on("participant-left" as Events, (Participant participant) {
      debugPrint("🚪 Participant Left: ${participant.displayName}");
      setState(() {
        _participants.remove(participant.id);
      });
    });

    _room?.on("meeting-left" as Events, () {
      debugPrint("❌ Meeting Left");
      Navigator.pop(context);
    });

    // Join room
    _room?.join();
  }

  @override
  void dispose() {
    _room?.leave();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Meeting: ${widget.meetingId}"),
      ),
      body: _participants.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
              padding: const EdgeInsets.all(8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 16 / 9,
              ),
              itemCount: _participants.length,
              itemBuilder: (context, index) {
                final participant =
                    _participants.values.elementAt(index);

                return Card(
                  color: Colors.black,
                  child: Center(
                    child: Text(
                      participant.displayName,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _room?.leave(),
        child: const Icon(Icons.call_end, color: Colors.white),
        backgroundColor: Colors.red,
      ),
    );
  }
}
