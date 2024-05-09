import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:sns_deepfake/core/utils/utils.dart';

import 'handle_message.dart';
import 'local_notification_service.dart';

class FirebaseNotificationService {
  /* singleton */
  static final instance = FirebaseNotificationService._internal();
  FirebaseNotificationService._internal();
  factory FirebaseNotificationService() => instance;

  // initialising plugin
  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> _requestNotificationPermission() async {
    AuthorizationStatus status = (await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: false,
      sound: true,
    ))
        .authorizationStatus;

    switch (status) {
      case AuthorizationStatus.authorized:
        AppLogger.info("Người dùng đã cấp quyền");
        break;
      case AuthorizationStatus.denied:
        AppLogger.warn("Người dùng từ chối cấp quyền");
        break;
      case AuthorizationStatus.provisional:
        AppLogger.warn("Người dùng được cấp quyền tạm thời");
        break;
      case AuthorizationStatus.notDetermined:
        AppLogger.warn("Người dùng chưa chọn có cấp quyền hay không");
        break;
      default:
        break;
    }
  }

  Future<void> init() async {
    await _requestNotificationPermission();

    /* Device Token */
    _firebaseMessaging.onTokenRefresh.listen(
      (data) => AppLogger.warn('New FCM Token: ${data.toString()}'),
    );
    _firebaseMessaging
        .getToken()
        .then((token) => AppLogger.info("FCM Token: $token"));

    /* Init Firebase Message */
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    /* Listen interaction when tap */
    FirebaseMessaging.instance
        .getInitialMessage()
        .then(NotificationHandler.handleMessage);
    FirebaseMessaging.onMessageOpenedApp
        .listen(NotificationHandler.handleMessage);

    /* Listen background message */
    if (DeviceUtils.isAndroid()) {
      FirebaseMessaging.onBackgroundMessage(NotificationHandler.handleMessage);
    }

    /* Listen foreground message */
    FirebaseMessaging.onMessage.listen((message) {
      RemoteNotification? notification = message.notification;
      if (notification == null) return;

      LocalNotificationService.instance.showNotification(
        id: notification.hashCode,
        title: notification.title,
        body: notification.body,
        payload: jsonEncode(message.toMap()), // Send RemoteMessage
      );
    });
  }
}
