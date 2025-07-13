import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:meeting_app/core/utils/ThemeExtension.dart';
import 'package:meeting_app/viewModel/bloc/MeetingCubit/meeting_cubit.dart';
import 'package:meeting_app/viewModel/bloc/ProfileCubit/profile_cubit.dart';
import 'package:meeting_app/viewModel/data/SharedKeys.dart';
import 'package:meeting_app/viewModel/data/SharedPrefrences.dart';
import '../../../core/components/CustomText.dart';
import '../../../core/utils/AppColor.dart';
import 'AppBar_Section/AppBarHomeSection.dart';
import 'AppBar_Section/NavBar.dart';

class MainHomeSection extends StatelessWidget {
  const MainHomeSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MeetingCubit, MeetingState>(
      builder: (context, state) {
        return Column(
          children: [
            const MeetingSection(),
            const Divider(color: AppColor.darkGrey, thickness: 1),
            Expanded(
              child: Container(
                  color: context.primaryBackgroundColor,
                  child: MeetingHistorySection(
                    userId: LocalData.getData(
                        key: SharedKey.uid), // Ensure userId is not null
                  )),
            ),
          ],
        );
      },
    );
  }
}

String formatMeetingDate(String dateStr) {
  final dateUtc = DateTime.parse(dateStr).toUtc();
  final dateLocal = dateUtc.add(Duration(hours: 3));
  final formatted = DateFormat('EEEE, hh:mm a').format(dateLocal);
  return formatted;
}

class MeetingHistorySection extends StatelessWidget {
  final String userId;

  const MeetingHistorySection({Key? key, required this.userId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MeetingCubit()..getMeetingHistory(userId: userId),
      child: BlocBuilder<MeetingCubit, MeetingState>(
        builder: (context, state) {
          if (state is MeetingHistoryLoadingState) {
            return Center(child: CircularProgressIndicator());
          } else if (state is MeetingHistoryLoadedState) {
            final meetings = state.meetings;
            if (meetings.isEmpty) {
              return Center(
                child: Column(
                  children: [
                    Image.asset(
                      "assets/images/people.png",
                      width: 250,
                    ),
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
            return ListView.builder(
              itemCount: meetings.length,
              itemBuilder: (context, index) {
                final meeting = meetings[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(children: [
                    Expanded(
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.08,
                        decoration: BoxDecoration(
                          color: AppColor.primaryBlue,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: FaIcon(FontAwesomeIcons.video,
                              color: Colors.white, size: 30),
                        ),
                      ),
                    ),
                    
                    const SizedBox(width: 10),
                    Flexible(
                      flex: 2,
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 10),
                        CustomText(
                          text: meeting.meetingName ??
                              'Meeting ${meeting.meetingId}',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColor.primaryBlue,
                        ),
                        SizedBox(height: 5),


                        CustomText(
                          text:
                              'Scheduled on ${formatMeetingDate(meeting.createdAt.toIso8601String())}',
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                          color: context.thirdTextColor,
                        ),
                      ],
                    )),
                  ]),
                );
              },
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
