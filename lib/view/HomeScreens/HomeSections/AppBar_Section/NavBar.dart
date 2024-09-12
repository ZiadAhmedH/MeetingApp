import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:meeting_app/model/widget/meetingFuteareBtm.dart';

class MeetingSection extends StatelessWidget {
  const MeetingSection({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double sectionHeight = constraints.maxHeight > 200.0 ? 100.0 : constraints.maxHeight;

        return SizedBox(
          height: sectionHeight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              MeetingFBtn(
                text: "Join",
                onTap: () {},
                icon: FontAwesomeIcons.video,

              ),
              MeetingFBtn(
                text: "Share Screen",
                onTap: () {},
                icon: FontAwesomeIcons.squareArrowUpRight,
              ),
            ],
          ),
        );
      },
    );
  }
}
