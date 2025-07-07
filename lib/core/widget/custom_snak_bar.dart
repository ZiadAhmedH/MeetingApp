import 'package:elegant_notification/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:elegant_notification/elegant_notification.dart';

enum NotificationType { success, error, info }

class CustomNotification {
  static void show(
    BuildContext context, {
    required String description,
    String? title,
    NotificationType type = NotificationType.info,
    Duration duration = const Duration(seconds: 3),
  }) {
    // Map your enum to ElegantNotification types
    switch (type) {
      case NotificationType.success:
        break;
      case NotificationType.error:
        break;
      case NotificationType.info:      
    }

    ElegantNotification(
      
      title: Text(title ?? _defaultTitle(type)),
      description: Text(description),
      animation: AnimationType.fromTop,
      
    ).show(context);
  }

  static String _defaultTitle(NotificationType type) {
    switch (type) {
      case NotificationType.success:
        return "Success";
      case NotificationType.error:
        return "Error";
      case NotificationType.info:
      default:
        return "Info";
    }
  }
}
