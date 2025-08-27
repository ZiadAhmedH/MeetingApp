// import 'dart:ui';

// import 'package:hmssdk_flutter/hmssdk_flutter.dart';

// class HMSManager with HMSUpdateListener {
//   final HMSSDK _hmsSDK;
//   DateTime? meetingStartTime;

//   final Function(HMSPeer, HMSPeerUpdate) onPeerChange;
//   final Function(HMSTrack, HMSTrackUpdate, HMSPeer) onTrackChange;
//   final VoidCallback onJoinCallback;

//   HMSManager({
//     required this.onPeerChange,
//     required this.onTrackChange,
//     required this.onJoinCallback,
//   }) : _hmsSDK = HMSSDK() {
//     _hmsSDK.addUpdateListener(listener: this);
//   }

//   Future<void> buildAndJoin(String token, String userName, String metadata) async {
//     await _hmsSDK.build();
//     final config = HMSConfig(authToken: token, userName: userName, metaData: metadata);
//     await _hmsSDK.join(config: config);
//   }

//   void leaveRoom() {
//     _hmsSDK.leave();
//     _hmsSDK.removeUpdateListener(listener: this);
//     _hmsSDK.destroy();
//   }

//   @override
//   void onJoin({required HMSRoom room}) {
//     meetingStartTime = DateTime.now();
//     onJoinCallback();
//   }

//   @override
//   void onPeerUpdate({required HMSPeer peer, required HMSPeerUpdate update}) {
//     onPeerChange(peer, update);
//   }

//   @override
//   void onTrackUpdate({required HMSTrack track, required HMSTrackUpdate trackUpdate, required HMSPeer peer}) {
//     onTrackChange(track, trackUpdate, peer);
//   }

//   @override void onHMSError({required HMSException error}) {}
//   @override void onMessage({required HMSMessage message}) {}
//   @override void onUpdateSpeakers({required List<HMSSpeaker> updateSpeakers}) {}
//   @override void onRoomUpdate({required HMSRoom room, required HMSRoomUpdate update}) {}
//   @override void onReconnecting() {}
//   @override void onReconnected() {}
//   @override void onRoleChangeRequest({required HMSRoleChangeRequest roleChangeRequest}) {}
//   @override void onChangeTrackStateRequest({required HMSTrackChangeRequest hmsTrackChangeRequest}) {}
//   @override void onRemovedFromRoom({required HMSPeerRemovedFromPeer hmsPeerRemovedFromPeer}) {}
//   @override void onAudioDeviceChanged({HMSAudioDevice? currentAudioDevice, List<HMSAudioDevice>? availableAudioDevice}) {}
//   @override void onSessionStoreAvailable({HMSSessionStore? hmsSessionStore}) {}
//   @override void onPeerListUpdate({required List<HMSPeer> addedPeers, required List<HMSPeer> removedPeers}) {}
// }
