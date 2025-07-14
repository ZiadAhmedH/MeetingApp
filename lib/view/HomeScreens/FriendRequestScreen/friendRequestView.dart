import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meeting_app/viewModel/bloc/ProfileCubit/profile_cubit.dart';

class FriendRequestsView extends StatelessWidget {
  const FriendRequestsView({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ProfileCubit>();

    return BlocBuilder<ProfileCubit, ProfileState>(
      bloc: cubit..loadPendingFriendRequests(),
      builder: (context, state) {
        final requests = cubit.pendingRequests;

        if (state is FriendRequestsLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (requests.isEmpty) {
          return const Center(child: Text("No pending friend requests."));
        }

        return ListView.builder(
          itemCount: requests.length,
          itemBuilder: (context, index) {
            final req = requests[index];
            final requester = req['user'];

            return ListTile(
              leading: CircleAvatar(
                backgroundImage:
                    NetworkImage(requester['profile_image'] ?? ""),
              ),
              title: Text(requester['username'] ?? 'User'),
              subtitle: Text(requester['job_title'] ?? ''),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.check, color: Colors.green),
                    onPressed: () {
                      cubit.acceptFriend(requester['id']);
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.red),
                    onPressed: () {
                      cubit.rejectFriend(requester['id']);
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
