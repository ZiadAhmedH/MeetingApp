import 'package:flutter/material.dart';

class JoinMeetingSection extends StatelessWidget {
  const JoinMeetingSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}






















// import 'package:flutter/material.dart';
// import 'package:hmssdk_flutter/hmssdk_flutter.dart';
// import 'package:uuid/uuid.dart';
// import 'package:meeting_app/core/utils/ZigoCloudConst.dart';
// import 'package:meeting_app/viewModel/data/SharedKeys.dart';
// import 'package:meeting_app/viewModel/data/SharedPrefrences.dart';

// class JoinMeetingScreen extends StatefulWidget {
//   final String meetingId;
//   final bool isCameraOn;
//   final bool isMicOn;

//   const JoinMeetingScreen({
//     Key? key,
//     required this.meetingId,
//     this.isCameraOn = true,
//     this.isMicOn = true,
//   }) : super(key: key);

//   @override
//   State<JoinMeetingScreen> createState() => _JoinMeetingScreenState();
// }

// class _JoinMeetingScreenState extends State<JoinMeetingScreen> implements HMSUpdateListener {
//   HMSSDK? hmsSDK;
//   HMSRoom? hmsRoom;
//   bool isJoining = true;

//   @override
//   void initState() {
//     super.initState();
//     initHMS();
//   }

//   Future<void> initHMS() async {
//     hmsSDK = HMSSDK();
//     await hmsSDK!.build();

//     hmsSDK!.addUpdateListener(listener: this);

//     final String userID = LocalData.getData(key: SharedKey.uid) ?? const Uuid().v4();
//     final String userName = "Participant_${LocalData.getData(key: SharedKey.email) ?? "Guest"}";

//     // Replace with your token generation logic or use dummy for dev/testing
//     String token = await fetchAuthToken(widget.meetingId, userID); // You must implement this!

//     HMSConfig config = HMSConfig(
//       authToken: token,
//       userName: userName,
//     );

//     await hmsSDK!.join(config: config);
//   }

//   Future<String> fetchAuthToken(String roomId, String userId) async {
//     // 🔐 Use your backend to fetch token, or return a hardcoded dev token
//     // Docs: https://www.100ms.live/docs/flutter/v2/guides/join-room
//     throw UnimplementedError("Implement your token fetching logic");
//   }

//   @override
//   void onJoin({required HMSRoom room}) {
//     setState(() {
//       isJoining = false;
//       hmsRoom = room;
//     });
//   }

//   @override
//   void onError(HMSException error) {
//     debugPrint("Join Error: ${error.message}");
//     setState(() {
//       isJoining = false;
//     });
//     showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         title: const Text("Join Failed"),
//         content: Text(error.message ?? "Unknown error"),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     hmsSDK?.removeUpdateListener(listener: this);
//     hmsSDK?.leave();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (isJoining) {
//       return const Scaffold(
//         body: Center(child: CircularProgressIndicator()),
//       );
//     }

//     return Scaffold(
//       appBar: AppBar(title: const Text("100ms Meeting")),
//       body: Center(
//         child: Text("Joined Room: ${hmsRoom?.id ?? 'Unknown'}"),
//       ),
//     );
//   }

//   // Other listener methods you may implement
//   @override
//   void onUpdate(HMSRoom room, HMSRoomUpdate update) {}

//   @override
//   void onPeerUpdate({required HMSPeer peer, required HMSPeerUpdate update}) {}

//   @override
//   void onTrackUpdate({
//     required HMSPeer peer,
//     required HMSTrack track,
//     required HMSTrackUpdate trackUpdate,
//   }) {}

//   @override
//   void onMessageReceived(HMSMessage message) {}

//   @override
//   void onRoleChangeRequest({required HMSRoleChangeRequest roleChangeRequest}) {}
  
//   @override
//   void onAudioDeviceChanged({HMSAudioDevice? currentAudioDevice, List<HMSAudioDevice>? availableAudioDevice}) {
//     // TODO: implement onAudioDeviceChanged
//   }
  
//   @override
//   void onChangeTrackStateRequest({required HMSTrackChangeRequest hmsTrackChangeRequest}) {
//     // TODO: implement onChangeTrackStateRequest
//   }
  
//   @override
//   void onHMSError({required HMSException error}) {
//     // TODO: implement onHMSError
//   }
  
//   @override
//   void onMessage({required HMSMessage message}) {
//     // TODO: implement onMessage
//   }
  
//   @override
//   void onPeerListUpdate({required List<HMSPeer> addedPeers, required List<HMSPeer> removedPeers}) {
//     // TODO: implement onPeerListUpdate
//   }
  
//   @override
//   void onReconnected() {
//     // TODO: implement onReconnected
//   }
  
//   @override
//   void onReconnecting() {
//     // TODO: implement onReconnecting
//   }
  
//   @override
//   void onRemovedFromRoom({required HMSPeerRemovedFromPeer hmsPeerRemovedFromPeer}) {
//     // TODO: implement onRemovedFromRoom
//   }
  
//   @override
//   void onRoomUpdate({required HMSRoom room, required HMSRoomUpdate update}) {
//     // TODO: implement onRoomUpdate
//   }
  
//   @override
//   void onSessionStoreAvailable({HMSSessionStore? hmsSessionStore}) {
//     // TODO: implement onSessionStoreAvailable
//   }
  
//   @override
//   void onUpdateSpeakers({required List<HMSSpeaker> updateSpeakers}) {
//     // TODO: implement onUpdateSpeakers
//   }
// }
