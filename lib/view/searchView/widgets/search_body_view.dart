import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meeting_app/viewModel/bloc/ProfileCubit/profile_cubit.dart';
import 'package:meeting_app/viewModel/data/SharedKeys.dart';
import 'package:meeting_app/viewModel/data/SharedPrefrences.dart';
import 'package:meeting_app/view/HomeScreens/ChatScreen/ChatScreen.dart';
import 'Loading_user_shimmer.dart';

class SearchBodyView extends StatelessWidget {
  const SearchBodyView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Column(
      children: [
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: TextField(
            style: textTheme.bodyLarge?.copyWith(color: theme.primaryColorLight),
            decoration: InputDecoration(
              hintText: 'Search',
              filled: true,
              fillColor: theme.cardColor,
              hintStyle: textTheme.bodyMedium?.copyWith(color: theme.hintColor),
              prefixIcon: Icon(Icons.search, color: theme.iconTheme.color , size: 22),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: theme.primaryColor, width: 1.5),
              ),
            ),
            onChanged: (value) {
              context.read<ProfileCubit>().searchUser(value);
            },
          ),
        ),
        const SizedBox(height: 20),
        Expanded(
          child: BlocBuilder<ProfileCubit, ProfileState>(
            builder: (context, state) {
              if (state is SearchLoading) {
                return ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: 10,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (_, __) => const LoadingUserShimmer(),
                );
              }

              if (state is SearchSuccess) {
                final users = state.users;
                final statuses = state.friendStatuses;

                if (users.isEmpty) {
                  return Center(
                    child: Text("No users found.",
                        style: textTheme.bodyMedium?.copyWith(color: theme.disabledColor)),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: users.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (_, index) {
                    final user = users[index];
                    final status = statuses[user.uid]; // Can be null

                    return Container(
                      decoration: BoxDecoration(
                        color: theme.cardColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        leading: _buildAvatar(user, theme, textTheme),
                        title: Text(user.userName,
                            style: textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.bold, color: theme.primaryColorLight)),
                        subtitle: Text(user.jobTitle,
                            style: textTheme.bodyMedium?.copyWith(color: theme.hintColor)),
                        trailing: _buildFriendStatusIcon(context, status, user.uid, theme),
                        onTap: () {
                          final myUid = LocalData.getData(key: SharedKey.uid)!;
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ChatView(myUid: myUid, otherUser: user),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              }

              if (state is SearchError) {
                return Center(
                  child: Text(state.message,
                      style: textTheme.bodyMedium?.copyWith(color: Colors.red)),
                );
              }

              return Center(
                child: Text("Search for users to start chatting.",
                    style: textTheme.bodyMedium?.copyWith(color: theme.hintColor)),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAvatar(user, ThemeData theme, TextTheme textTheme) {
    return user.profileImage != null && user.profileImage!.isNotEmpty
        ? CircleAvatar(radius: 24, backgroundImage: NetworkImage(user.profileImage!))
        : CircleAvatar(
            radius: 24,
            backgroundColor: theme.primaryColorDark,
            child: Text(
              user.userName.isNotEmpty
                  ? user.userName.split(' ').map((e) => e[0]).take(2).join()
                  : '',
              style: textTheme.bodyLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          );
  }

  Widget _buildFriendStatusIcon(BuildContext context, String? status, String friendId, ThemeData theme) {
    if (status == 'accepted') {
      return const Icon(Icons.check_circle, color: Colors.green);
    } else if (status == 'pending') {
      return const Icon(Icons.hourglass_top, color: Colors.orange);
    } else {
      return IconButton(
        icon: const Icon(Icons.person_add_alt_1),
        color: theme.primaryColor,
        onPressed: () {
          context.read<ProfileCubit>().addFriend(friendId);
        },
      );
    }
  }
}
