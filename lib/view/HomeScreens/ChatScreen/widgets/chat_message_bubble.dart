import 'package:flutter/material.dart';
import 'package:meeting_app/model/Models/message_model.dart';

class ChatMessageBubble extends StatelessWidget {
  final MessageModel message;
  final bool isMe;
  final String senderName;
  final String timeStr;

  const ChatMessageBubble({
    super.key,
    required this.message,
    required this.isMe,
    required this.senderName,
    required this.timeStr,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.75,
      ),
      decoration: BoxDecoration(
        color: isMe ? Colors.blueAccent : Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(16),
          topRight: const Radius.circular(16),
          bottomLeft: Radius.circular(isMe ? 16 : 0),
          bottomRight: Radius.circular(isMe ? 0 : 16),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            senderName,
            style: TextStyle(
              color: isMe ? Colors.white70 : Colors.blueGrey,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            message.content,
            style: TextStyle(
              color: isMe ? Colors.white : Colors.black87,
              fontSize: 15.5,
            ),
          ),
          const SizedBox(height: 6),
          Align(
            alignment: Alignment.bottomRight,
            child: Text(
              timeStr,
              style: TextStyle(
                fontSize: 11,
                color: isMe ? Colors.white70 : Colors.grey.shade600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
