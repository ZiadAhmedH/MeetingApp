import 'dart:async';

import 'package:meeting_app/model/Models/UserModel.dart';
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

  Stream<UserModel> subscribeToUserStatus(String userId) {
  return _client
      .from('users')
      .stream(primaryKey: ['id'])
      .map((event) {
        final userJson = event.firstWhere(
          (e) => e['id'] == userId,
          orElse: () => <String, dynamic>{},
        );
        if (userJson.isEmpty) {
          throw Exception('User not found');
        }
        return UserModel.fromJson(userJson);
      });
}




}
