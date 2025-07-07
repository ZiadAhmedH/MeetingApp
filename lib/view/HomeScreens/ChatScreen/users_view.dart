import 'package:flutter/material.dart';
import 'package:meeting_app/core/utils/AppColor.dart';
import 'package:meeting_app/model/Models/UserModel.dart';
import 'package:meeting_app/view/HomeScreens/ChatScreen/ChatScreen.dart';
import 'package:meeting_app/viewModel/data/SharedKeys.dart';
import 'package:meeting_app/viewModel/data/SharedPrefrences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AllUsersView extends StatefulWidget {
  const AllUsersView({super.key});

  @override
  State<AllUsersView> createState() => _AllUsersViewState();
}

class _AllUsersViewState extends State<AllUsersView>
    with SingleTickerProviderStateMixin {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey();
  late final AnimationController _controller;

  List<UserModel> _users = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    final myUid = LocalData.getData(key: SharedKey.uid);
    final res = await Supabase.instance.client
        .from('users')
        .select('*')
        .not('id', 'eq', myUid);

    final fetchedUsers =
        (res as List).map((e) => UserModel.fromJson(e)).toList();

    setState(() {
      _users = [];
      _loading = false;
    });

    for (int i = 0; i < fetchedUsers.length; i++) {
      await Future.delayed(Duration(milliseconds: 200));
      _users.insert(i, fetchedUsers[i]);
      _listKey.currentState?.insertItem(i);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(
          child: CircularProgressIndicator(color: AppColor.blueAccent));
    }

    return AnimatedList(
      key: _listKey,
      initialItemCount: _users.length,
      itemBuilder: (context, index, animation) {
        final user = _users[index];
        return SlideTransition(
          position: animation.drive(
            Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero)
                .chain(CurveTween(curve: Curves.easeOut)),
          ),
          child: FadeTransition(
            opacity: animation,
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(user.profileImage ?? ''),
              ),
              title: Text(user.userName),
              subtitle: Text(user.email),
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
          
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
