import 'package:flutter/material.dart';
import 'package:meeting_app/view/HomeScreens/ChatScreen/widgets/users_body_view.dart';

class UsersView extends StatelessWidget {
  const UsersView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     
      body: AllUsersBodyView(),
    );
  }
}