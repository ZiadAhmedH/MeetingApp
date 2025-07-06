// chat_body_view.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meeting_app/model/Models/message_model.dart';
import 'package:meeting_app/viewModel/bloc/chatCubit/chat_cubit.dart';
import 'package:meeting_app/viewModel/bloc/chatCubit/chat_state.dart';

class ChatBodyView extends StatefulWidget {
  final String me, other;
  const ChatBodyView({required this.me, required this.other});

  @override
  _ChatBodyViewState createState() => _ChatBodyViewState();
}

class _ChatBodyViewState extends State<ChatBodyView> {
  final _ctrl = TextEditingController();

  @override
  Widget build(BuildContext c) {
    return BlocBuilder<ChatCubit, ChatState>(
      builder: (_, state) {
        List<Message> msgs = [];
        if (state is ChatLoaded) msgs = state.messages;

        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                reverse: true, itemCount: msgs.length,
                itemBuilder: (_, i) {
                  final m = msgs[msgs.length - i - 1];
                  final align = m.senderId == widget.me ? CrossAxisAlignment.end : CrossAxisAlignment.start;
                  final color = m.senderId == widget.me ? Colors.blue[300] : Colors.grey[300];
                  return Row(
                    mainAxisAlignment: m.senderId == widget.me ? MainAxisAlignment.end : MainAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                        decoration: BoxDecoration(
                          color: color, borderRadius: BorderRadius.circular(12)),
                        child: Text(m.content),
                      )
                    ],
                  );
                },
              ),
            ),
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Row(children: [
                Expanded(child: TextField(controller: _ctrl, decoration: const InputDecoration(hintText: 'Type...'))),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    final txt = _ctrl.text.trim();
                    if (txt.isNotEmpty) {
                      context.read<ChatCubit>().sendMessage(widget.me, widget.other, txt);
                      _ctrl.clear();
                    }
                  },
                ),
              ]),
            )
          ],
        );
      },
    );
  }
}
