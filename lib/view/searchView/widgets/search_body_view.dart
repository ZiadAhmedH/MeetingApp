import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meeting_app/viewModel/bloc/ProfileCubit/profile_cubit.dart';
import 'Loading_user_shimmer.dart';
import 'package:meeting_app/view/HomeScreens/ChatScreen/ChatScreen.dart';
import 'package:meeting_app/viewModel/data/SharedKeys.dart';
import 'package:meeting_app/viewModel/data/SharedPrefrences.dart';

class SearchBodyView extends StatelessWidget {
  const SearchBodyView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Container(
      color: theme.scaffoldBackgroundColor,
      child: Column(
        children: [
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              style: textTheme.bodyLarge?.copyWith(color: theme.primaryColorLight),
              decoration: InputDecoration(
                hintText: 'Search',
                hintStyle: textTheme.bodyMedium?.copyWith(color: theme.hintColor),
                filled: true,
                fillColor: theme.cardColor,
                prefixIcon: Icon(Icons.search, color: theme.iconTheme.color?.withOpacity(0.6)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
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
                    itemBuilder: (context, index) {
                      return const LoadingUserShimmer();
                    },
                  );
                } else if (state is SearchError) {
                  return Center(
                    child: Text(
                      state.message,
                      style: textTheme.bodyMedium?.copyWith(color: Colors.red),
                    ),
                  );
                } else if (state is SearchSuccess) {
                  final users = state.users;
                  if (users.isEmpty) {
                    return Center(
                      child: Text(
                        "No users found.",
                        style: textTheme.bodyMedium?.copyWith(color: theme.disabledColor),
                      ),
                    );
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: users.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final user = users[index];
                      return Container(
                        decoration: BoxDecoration(
                          color: theme.cardColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          leading: user.profileImage != null &&
                                  user.profileImage!.isNotEmpty
                              ? CircleAvatar(
                                  radius: 24,
                                  backgroundImage: NetworkImage(user.profileImage!),
                                )
                              : CircleAvatar(
                                  radius: 24,
                                  backgroundColor: theme.primaryColorDark,
                                  child: Text(
                                    user.userName.isNotEmpty
                                        ? user.userName
                                            .split(' ')
                                            .map((e) => e[0])
                                            .take(2)
                                            .join()
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
                    },
                  );
                }

                return Center(
                  child: Text(
                    "Search for users to start chatting.",
                    style: textTheme.bodyMedium?.copyWith(color: theme.hintColor),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
