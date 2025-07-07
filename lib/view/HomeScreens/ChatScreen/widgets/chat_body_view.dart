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

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  String _formatDateHeader(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final msgDay = DateTime(date.year, date.month, date.day);

    if (msgDay == today) return 'Today';
    if (msgDay == today.subtract(const Duration(days: 1))) return 'Yesterday';
    return DateFormat('MMM dd, yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final chatCubit = context.read<ChatCubit>();

    return BlocBuilder<ChatCubit, ChatState>(
      builder: (_, state) {
        final messages = state is ChatLoaded ? state.messages : <MessageModel>[];

        return Container(
          child: Column(
            children: [
              // --- Chat List ---
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: messages.length,
                  itemBuilder: (_, i) {
                    final m = messages[i];
                    final isMe = m.senderId == me;
                    final showHeader = i == 0 ||
                        !_isSameDay(m.createdAt, messages[i - 1].createdAt);
                    final timeStr =
                        DateFormat('MMM d, h:mm a').format(m.createdAt);

                    return Column(
                      crossAxisAlignment: isMe
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                      children: [
                        if (showHeader)
                          Center(
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                _formatDateHeader(m.createdAt),
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
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

              // --- Input Field ---
              ChatInputField(
                onSend: (txt) {
                  chatCubit.sendMessage(me, other, txt);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
