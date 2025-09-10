import 'dart:io';
import 'package:firebase_challenge/feature/fcm_beacon_challenge/view/local/notification_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/rendering.dart';
import 'package:firebase_challenge/core/logger/app_logger.dart'; // Logger import

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  AppLogger.d("Background message: ${message.notification?.title}");

  // Show local notification in background
  await LocalNotificationService().showNotification(
    message.notification?.title ?? 'No Title',
    message.notification?.body ?? 'No Body',
  );
}

class FCMService {
  static final FCMService _instance = FCMService._internal();
  factory FCMService() => _instance;
  FCMService._internal();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;

    try {
      NotificationSettings settings = await _messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );
      AppLogger.d(
        "Notification permission status: ${settings.authorizationStatus}",
      );
    } catch (e, st) {
      AppLogger.e("Failed to request notification permission", e, st);
    }

    if (Platform.isIOS) {
      await _messaging.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    }

    // Foreground messages
    FirebaseMessaging.onMessage.listen((message) async {
      AppLogger.d("Foreground message: ${message.notification?.title}");
      await LocalNotificationService().showNotification(
        message.notification?.title ?? 'No Title',
        message.notification?.body ?? 'No Body',
      );
    });

    // Opened from notification
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      AppLogger.d("Tapped message: ${message.notification?.title}");
    });

    // Background messages
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    // Force get token
    await _forceGetToken();

    // Subscribe to topic
    try {
      await _messaging.subscribeToTopic("all");
      AppLogger.d("Subscribed to topic: all");
    } catch (e, st) {
      AppLogger.e("Failed to subscribe to topic", e, st);
    }

    _messaging.onTokenRefresh.listen((newToken) {
      AppLogger.d("Token refreshed: $newToken");
    });

    _initialized = true;
  }

  Future<void> _forceGetToken() async {
    try {
      String? token = await _messaging.getToken();
      AppLogger.d("FCM Token: $token");
    } catch (e, st) {
      AppLogger.e("Failed to get FCM token", e, st);
    }
  }
}
