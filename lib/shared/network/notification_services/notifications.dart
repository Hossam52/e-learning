import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:e_learning/main.dart';
import 'package:e_learning/models/teacher/groups/in_group/post_response_model.dart';
import 'package:e_learning/shared/network/notification_services/local_notification_statuses.dart';
import 'package:e_learning/shared/network/notification_services/local_notifications.dart';
import 'package:e_learning/shared/network/notification_services/recieved_notification_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class FCM {
  // static GlobalKey<NavigatorState> navigatorKey;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> setNotifications() async {
    await LocalNotifications.initialize(navigatorKey);

    FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
        alert: true, badge: true, sound: true);

    log('Start notification');
    // await _notificationOnAppBackgroundOrTerminated(navigatorKey);
    await _notificationOnAppTerminated(navigatorKey);
    await _notificationOnAppBackground(navigatorKey);
    await _notificationOnAppOpened(navigatorKey);
  }

  static void _checkRedirection(RemoteMessage message,
      [bool showLocalNotification = true]) {
    final data = message.data;
    // RecievedNotificationModel model = RecievedNotificationModel.fromMap((data));
    // log(model.toString());
    if (!showLocalNotification) {
      navigateAccordingToPayloadNotification(json.encode(data));
    } else {
      LocalNotifications.showLocalNotification(
        properties: CustomNotificationChannel(),
        title: data['title'], // message.notification!.title,
        body: data['body'], //message.notification!.body,
        payload: json.encode(data),
      );
    }
  }

  Future<void> _notificationOnAppTerminated(
      GlobalKey<NavigatorState> navigatorKey) async {
    final message = await FirebaseMessaging.instance.getInitialMessage();
    if (message == null) return;
    _checkRedirection(message);
  }

  Future<void> _notificationOnAppOpened(
      GlobalKey<NavigatorState> navigatorKey) async {
    FirebaseMessaging.onMessage.listen((message) {
      log('In onMessage found ${message.data}');
      _checkRedirection(message);
    });
  }

  static Future<void> notificationOnAppBackgroundOrTerminated(
      RemoteMessage message) async {
    log('In BackgroundOrTerminated found ${message.data}');
    // _checkRedirection(message, false);
    // navig
    return;
    FirebaseMessaging.onBackgroundMessage((message) async {});
  }

  Future<void> _notificationOnAppBackground(
      GlobalKey<NavigatorState> navigatorKey) async {
    FirebaseMessaging.onMessageOpenedApp.listen((message) async {
      log('In openedApp found ${message.data}');
      _checkRedirection(message, false);
    });
  }
}
