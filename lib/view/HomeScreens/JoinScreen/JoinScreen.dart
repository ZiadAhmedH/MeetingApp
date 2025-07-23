import 'package:flutter/material.dart';
import 'package:meeting_app/view/HomeScreens/JoinScreen/widgets/join_body_view.dart';

class JoinView extends StatelessWidget {
  const JoinView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(child: JoinBodyView()),
    );
  }
}
