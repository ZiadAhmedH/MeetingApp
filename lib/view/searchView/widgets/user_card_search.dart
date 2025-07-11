import 'package:flutter/material.dart';
import 'package:meeting_app/model/Models/UserModel.dart';
import 'package:meeting_app/view/HomeScreens/ChatScreen/ChatScreen.dart';
import 'package:meeting_app/viewModel/data/SharedKeys.dart';
import 'package:meeting_app/viewModel/data/SharedPrefrences.dart';

class UserCardSearch extends StatelessWidget {
  final UserModel user;
  const UserCardSearch({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        leading: user.profileImage != null && user.profileImage!.isNotEmpty
            ? CircleAvatar(
                radius: 24,
                backgroundImage: NetworkImage(user.profileImage!),
              )
            : CircleAvatar(
                radius: 24,
                backgroundColor: theme.primaryColorDark,
                child: Text(
                  user.userName.isNotEmpty
                      ? user.userName.split(' ').map((e) => e[0]).take(2).join()
                      : '',
                  style: textTheme.bodyLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
        title: Text(
          user.userName,
          style: textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.primaryColorLight,
          ),
        ),
        subtitle: Text(
          user.jobTitle,
          style: textTheme.bodyMedium?.copyWith(
            color: theme.hintColor,
          ),
        ),
        onTap: () {
          final myUid = LocalData.getData(key: SharedKey.uid)!;
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ChatView(
                myUid: myUid,
                otherUser: user,
              ),
            ),
          );
        },
      ),
    );
  }
}
