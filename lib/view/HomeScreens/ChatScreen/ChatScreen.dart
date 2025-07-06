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
        ..loadMessages(myUid, otherUser.uid!)..subscribe(myUid),
      child: Scaffold(
        appBar: AppBar(title: Text(otherUser.userName)),
        body: ChatBodyView(me: myUid, other: otherUser.uid!),
      ),
    );
  }
}
