import 'package:flutter/material.dart';

class ChatInputField extends StatelessWidget {
  final void Function(String) onSend;

  const ChatInputField({
    super.key,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = TextEditingController();

    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(28),
                ),
                child: TextField(
                  controller: controller,
                  maxLines: 4,
                  minLines: 1,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "Type a message...",
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () {
                final txt = controller.text.trim();
                if (txt.isNotEmpty) {
                  onSend(txt);
                  controller.clear();
                }
              },
              child: CircleAvatar(
                backgroundColor: Theme.of(context).primaryColor,
                radius: 22,
                child:  Icon(Icons.send, color:Theme.of(context).colorScheme.onPrimary, size: 20),
              ),
            )
          ],
        ),
      ),
    );
  }
}
