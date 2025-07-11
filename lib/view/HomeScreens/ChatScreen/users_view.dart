import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meeting_app/core/utils/AppColor.dart';
import 'package:meeting_app/model/Models/UserModel.dart';
import 'package:meeting_app/view/HomeScreens/ChatScreen/ChatScreen.dart';
import 'package:meeting_app/viewModel/bloc/ProfileCubit/profile_cubit.dart';
import 'package:meeting_app/viewModel/data/SharedKeys.dart';
import 'package:meeting_app/viewModel/data/SharedPrefrences.dart';

class AllUsersView extends StatefulWidget {
  const AllUsersView({super.key});

  @override
  State<AllUsersView> createState() => _AllUsersViewState();
}

class _AllUsersViewState extends State<AllUsersView>
    with SingleTickerProviderStateMixin {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey();
  List<UserModel> _users = [];

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
          setState(() {
            _users = [];
          });

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
      },
    );
  }
}
