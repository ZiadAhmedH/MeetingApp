import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:meeting_app/model/Models/UserModel.dart';
import 'package:meeting_app/model/Models/message_model.dart';
import 'package:meeting_app/view/HomeScreens/ChatScreen/widgets/animated_message.dart';
import 'package:meeting_app/view/HomeScreens/ChatScreen/widgets/chat_input_field.dart';
import 'package:meeting_app/view/HomeScreens/ChatScreen/widgets/chat_message_bubble.dart';
import 'package:meeting_app/viewModel/bloc/chatCubit/chat_cubit.dart';
import 'package:meeting_app/viewModel/bloc/chatCubit/chat_state.dart';

class ChatBodyView extends StatelessWidget {
  final String me;
  final String other;
  final UserModel otherUser;

  const ChatBodyView({
    super.key,
    required this.me,
    required this.other,
    required this.otherUser,
  });

  @override
  Widget build(BuildContext context) {
    final chatCubit = context.read<ChatCubit>();

    return BlocBuilder<ChatCubit, ChatState>(
      builder: (_, state) {
        final messages = state is ChatLoaded ? state.messages : <MessageModel>[];

        return Column(
          children: [
            Expanded(
              child: CustomScrollView(
                slivers: [
                  SliverList.builder(
                    itemCount: messages.length,
                    itemBuilder: (context, i) {
                      final m = messages[i];
                      final isMe = m.senderId == me;
                      final timeStr = DateFormat('h:mm a').format(m.createdAt);
                      
                      final currDate = getDateGroupLabel(m.createdAt);
                      final prevDate = i > 0
                          ? getDateGroupLabel(messages[i - 1].createdAt)
                          : null;
                      final showDateLabel = (prevDate != currDate);

                      return Column(
                        children: [
                          if (i == 0 || showDateLabel)
                            _buildDateHeader(currDate),
                          AnimatedMessage(
                            fromLeft: !isMe,
                            child: ChatMessageBubble(
                              message: m,
                              isMe: isMe,
                              senderName: isMe ? 'You' : otherUser.userName,
                              timeStr: timeStr,
                               otherUserImage: otherUser.profileImage ?? '',
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
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

  Widget _buildDateHeader(String date) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            date,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}

String getDateGroupLabel(DateTime date) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final messageDate = DateTime(date.year, date.month, date.day);
  final difference = today.difference(messageDate).inDays;

  if (difference == 0) return 'Today';
  if (difference == 1) return 'Yesterday';
  return DateFormat('MMM d, yyyy').format(date);
}
