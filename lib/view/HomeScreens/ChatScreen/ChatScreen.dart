import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meeting_app/model/Models/UserModel.dart';
import 'package:meeting_app/view/HomeScreens/ChatScreen/widgets/chat_body_view.dart';
import 'package:meeting_app/viewModel/bloc/chatCubit/chat_cubit.dart';

class ChatView extends StatelessWidget {
  final String myUid;
  final UserModel otherUser;
  

  const ChatView({super.key, required this.myUid, required this.otherUser});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ChatCubit()
        ..loadMessages(myUid, otherUser.uid)..subscribe(myUid),
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
           
           title: Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: Colors.grey,
                child: CircleAvatar(
                  radius: 20,
                  backgroundImage: otherUser.profileImage != null
                      ? NetworkImage(otherUser.profileImage!)
                      : null,
                  child: otherUser.profileImage == null
                      ? Icon(Icons.person, size: 16, color: Colors.grey[600])
                      : null,
                ),
              ),
              SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(otherUser.userName),

                  Text(
                    otherUser.isOnline ? "Online" : "Offline",
                    style: TextStyle(
                      fontSize: 12,
                      color: otherUser.isOnline ? Colors.green : Colors.grey,
                    ),
                  ),
                ],
              ),
            ],
            
           ),

        ),
        body: ChatBodyView(me: myUid, other: otherUser.uid ,otherUser:otherUser , ),
      ),
    );
  }
}
