import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:meeting_app/model/Models/message_model.dart';
import 'package:meeting_app/view/HomeScreens/ChatScreen/widgets/chat_input_field.dart';
import 'package:meeting_app/view/HomeScreens/ChatScreen/widgets/chat_message_bubble.dart';
import 'package:meeting_app/viewModel/bloc/chatCubit/chat_cubit.dart';
import 'package:meeting_app/viewModel/bloc/chatCubit/chat_state.dart';

class ChatBodyView extends StatelessWidget {
  final String me;
  final String other;
  final String otherName;

  const ChatBodyView({
    super.key,
    required this.me,
    required this.other,
    required this.otherName,
  });


  @override
  Widget build(BuildContext context) {
    final chatCubit = context.read<ChatCubit>();

    return BlocBuilder<ChatCubit, ChatState>(
      builder: (_, state) {
        final messages =
            state is ChatLoaded ? state.messages : <MessageModel>[];
        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: messages.length,
                itemBuilder: (_, i) {
                  final m = messages[i];
                  final isMe = m.senderId == me;
                
                  final timeStr =
                      DateFormat('MMM d, h:mm a').format(m.createdAt);

                  return Column(
                    crossAxisAlignment: isMe
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    children: [
                      ChatMessageBubble(
                        message: m,
                        isMe: isMe,
                        senderName: isMe ? 'You' : otherName,
                        timeStr: timeStr,
                      ),
                    ],
                  );
                },
              ),
            ),
            ChatInputField(
              onSend: (txt) {
                chatCubit.sendMessage(me, other, txt);
              },
            ),
          ],
        );
      },
    );
  }
}
