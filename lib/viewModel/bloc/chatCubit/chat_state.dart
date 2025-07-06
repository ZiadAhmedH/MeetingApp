// chat_state.dart

import 'package:meeting_app/model/Models/message_model.dart';

abstract class ChatState {}
class ChatInit extends ChatState {}
class ChatLoading extends ChatState {}
class ChatLoaded extends ChatState {
  final List<Message> messages;
  ChatLoaded(this.messages);
}
class ChatError extends ChatState {
  final String error;
  ChatError(this.error);
}
