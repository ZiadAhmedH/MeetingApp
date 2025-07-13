import 'package:flutter/material.dart';
import 'package:meeting_app/core/services/state_user_service.dart';

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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _statusService.setUserOnline(widget.userId);
  }

  @override
  void dispose() {
    _statusService.setUserOffline(widget.userId);
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _statusService.setUserOnline(widget.userId);
    } else if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive ||
        state == AppLifecycleState.detached) {
      _statusService.setUserOffline(widget.userId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
