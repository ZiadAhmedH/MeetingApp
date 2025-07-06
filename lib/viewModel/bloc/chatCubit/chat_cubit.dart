import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meeting_app/model/Models/message_model.dart';
import 'package:meeting_app/services/notifcation_service.dart';
import 'package:meeting_app/viewModel/bloc/chatCubit/chat_state.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ChatCubit extends Cubit<ChatState> {
  final SupabaseClient supabase = Supabase.instance.client;

  ChatCubit() : super(ChatInitial());

  List<Message> messages = [];

  Future<void> loadMessages(String userId, String friendId) async {
    emit(ChatLoading());
    try {
      final res = await supabase
          .from('messages')
          .select()
          .or('sender_id.eq.$userId,receiver_id.eq.$userId')
          .order('created_at');

      messages = (res as List)
          .map((e) => Message.fromJson(e))
          .where((m) =>
              (m.senderId == userId && m.receiverId == friendId) ||
              (m.senderId == friendId && m.receiverId == userId))
          .toList();

      emit(MessagesLoaded(messages));
    } catch (e) {
      emit(ChatError("Error loading messages: $e"));
    }
  }

  Future<void> sendMessage(
      String senderId, String receiverId, String content) async {
    try {
      await supabase.from('messages').insert({
        'sender_id': senderId,
        'receiver_id': receiverId,
        'content': content,
      });
      emit(MessageSendSuccess());
    } catch (e) {
      emit(ChatError("Failed to send message: $e"));
    }
  }

  void subscribeToNewMessages(String userId) {
   supabase
  .channel('messages-realtime')
  .onPostgresChanges(
    event: PostgresChangeEvent.insert,
    schema: 'public',
    table: 'messages',
    callback: (payload) {
      final data = payload.newRecord;
      if (data['receiver_id'] == userId) {
        emit(NewMessageArrived(Message.fromJson(data)));
      }
    },
  )
  .subscribe();

  }

 void listenForIncomingMessages(String myUserId) {
  Supabase.instance.client
      .channel('public:messages')
      .onPostgresChanges(
        event: PostgresChangeEvent.insert,
        schema: 'public',
        table: 'messages',
        filter: 'receiver_id=eq.$myUserId' ,
        callback: (payload) {
          final data = payload.newRecord;
          final sender = data['sender_id'];
          final content = data['content'];
          NotificationService.showNotification(
            title: '📨 New message',
            body: 'From $sender: $content',
          );
        },
      )
      .subscribe();
}




}
