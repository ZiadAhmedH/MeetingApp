import 'package:meeting_app/model/Models/message_model.dart';

abstract class ChatState {}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {}

class MessagesLoaded extends ChatState {
  final List<Message> messages;
  MessagesLoaded(this.messages);
}

class NewMessageArrived extends ChatState {
  final Message message;
  NewMessageArrived(this.message);
}

class MessageSendSuccess extends ChatState {}

class ChatError extends ChatState {
  final String message;
  ChatError(this.message);
}
