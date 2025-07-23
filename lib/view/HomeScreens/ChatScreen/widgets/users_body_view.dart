import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meeting_app/core/services/state_user_service.dart';
import 'package:meeting_app/core/utils/AppColor.dart';
import 'package:meeting_app/model/Models/UserModel.dart';
import 'package:meeting_app/view/HomeScreens/ChatScreen/ChatScreen.dart';
import 'package:meeting_app/viewModel/bloc/ProfileCubit/profile_cubit.dart';
import 'package:meeting_app/viewModel/data/SharedKeys.dart';
import 'package:meeting_app/viewModel/data/SharedPrefrences.dart';

final userStatusService = UserStatusService();

class AllUsersBodyView extends StatefulWidget {
  const AllUsersBodyView({super.key});

  @override
  State<AllUsersBodyView> createState() => _AllUsersViewState();
}

class _AllUsersViewState extends State<AllUsersBodyView> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey();
  final List<UserModel> _users = [];

  @override
  void initState() {
    super.initState();
    ProfileCubit.get(context).loadAllUsers();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileState>(
      listener: (context, state) async {
        if (state is UsersLoaded) {
          _users.clear();
          for (int i = 0; i < state.users.length; i++) {
            await Future.delayed(const Duration(milliseconds: 150));
            _users.insert(i, state.users[i]);
            _listKey.currentState?.insertItem(i);
          }
        }
      },
      builder: (context, state) {
        if (state is UsersLoading) {
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
                Tween<Offset>(
                  begin: const Offset(1, 0),
                  end: Offset.zero,
                ).chain(CurveTween(curve: Curves.easeOut)),
              ),
              child: FadeTransition(
                opacity: animation,
                child: ListTile(
                  leading: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        radius: 25,
                        backgroundColor: Colors.grey.shade300,
                        backgroundImage: user.profileImage != null && user.profileImage!.isNotEmpty
                            ? NetworkImage(user.profileImage!)
                            : null,
                        child: (user.profileImage == null || user.profileImage!.isEmpty)
                            ? const Icon(Icons.person, color: Colors.white)
                            : null,
                      ),
                      StreamBuilder<bool>(
                        stream: userStatusService.isUserOnline(user.uid),
                        builder: (context, snapshot) {
                          final isOnline = snapshot.data ?? false;
                          return CircleAvatar(
                            radius: 6,
                            backgroundColor: Colors.white,
                            child: CircleAvatar(
                              radius: 4.5,
                              backgroundColor: isOnline ? Colors.green : Colors.grey,
                            ),
                          );
                        },
                      ),
                    ],
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
      },
    );
  }
}
