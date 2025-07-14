import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:meeting_app/core/utils/AppColor.dart';
import 'package:meeting_app/core/utils/ThemeExtension.dart';
import '../../MeetingScreen/MeetingSections/Meeting_Settings_Screen.dart';

class FloatingActionSection extends StatelessWidget {
  const FloatingActionSection({super.key});

  @override
  Widget build(BuildContext context) {
    return ExpandableFab(
      type: ExpandableFabType.up,
      distance: 90,
      duration: const Duration(milliseconds: 200),
      childrenAnimation: ExpandableFabAnimation.rotate,
      overlayStyle: ExpandableFabOverlayStyle(
        color: Colors.transparent,
        blur: 5,
      ),
      openButtonBuilder: DefaultFloatingActionButtonBuilder(
        child: _buildGlassyIcon(Icons.add),
        fabSize: ExpandableFabSize.regular,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      closeButtonBuilder: DefaultFloatingActionButtonBuilder(
        child: _buildGlassyIcon(Icons.close),
        fabSize: ExpandableFabSize.small,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      children: [
        _buildGlassAction(
          context,
          icon: Icons.meeting_room,
          label: "Add Meeting",
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const MeetingSettings()),
            );
          },
        ),
        _buildGlassAction(
          context,
          icon: FontAwesomeIcons.comment,
          label: "Add Chat",
          onPressed: () {
            // TODO: Add chat creation logic
          },
        ),
      ],
    );
  }

  static Widget _buildGlassyIcon(IconData icon) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(100),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white.withOpacity(0.3)),
          ),
          child: Icon(icon, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildGlassAction(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback? onPressed,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 4),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.3)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: context.thirdTextColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 12),
              FloatingActionButton.small(
                heroTag: null,
                onPressed: onPressed,
                backgroundColor: Colors.white.withOpacity(0.3),
                elevation: 0,
                shape: const CircleBorder(),
                child: Icon(icon, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
