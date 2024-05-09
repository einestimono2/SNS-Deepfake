import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'handle_message.dart';

class LocalNotificationService {
  static final instance = LocalNotificationService._internal();
  LocalNotificationService._internal();
  factory LocalNotificationService() => instance;

  final localNotificationsPlugin = FlutterLocalNotificationsPlugin();
  final channel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description:
        'This channel is used for important notifications.', // description
    importance: Importance.high,
  );

  Future<void> init() async {
    final initializationSetting = InitializationSettings(
      android: const AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(
        onDidReceiveLocalNotification: (id, title, body, payload) =>
            showNotification(
          id: id,
          title: title,
          body: body,
          payload: payload,
        ),
      ),
    );

    localNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    await localNotificationsPlugin.initialize(
      initializationSetting,
      onDidReceiveBackgroundNotificationResponse:
          NotificationHandler.handleMessage,
      onDidReceiveNotificationResponse: NotificationHandler.handleMessage,
    );

    /**
     * Create an Android Notification Channel.
     * We use this channel in the `AndroidManifest.xml` file to override the default FCM channel to enable heads up notifications.
     */
    await localNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  get notificationDetails {
    final androidNotificationDetails = AndroidNotificationDetails(
      channel.id, channel.name,
      channelDescription: channel.description,
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
      ticker: 'ticker',
      //  sound: RawResourceAndroidNotificationSound('jetsons_doorbell'),
      //  icon: largeIconPath,
      sound: channel.sound,
    );

    // IOS
    const darwinNotificationDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    return NotificationDetails(
      android: androidNotificationDetails,
      iOS: darwinNotificationDetails,
    );
  }

  /* The backgroundHandler needs to be either a static function or a top level function to be accessible as a Flutter entry point. */

  Future<void> showNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,
  }) async {
    return Future.delayed(
      Duration.zero,
      () => localNotificationsPlugin.show(
        id,
        title,
        body,
        notificationDetails,
        payload: payload,
      ),
    );
  }
}
