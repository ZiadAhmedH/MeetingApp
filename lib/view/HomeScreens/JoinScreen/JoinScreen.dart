import 'package:flutter/material.dart';
import 'package:meeting_app/view/HomeScreens/JoinScreen/widgets/join_meeting_section.dart';

class JoinScreen extends StatelessWidget {
  final TextEditingController _roomIdController = TextEditingController();

  JoinScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Join a Call")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _roomIdController,
              decoration: const InputDecoration(
                labelText: "Enter Room ID",
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final roomId = _roomIdController.text.trim();
                if (roomId.isNotEmpty) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => JoinMeetingScreen(
                        meetingId: roomId,
                        isCameraOn: true, // Default value, can be changed
                        isMicOn: true,  // Default value, can be changed
                      ),
                    ),
                  );
                }
              },
              child: const Text("Join"),
            ),
          ],
        ),
      ),
    );
  }
}
