import 'package:flutter/material.dart';
import 'package:meeting_app/model/Models/message_model.dart';
import 'package:meeting_app/viewModel/data/SharedKeys.dart';
import 'package:meeting_app/viewModel/data/SharedPrefrences.dart';

class ChatMessageBubble extends StatelessWidget {
  final MessageModel message;
  final bool isMe;
  final String timeStr;
  final String senderName;
  final String otherUserImage;

  const ChatMessageBubble({
    super.key,
    required this.message,
    required this.isMe,
    required this.timeStr,
    required this.senderName,
    required this.otherUserImage,
  });

  @override
  Widget build(BuildContext context) {
    final userImage = LocalData.getData(key: SharedKey.userImage) ?? '';
    
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 2),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // Avatar for other person (left side)
            if (!isMe) ...[
              CircleAvatar(
                radius: 16,
                backgroundColor: Colors.grey[300],
                backgroundImage: userImage.isNotEmpty 
                    ? NetworkImage(otherUserImage) 
                    : null,
                child: otherUserImage.isEmpty 
                    ? Icon(Icons.person, size: 16, color: Colors.grey[600])
                    : null,
              ),
              SizedBox(width: 8),
            ],
            
            // Message bubble
            Flexible(
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.75,
                ),
                decoration: BoxDecoration(
                  color: isMe 
                      ? Color(0xFF2973F6) // Blue for sent messages
                      : Color(0xFF48485A), // Dark grey for received
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(18),
                    topRight: Radius.circular(18),
                    bottomLeft: Radius.circular(isMe ? 18 : 4),
                    bottomRight: Radius.circular(isMe ? 4 : 18),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Sender name (for group chats)
                    if (!isMe)
                      Padding(
                        padding: EdgeInsets.fromLTRB(12, 8, 12, 0),
                        child: Text(
                          senderName,
                          style: TextStyle(
                            color: Colors.blueAccent, // Blue accent for sender name
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    
                    // Message content
                    if (message.content.isNotEmpty)
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                          12, 
                          !isMe ? 4 : 8, 
                          12, 
                          4
                        ),
                        child: Text(
                          message.content,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            height: 1.3,
                          ),
                        ),
                      ),
                    
                    // Time and status row
                    Padding(
                      padding: EdgeInsets.fromLTRB(12, 0, 12, 8),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            timeStr,
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                          if (isMe) ...[
                            SizedBox(width: 4),
                            Icon(
                              Icons.done_all,
                              color: Colors.lightBlueAccent, // Light blue for read status
                              size: 16,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Avatar for me (right side) - optional
            if (isMe) ...[
              SizedBox(width: 8),
              CircleAvatar(
                radius: 16,
                backgroundColor: Color(0xFF2973F6), // Blue background for my avatar
                backgroundImage: userImage.isNotEmpty 
                    ? NetworkImage(userImage) 
                    : null,
                child: userImage.isEmpty 
                    ? Icon(Icons.person, size: 16, color: Colors.white)
                    : null,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
