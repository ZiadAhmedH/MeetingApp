import 'package:flutter/material.dart';
import 'package:meeting_app/utils/AppColor.dart';

class CustomRadioButton extends StatelessWidget {
  final int value;
  final int groupValue;
  final ValueChanged<int?> onChanged;
  final String labelText;
  final void onTap;

  CustomRadioButton({
    required this.groupValue,
    required this.onChanged,
    required this.labelText,
    required this.value, this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          onTap: () => onTap,
          child: Radio<int>(
            value: value,
            groupValue: groupValue,
            onChanged: onChanged,
            activeColor: AppColor.primaryBlue,
          ),
        ),
        Expanded(
          child: Text(
            labelText,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.0,
            ),
          ),
        ),
      ],
    );
  }
}
