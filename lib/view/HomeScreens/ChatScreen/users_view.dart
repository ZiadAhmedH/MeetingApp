import 'package:flutter/material.dart';
import 'package:meeting_app/model/Models/UserModel.dart';
import 'package:meeting_app/view/HomeScreens/ChatScreen/ChatScreen.dart';
import 'package:meeting_app/viewModel/data/SharedKeys.dart';
import 'package:meeting_app/viewModel/data/SharedPrefrences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AllUsersView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final myUid = LocalData.getData(key: SharedKey.uid);
   
   Future<List<UserModel>> getAllUsersExceptMe(String myUid) async {
  final res = await Supabase.instance.client
      .from('users')
      .select('*')
      .not('id', 'eq', myUid);

  return (res as List).map((e) => UserModel.fromJson(e)).toList();
}



    return FutureBuilder<List<UserModel>>(
      future: getAllUsersExceptMe(myUid),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const CircularProgressIndicator();

        final users = snapshot.data!;
        return ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) {
            final otherUser = users[index];
            return ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(otherUser.profileImage ?? ''),
              ),
              title: Text(otherUser.userName),
              subtitle: Text(otherUser.email),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ChatView(
                      myUid: myUid!,
                      otherUser: otherUser,
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
