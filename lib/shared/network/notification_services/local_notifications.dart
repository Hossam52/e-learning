import 'dart:convert';
import 'dart:developer';
import 'dart:math' as math;

import 'package:e_learning/main.dart';
import 'package:e_learning/modules/notifications/notification_post/notification_post_screen.dart';
import 'package:e_learning/shared/componants/componants.dart';
import 'package:e_learning/shared/network/notification_services/local_notification_statuses.dart';
import 'package:e_learning/shared/network/notification_services/recieved_notification_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void navigateAccordingToPayloadNotification(
  String? payload,
  // GlobalKey<NavigatorState> navigator
) async {
  final navigator = navigatorKey;
  if (payload == null) return;
  RecievedNotificationModel model = RecievedNotificationModel.fromJson(payload);
  log(model.toString());

  switch (model.type) {
    case 1:
      //Friend requests
      break;
    case 2:
      //Champions
      break;
    case 3:
      //Comment
      navigateTo(
          navigator.currentContext, NotificationPostScreen(post: model.post!));
      break;
    case 4:
      //Videos
      break;
    case 5:
      break;
    default:
  }

  // log('payload Before is $payload');
  // final jsonDecode = json.decode(payload) as Map<String, dynamic>;
  // log('payload After is $jsonDecode');

  // log('From local notification');
  // if (jsonDecode.containsKey('type')) {
  //   log(jsonDecode['type']);
  //   // AppCubit.instance(navigator.currentContext!)
  //   //     .currentShowingOrderNotificationScreen();
  //   // await navigator.currentState!.push(
  //   //   MaterialPageRoute(builder: (context) => Container()),
  //   // );
  //   // AppCubit.instance(navigator.currentContext!).closeOrderNotificationScreen();
  // }
}

class LocalNotifications {
  static final _notification = FlutterLocalNotificationsPlugin();
  static Future<void> initialize(GlobalKey<NavigatorState> navigator) async {
    AndroidInitializationSettings initializationSettingsAndroid =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    IOSInitializationSettings initializationSettingsIOS =
        const IOSInitializationSettings();
    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    await _notification.initialize(initializationSettings,
        onSelectNotification: ((data) {
      navigateAccordingToPayloadNotification(data);
    }));
  }

  static Future showLocalNotification(
      {int id = 0,
      String? title,
      String? body,
      String? payload,
      required LocalNotificationProperties properties}) async {
    log(properties.notificationSoundPath);
    _notification.show(math.Random.secure().nextInt(10), title, body,
        await properties.notificationDetails(),
        payload: payload);
  }
}
