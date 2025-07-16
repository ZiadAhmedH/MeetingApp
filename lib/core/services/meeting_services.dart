import 'package:supabase_flutter/supabase_flutter.dart';
import '../../model/Models/meetingHistoryModel.dart';

class MeetingService {
  final SupabaseClient _client = Supabase.instance.client;

  Future<void> createMeeting({
    required String meetingId,
  }) async {
    await _client.from('meetings').insert({
      'id': meetingId,
      'host_id': _client.auth.currentUser!.id,
      'title': 'Meeting $meetingId',
      'description': '',
      'created_at': DateTime.now().toIso8601String(),
      'ended_at': DateTime.now().toIso8601String(),
    });
  }

  Future<void> putItForOutgoingMeeting(String meetingId) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return;
    await _client.from('outgoing_meetings').insert({
      'id': meetingId,
      'host_id': userId,
      'meeting_name': 'Meeting $meetingId',
      'start_time': DateTime.now().toIso8601String(),
    });
  }

  Future<void> deleteOutgoingMeeting(String meetingId) async {
    await _client.from('outgoing_meetings').delete().eq('id', meetingId);
  }

  Stream<List<Map<String, dynamic>>> getLiveOutgoingMeetings() {
    return _client
        .from('outgoing_meetings')
        .stream(primaryKey: ['id'])
        .order('start_time');
  }

  Future<List<Meetinghistorymodel>> getMeetingHistory(String userId) async {
    final response = await _client
        .from('meetings')
        .select()
        .eq('host_id', userId)
        .order('created_at', ascending: false);

    final data = response as List<dynamic>;
    return data.map((json) => Meetinghistorymodel.fromJson(json)).toList();
  }

  Future<void> logJoinEvent(String meetingId) async {
    final user = _client.auth.currentUser!;
    await _client.from('participants').insert({
      'meeting_id': meetingId,
      'participant_id': user.id,
      'joined_at': DateTime.now().toIso8601String(),
    });
  }

  Future<void> updateMeetingDuration(String meetingId, int durationMin) async {
    await _client
        .from('meetings')
        .update({'ended_at': durationMin}).eq('id', meetingId);
  }
}
