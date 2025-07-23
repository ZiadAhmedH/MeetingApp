import 'package:flutter/material.dart';

class ChatInputField extends StatelessWidget {
  final void Function(String) onSend;

  const ChatInputField({
    super.key,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController();

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF313143), // Slightly lighter than background
            borderRadius: BorderRadius.circular(25),
          ),
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14.0),
                  child: TextField(
                    controller: controller,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                    maxLines: 4,
                    minLines: 1,
                    decoration: const InputDecoration(
                      hintText: "Thank you !!",
                      hintStyle: TextStyle(
                        color: Color(0xFFAAAAAA),
                        fontSize: 16,
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 4.0),
                child: GestureDetector(
                  onTap: () {
                    final text = controller.text.trim();
                    if (text.isNotEmpty) {
                      onSend(text);
                      controller.clear();
                    }
                  },
                  child: CircleAvatar(
                    backgroundColor: const Color(0xFF2973F6), // Blue send
                    radius: 22,
                    child: const Icon(
                      Icons.send,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
