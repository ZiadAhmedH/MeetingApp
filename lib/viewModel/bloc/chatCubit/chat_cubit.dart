// chat_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meeting_app/model/Models/message_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  final SupabaseClient _supabase = Supabase.instance.client;
  final List<MessageModel> _messages = [];

  ChatCubit() : super(ChatInit());

  Future<void> loadMessages(String me, String other) async {
    emit(ChatLoading());
    final res = await _supabase
        .from('messages')
        .select()
        .or('sender_id.eq.$me,receiver_id.eq.$me')
        .order('created_at');

    _messages.clear();
    _messages.addAll((res as List)
        .map((e) => MessageModel.fromJson(e as Map<String, dynamic>))
        .where((m) =>
            (m.senderId == me && m.receiverId == other) ||
            (m.senderId == other && m.receiverId == me)));
    _messages.reversed.toList();
    emit(ChatLoaded(List.from(_messages)));
  }

  Future<void> sendMessage(String me, String other, String text) async {
    await _supabase
        .from('messages')
        .insert({'sender_id': me, 'receiver_id': other, 'content': text});
    _messages.add(MessageModel(
        id: '',
        senderId: me,
        receiverId: other,
        content: text,
        createdAt: DateTime.now()));
    emit(ChatLoaded(List.from(_messages)));
  }

 RealtimeChannel? _channel;

void subscribe(String myUid) {

  print('Subscribing to messages for user: $myUid');
   



  _channel = _supabase.channel('public:messages');

  _channel!
      .onPostgresChanges(
        event: PostgresChangeEvent.insert,
        schema: 'public',
        table: 'messages',
        filter: PostgresChangeFilter(
          type: PostgresChangeFilterType.eq,
          column: 'receiver_id',
          value: myUid,
        ),

        callback: (payload) async {
          final msg = MessageModel.fromJson(payload.newRecord);
            
          print('New message received: ${msg.content} from ${msg.senderId}');

          if (!isClosed) {
            _messages.add(msg);
            emit(ChatLoaded(List.from(_messages)));
          }
        },
      )
      .subscribe();
}







}
