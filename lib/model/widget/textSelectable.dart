import 'package:flutter/material.dart';
import 'package:meeting_app/model/components/CustomText.dart';

import '../../utils/AppColor.dart';
import '../../viewModel/bloc/MeetingCubit/meeting_cubit.dart';
class TextSelectable extends StatelessWidget {
  final String text;
  final Color borderColor;
  final int index;

  const TextSelectable({super.key, required this.text, required this.borderColor, required this.index});
  @override
  Widget build(BuildContext context) {
    var meetingCubit = MeetingCubit.get(context);
    return InkWell(
      onTap: (){
        meetingCubit.selectDuration(index);
      },
      child: Container(
         padding: const EdgeInsets.all(8),
         decoration: BoxDecoration(
           borderRadius: BorderRadius.circular(8),
          border: Border.all(color:borderColor, width: 2),),
        child: Center(child: CustomText(text: text, fontSize: 16, fontWeight: FontWeight.normal, color: AppColor.primaryBlue),),
      ),
    );
  }
}
