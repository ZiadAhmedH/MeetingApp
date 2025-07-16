import 'dart:convert';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

typedef OnRemoteStream = void Function(MediaStream stream);
typedef OnDisconnected = void Function();

class SignalingService {
  final String selfId;
  final String meetingId;
  final String wsUrl;
  final OnRemoteStream onRemoteStream;
  final OnDisconnected onDisconnected;

  WebSocketChannel? _channel;
  RTCPeerConnection? _peerConnection;
  MediaStream? _localStream;
  String? _remoteId;

  SignalingService({
    required this.selfId,
    required this.meetingId,
    required this.wsUrl,
    required this.onRemoteStream,
    required this.onDisconnected,
  });

  MediaStream? get localStream => _localStream;

  Future<void> init() async {
    await _createLocalStream();
    _connectWebSocket();
  }

  Future<void> _createLocalStream() async {
    _localStream = await navigator.mediaDevices.getUserMedia({
      'audio': true,
      'video': {'facingMode': 'user'},
    });
  }

  void _connectWebSocket() {
    _channel = WebSocketChannel.connect(Uri.parse(wsUrl));

    _channel!.stream.listen((message) async {
      final data = json.decode(message);
      final type = data['type'];
      final from = data['from'];

      if (_remoteId == null && from != selfId) {
        _remoteId = from;
      }

      switch (type) {
        case 'offer':
          await _handleRemoteOffer(data);
          break;
        case 'answer':
          await _handleRemoteAnswer(data);
          break;
        case 'ice':
          await _handleRemoteCandidate(data);
          break;
      }
    }, onDone: onDisconnected, onError: (_) => onDisconnected());

    _sendSignal({'type': 'join'});
  }

  Future<void> _createPeerConnection({bool isOffer = true}) async {
    if (_peerConnection != null) return;

    _peerConnection = await createPeerConnection({
      'iceServers': [{'urls': 'stun:stun.l.google.com:19302'}],
    });

    _peerConnection!.onIceCandidate = (candidate) {
      _sendSignal({'type': 'ice', 'candidate': candidate.toMap()});
    };

    _peerConnection!.onTrack = (event) {
      if (event.streams.isNotEmpty) {
        onRemoteStream(event.streams.first);
      }
    };

    if (_localStream != null) {
      for (var track in _localStream!.getTracks()) {
        await _peerConnection!.addTrack(track, _localStream!);
      }
    }

    if (isOffer) {
      final offer = await _peerConnection!.createOffer();
      await _peerConnection!.setLocalDescription(offer);
      _sendSignal({'type': 'offer', 'sdp': offer.sdp});
    }
  }

  Future<void> _handleRemoteOffer(Map<String, dynamic> data) async {
    final sdp = data['sdp'];
    await _createPeerConnection(isOffer: false);
    await _peerConnection!.setRemoteDescription(
        RTCSessionDescription(sdp, 'offer'));
    final answer = await _peerConnection!.createAnswer();
    await _peerConnection!.setLocalDescription(answer);
    _sendSignal({'type': 'answer', 'sdp': answer.sdp});
  }

  Future<void> _handleRemoteAnswer(Map<String, dynamic> data) async {
    final sdp = data['sdp'];
    await _peerConnection?.setRemoteDescription(
        RTCSessionDescription(sdp, 'answer'));
  }

  Future<void> _handleRemoteCandidate(Map<String, dynamic> data) async {
    final c = data['candidate'];
    final candidate =
        RTCIceCandidate(c['candidate'], c['sdpMid'], c['sdpMLineIndex']);
    await _peerConnection?.addCandidate(candidate);
  }

  void _sendSignal(Map<String, dynamic> data) {
  final message = {
    ...data,
    'from': selfId,
    'to': _remoteId ?? 'broadcast',
    'id': meetingId,
  };

  print('[Signaling] Sending: $message'); // 👈 Add for debugging
  _channel?.sink.add(json.encode(message));
}


  Future<void> dispose() async {
    try {
      await _localStream?.dispose();
      await _peerConnection?.close();
      await _channel?.sink.close();
    } catch (_) {}
    onDisconnected();
  }
}
