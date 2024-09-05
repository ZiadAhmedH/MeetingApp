import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:meeting_app/utils/AppColor.dart';
import 'package:meeting_app/utils/ThemeExtension.dart';

class FloatingActionSection extends StatelessWidget {
  const FloatingActionSection({super.key});

  @override
  Widget build(BuildContext context) {
    return ExpandableFab(
      type: ExpandableFabType.up,
      duration: const Duration(milliseconds: 200),
      childrenAnimation: ExpandableFabAnimation.rotate,
      distance: 70,
      overlayStyle: ExpandableFabOverlayStyle(
        color: Colors.transparent,
        blur: 5,
      ),
      openButtonBuilder: RotateFloatingActionButtonBuilder(
        child: const Icon(
          Icons.add,
          color: Colors.white,
          weight: 5,
        ),
        fabSize: ExpandableFabSize.regular,
        foregroundColor: AppColor.primaryBlue,
        backgroundColor: AppColor.primaryBlue,
        shape: const CircleBorder(),
      ),
      closeButtonBuilder: DefaultFloatingActionButtonBuilder(
        child: const Icon(
          Icons.close,
          color: Colors.white,
          weight: 5,
        ),
        fabSize: ExpandableFabSize.small,
        foregroundColor: AppColor.primaryBlue,
        backgroundColor: AppColor.primaryBlue,
        shape: const CircleBorder(),
      ),
      children: [
        Row(
          children: [
            Text(
              'Email',
              style: TextStyle(
                  color: context.thirdTextColor, fontWeight: FontWeight.bold),
            ),
            SizedBox(width: 20),
            FloatingActionButton.small(
              backgroundColor: AppColor.primaryBlue,
              shape: CircleBorder(),
              heroTag: null,
              onPressed: null,
              child: Icon(Icons.email , color: Colors.white,),
            ),
          ],
        ),
        Row(
          children: [
            Text(
              'Email',
              style: TextStyle(
                  color: context.thirdTextColor, fontWeight: FontWeight.bold),
            ),
            SizedBox(width: 20),
            FloatingActionButton.small(
              backgroundColor: AppColor.primaryBlue,
              shape: CircleBorder(),
              heroTag: null,
              onPressed: null,
              child: Icon(Icons.email , color: Colors.white,),
            ),
          ],
        ),
      ],
    );
  }
}
