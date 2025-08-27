// import 'dart:convert';
// import 'package:flutter_webrtc/flutter_webrtc.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// class WebRTCService {
//   final SupabaseClient supabase;
//   final String roomId;
//   final RealtimeChannel channel;
//   final Function(MediaStream stream) onRemoteStream;

//   RTCPeerConnection? _peerConnection;
//   MediaStream? _localStream;

//   final Map<String, dynamic> _iceServers = {
//     'iceServers': [
//       {'urls': 'stun:stun.l.google.com:19302'}
//     ],
//     'sdpSemantics': 'unified-plan', // correct usage with tracks
//   };

//   WebRTCService({
//     required this.supabase,
//     required this.roomId,
//     required this.onRemoteStream,
//   }) : channel = supabase.channel('public:call_signals');

//   /// Initialize local media and start signaling
//   Future<MediaStream> init() async {
//     await _initLocalMedia();
//     await _initRealtime();
//     return _localStream!;
//   }

//   /// Get camera and microphone stream
//   Future<void> _initLocalMedia() async {
//     final mediaConstraints = {
//       'audio': true,
//       'video': {'facingMode': 'user'}
//     };

//     _localStream = await navigator.mediaDevices.getUserMedia(mediaConstraints);
//   }

//   MediaStream? getLocalStream() => _localStream;

//   /// Caller creates offer
//   Future<void> createOffer() async {
//     await _createPeerConnection(isCaller: true);

//     final offer = await _peerConnection!.createOffer();
//     await _peerConnection!.setLocalDescription(offer);

//     await _sendSignal('offer', {
//       'sdp': offer.sdp,
//       'type': offer.type,
//     });
//   }

//   /// Initialize RTCPeerConnection and attach tracks
//   Future<void> _createPeerConnection({required bool isCaller}) async {
//     _peerConnection = await createPeerConnection(_iceServers);

//     // Add local stream tracks
//     for (var track in _localStream!.getTracks()) {
//       _peerConnection?.addTrack(track, _localStream!);
//     }

//     _peerConnection?.onTrack = (event) {
//       if (event.streams.isNotEmpty) {
//         onRemoteStream(event.streams.first);
//       }
//     };

//     _peerConnection?.onIceCandidate = (candidate) async {
//       if (candidate != null) {
//         await _sendSignal('candidate', {
//           'candidate': candidate.candidate,
//           'sdpMid': candidate.sdpMid,
//           'sdpMLineIndex': candidate.sdpMLineIndex,
//         });
//       }
//     };
//   }

//   /// Send offer/answer/candidate to Supabase signaling table
//   Future<void> _sendSignal(String type, Map<String, dynamic> data) async {
//     await supabase.from('call_signals').insert({
//       'room_id': roomId,
//       'type': type,
//       'data': jsonEncode(data),
//       'timestamp': DateTime.now().toIso8601String(),
//     });
//   }

//   /// Subscribe to Supabase channel for signaling
//   Future<void> _initRealtime() async {
//     channel.onPostgresChanges(
//       event: PostgresChangeEvent.insert,
//       schema: 'public',
//       table: 'call_signals',
//       callback: (payload) async {
//         final data = payload.newRecord;
//         if (data == null || data['room_id'] != roomId) return;

//         final type = data['type'];
//         final signalData = jsonDecode(data['data']);

//         switch (type) {
//           case 'offer':
//             await _createPeerConnection(isCaller: false);
//             await _peerConnection?.setRemoteDescription(
//               RTCSessionDescription(signalData['sdp'], signalData['type']),
//             );

//             final answer = await _peerConnection!.createAnswer();
//             await _peerConnection!.setLocalDescription(answer);

//             await _sendSignal('answer', {
//               'sdp': answer.sdp,
//               'type': answer.type,
//             });
//             break;

//           case 'answer':
//             await _peerConnection?.setRemoteDescription(
//               RTCSessionDescription(signalData['sdp'], signalData['type']),
//             );
//             break;

//           case 'candidate':
//             final candidate = RTCIceCandidate(
//               signalData['candidate'],
//               signalData['sdpMid'],
//               signalData['sdpMLineIndex'],
//             );
//             await _peerConnection?.addCandidate(candidate);
//             break;
//         }
//       },
//     );
//     await channel.subscribe();
//   }

//   /// Dispose everything
//   Future<void> dispose() async {
//     await _peerConnection?.close();
//     _localStream?.getTracks().forEach((track) => track.stop());
//     await channel.unsubscribe();
//   }
// }
