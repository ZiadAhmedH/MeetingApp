import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:meeting_app/core/utils/ThemeExtension.dart';
import 'package:meeting_app/view/HomeScreens/HomeSections/meeting_history_section/meeting_history_section.dart';
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
    final userId = LocalData.getData(key: SharedKey.uid);

    return BlocBuilder<MeetingCubit, MeetingState>(
      builder: (context, state) {
        return Column(
          children: [
            const MeetingSection(),
            const Divider(color: AppColor.darkGrey, thickness: 1),
            // ✅ Wrap StreamBuilder in Expanded to avoid unbounded height
            StreamBuilder<List<Map<String, dynamic>>>(
              stream: MeetingCubit.get(context).getLiveOutgoingMeetings(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Expanded(
                    child: Center(
                      child: LoadingAnimationWidget.dotsTriangle(
                        color: AppColor.blue,
                        size: 50,
                      ),
                    ),
                  );
                }
            
                final meetings = snapshot.data ?? [];
            
                if (meetings.isEmpty) {
                  return SizedBox();
                }
            
                return  Expanded(
                  child: ListView.builder(
                    itemCount: meetings.length,
                    itemBuilder: (context, index) {
                      final meeting = meetings[index];
                      return ListTile(
                        title: Text(
                          meeting['meeting_name'] ?? 'Untitled Meeting',
                          style: TextStyle(
                            color: context.thirdTextColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        subtitle: Text('Host: ${meeting['host_id']}'),
                        onTap: () {
                          // TODO: handle join meeting
                        },
                      );
                    },
                  ),
                );
              },
            ),
            // ✅ Meeting History Section (still scrollable inside Expanded)
            Expanded(
              flex: 2,
              child: Container(
                color: context.primaryBackgroundColor,
                child: MeetingHistorySection(userId: userId),
              ),
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
