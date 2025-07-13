import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:meeting_app/core/components/CustomText.dart';
import 'package:meeting_app/core/utils/AppColor.dart';
import 'package:meeting_app/core/utils/ThemeExtension.dart';
import 'package:meeting_app/view/HomeScreens/HomeSections/MainHomeSection.dart';
import 'package:meeting_app/viewModel/bloc/MeetingCubit/meeting_cubit.dart';

class MeetingHistorySection extends StatelessWidget {
  final String userId;

  const MeetingHistorySection({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MeetingCubit()..getMeetingHistory(userId: userId),
      child: BlocBuilder<MeetingCubit, MeetingState>(
        builder: (context, state) {
          if (state is MeetingHistoryLoadingState) {
            return Center(
              child: LoadingAnimationWidget.dotsTriangle(
                  color: AppColor.blue, size: 50),
            );
          } else if (state is MeetingHistoryLoadedState) {
            final meetings = state.meetings;

            if (meetings.isEmpty) {
              return Center(
                child: Column(
                  children: [
                    Image.asset("assets/images/people.png", width: 250),
                    CustomText(
                      text: 'No Meeting Scheduled',
                      fontSize: 20,
                      fontWeight: FontWeight.normal,
                      color: context.thirdTextColor,
                      fontFamily: 'Gilroy',
                    ),
                  ],
                ),
              );
            }

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                        text: 'Meeting History',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: context.primaryTextColor,
                      ),
                      IconButton(
                        icon: const FaIcon(FontAwesomeIcons.refresh),
                        onPressed: () {
                          MeetingCubit.get(context).getMeetingHistory(userId: userId);
                        },
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: CustomScrollView(
                    slivers: [
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final meeting = meetings[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: AppColor.primaryBlue,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: const FaIcon(
                                        FontAwesomeIcons.video,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          CustomText(
                                            text: meeting.meetingName,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                          const SizedBox(height: 4),
                                          CustomText(
                                            text:
                                                'Scheduled on ${formatMeetingDate(meeting.createdAt.toIso8601String())}',
                                            fontSize: 13,
                                            fontWeight: FontWeight.normal,
                                            color: Colors.white.withOpacity(0.85),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                          childCount: meetings.length,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          } else if (state is MeetingHistoryErrorState) {
            return Center(child: Text('Error: ${state.errorMessage}'));
          }

          return Container();
        },
      ),
    );
  }
}
