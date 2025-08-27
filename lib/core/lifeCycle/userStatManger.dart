import 'dart:async';
import 'package:flutter/material.dart';
import 'package:meeting_app/core/services/auth/state_user_service.dart';

class UserStatusManager extends StatefulWidget {
  final String userId;
  final Widget child;

  const UserStatusManager({
    super.key,
    required this.userId,
    required this.child,
  });

  @override
  State<UserStatusManager> createState() => _UserStatusManagerState();
}

class _UserStatusManagerState extends State<UserStatusManager>
    with WidgetsBindingObserver {
  final UserStatusService _statusService = UserStatusService();
  Timer? _heartbeatTimer;

  static const Duration heartbeatInterval = Duration(seconds: 15);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _startHeartbeat();
  }

  void _startHeartbeat() {
    _sendHeartbeat(); // Initial update
    _heartbeatTimer?.cancel();
    _heartbeatTimer = Timer.periodic(heartbeatInterval, (_) {
      _sendHeartbeat();
    });
  }

  void _stopHeartbeat() {
    _heartbeatTimer?.cancel();
    _heartbeatTimer = null;
    _statusService.setUserOffline(widget.userId); // optional but useful
  }

  void _sendHeartbeat() {
    _statusService.setUserOnline(widget.userId);
  }

  @override
  void dispose() {
    _stopHeartbeat();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        _startHeartbeat();
        break;
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
        _stopHeartbeat();
        break;
      case AppLifecycleState.hidden:
        _stopHeartbeat();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
