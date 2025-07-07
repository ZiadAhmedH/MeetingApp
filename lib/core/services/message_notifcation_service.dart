import 'package:meeting_app/core/services/notifcation_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:meeting_app/model/Models/message_model.dart';

class MessageNotificationService {
  static final _supabase = Supabase.instance.client;
  static RealtimeChannel? _channel;

  static void subscribeToMessages(String currentUserId) {
    if (_channel != null) return;

    print('✅ Subscribing to messages for user: $currentUserId');

    _channel = _supabase
        .channel('public:messages')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'messages',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'receiver_id',
            value: currentUserId,
          ),
          callback: (payload) async {
            final msg = MessageModel.fromJson(payload.newRecord);
            final sender = await _getSenderName(msg.senderId);

            // 👇 Pass senderId and name in payload
            final payloadData = '${msg.senderId},$sender';

            NotificationService.show(sender, msg.content, payload: payloadData);
          },
        )
        .subscribe();
  }

  static Future<String> _getSenderName(String uid) async {
    final response = await _supabase
        .from('users')
        .select('username')
        .eq('id', uid)
        .single();
    return response['username'] ?? 'New Message';
  }

  static void dispose() {
    if (_channel != null) {
      _supabase.removeChannel(_channel!);
      _channel = null;
    }
  }
}
