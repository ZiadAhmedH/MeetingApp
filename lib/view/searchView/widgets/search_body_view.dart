import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meeting_app/model/Models/UserModel.dart';
import 'package:meeting_app/viewModel/bloc/ProfileCubit/profile_cubit.dart';

class SearchBodyView extends StatelessWidget {
  const SearchBodyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: TextField(
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Search for users',
              hintStyle: const TextStyle(color: Colors.white54),
              filled: true,
              fillColor: const Color(0xFF1F2937),
              prefixIcon: const Icon(Icons.search, color: Colors.white54),
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
                return const Center(child: CircularProgressIndicator());
              } else if (state is SearchError) {
                return Center(
                  child: Text(
                    state.message,
                    style: const TextStyle(color: Colors.red),
                  ),
                );
              } else if (state is SearchSuccess) {
                final users = state.users;
                if (users.isEmpty) {
                  return const Center(
                    child: Text(
                      "No users found.",
                      style: TextStyle(color: Colors.white54),
                    ),
                  );
                }
                return ListView.separated(
                  itemCount: users.length,
                  separatorBuilder: (_, __) => const Divider(color: Colors.white12, height: 1),
                  itemBuilder: (context, index) {
                    final user = users[index];
                    return ListTile(
                      leading: user.profileImage != null && user.profileImage!.isNotEmpty
                          ? CircleAvatar(
                              radius: 24,
                              backgroundImage: NetworkImage(user.profileImage!),
                            )
                          : CircleAvatar(
                              radius: 24,
                              backgroundColor: Colors.blueGrey,
                              child: Text(
                                user.userName.isNotEmpty
                                    ? user.userName.split(' ').map((e) => e[0]).take(2).join()
                                    : '',
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                            ),
                      title: Text(
                        user.userName,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                      ),
                      subtitle: Text(
                        user.jobTitle,
                        style: const TextStyle(color: Colors.white54),
                      ),
                      onTap: () {
                        // Handle user tap
                      },
                    );
                  },
                );
              }
              return const SizedBox();
            },
          ),
        ),
      ],
    );
  }
}
