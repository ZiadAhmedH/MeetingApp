import 'package:flutter/material.dart';

class JoinBodyView extends StatelessWidget {
  const JoinBodyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Center(
        child: Text(
          'Join Meeting Screen',
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
      ),
    );
  }
}