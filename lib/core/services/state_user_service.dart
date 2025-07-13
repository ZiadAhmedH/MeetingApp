import 'package:supabase_flutter/supabase_flutter.dart';

class UserStatusService {
  final SupabaseClient _client = Supabase.instance.client;

  Future<void> setUserOnline(String userId) async {
    await _client.from('users').update({
      'is_online': true,
      'last_seen': DateTime.now().toIso8601String(),
    }).eq('id', userId);
  }

  Future<void> setUserOffline(String userId) async {
    await _client.from('users').update({
      'is_online': false,
      'last_seen': DateTime.now().toIso8601String(),
    }).eq('id', userId);
  }

  /// Stream to check real-time online status of a specific user
  Stream<bool> isUserOnline(String userId) {
    return _client
        .from('users')
        .stream(primaryKey: ['id'])
        .eq('id', userId)
        .map((users) {
          if (users.isEmpty) return false;
          final user = users.first;
          final lastSeen = DateTime.tryParse(user['last_seen'] ?? '') ?? DateTime(2000);
          final isOnline = DateTime.now().difference(lastSeen).inSeconds < 20;
          return isOnline;
        });
  }
}
