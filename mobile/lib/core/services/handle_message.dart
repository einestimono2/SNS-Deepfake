import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../utils/logger/logger.dart';

class NotificationHandler {
  static Future<void> handleMessage(dynamic message) async {
    late RemoteMessage _msg;

    if (message is RemoteMessage) {
      _msg = message;
    } else if (message is NotificationResponse && message.payload != null) {
      _msg = RemoteMessage.fromMap(jsonDecode(message.payload!));
    } else {
      return;
    }

    RemoteNotification? notification = _msg.notification;
    if (notification == null) return;

    AppLogger.info(
      "===== Message =====\n-> Title: ${notification.title}\n-> Body: ${notification.body}\n-> Count: ${notification.android?.count}\n-> Data: ${_msg.data.toString()}",
    );
  }
}
