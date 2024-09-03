import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:meeting_app/model/widget/meetingFuteareBtm.dart';
import 'package:meeting_app/utils/ThemeExtension.dart';

import '../../../utils/AppColor.dart';
class MeetingSection extends StatelessWidget {
  const MeetingSection({super.key});

  @override
  Widget build(BuildContext context) {
    return     SizedBox(
      height: MediaQuery.of(context).size.height / 7,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          MeetingFBtn(text: "Join",onTap: () {

          },
            icon: FontAwesomeIcons.video,
          ),
          // MeetingFBtn(text: "Schedule",onTap: () {
          //
          // },),
          // MeetingFBtn(text: "Join",onTap: () {
          //
          // },),

        ],
      ),
    )

    ;
  }
}
