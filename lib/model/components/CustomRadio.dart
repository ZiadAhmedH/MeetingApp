import 'package:flutter/material.dart';
import 'package:meeting_app/utils/AppColor.dart';

class CustomRadioButton extends StatelessWidget {
  final int value;
  final int groupValue;
  final ValueChanged<int?> onChanged;
  final String labelText;

  CustomRadioButton({
    required this.groupValue,
    required this.onChanged,
    required this.labelText,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Radio<int>(
          value: value,
          groupValue: groupValue,
          onChanged: onChanged,
          activeColor: AppColor.primaryBlue,
        ),
        Expanded(
          child: Text(
            labelText,
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }
}
