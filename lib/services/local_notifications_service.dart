import 'dart:convert' show jsonDecode, jsonEncode;
import 'dart:developer';
import 'package:delivera/enum/notification_type_enum.dart';
import 'package:delivera/model/notification_handler_model.dart' show NotificationHandler;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationsService {
  // Private constructor for singleton pattern
  LocalNotificationsService._internal();

  //Singleton instance
  static final LocalNotificationsService _instance = LocalNotificationsService._internal();

  //Factory constructor to return singleton instance
  factory LocalNotificationsService.instance() => _instance;

  //Main plugin instance for handling notifications
  late FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;

  //Android notification channel configuration
  final _androidChannel = const AndroidNotificationChannel(
    'delivera_channel',
    'Delivera Notifications',
    description: 'Android push notification channel for Delivera app',
    importance: Importance.max,
    playSound: true,
    enableVibration: true,
  );

  final _androidChannelFCM = const AndroidNotificationChannel(
    'delivera_channel_fcm',
    'Delivera FCM Notifications',
    description: 'Android push notification channel for Delivera app FCM',
    importance: Importance.none,
    playSound: false,
    enableVibration: false,
  );

  //Flag to track initialization status
  bool _isFlutterLocalNotificationInitialized = false;

  //Counter for generating unique notification IDs
  int _notificationIdCounter = 100;

  /// Initializes the local notifications plugin for Android and iOS.
  Future<void> init() async {
    // Check if already initialized to prevent redundant setup
    if (_isFlutterLocalNotificationInitialized) {
      return;
    }

    // Create plugin instance
    _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    //Android-specific initialization settings using app launcher icon
    final androidInitializationSettings = const AndroidInitializationSettings('@mipmap/ic_launcher');

    //iOS-specific initialization settings with permission requests
    final iosInitializationSettings = const DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    // Combine platform-specific settings
    final initializationSettings = InitializationSettings(
      android: androidInitializationSettings,
      iOS: iosInitializationSettings,
    );

    // Initialize plugin with settings and callback for notification taps
    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _notificationTapped,
    );

    // Refresh Android notification channels, use when making changes to channels
    // await _refreshAndroidChannels();

    // Create Android notification channel
    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_androidChannelFCM);

    // Create Android notification channel
    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_androidChannel);

    // Mark initialization as complete
    _isFlutterLocalNotificationInitialized = true;
  }

  /// Refreshes Android notification channels by deleting existing ones.
  // ignore: unused_element
  Future<void> _refreshAndroidChannels() async {
    var notificationChannels = await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.getNotificationChannels();

    // Delete all existing channels to avoid duplicates
    if (notificationChannels != null) {
      for (var channel in notificationChannels) {
        log('Deleting existing channel: ${channel.id}');
        await _flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
            ?.deleteNotificationChannel(channel.id);
      }
    }
  }

  static void _notificationTapped(NotificationResponse response) {
    // Handle notification tap
    log('Notification has been tapped.');
    if (response.payload == null) {
      log('Notification has no payload.');
      return;
    }
    final dynamic payload = jsonDecode(response.payload!);
    final notificationType = NotificationTypeEnum.fromName(payload['type']);
    final notificationHandler = NotificationHandler.fromType(notificationType);
    notificationHandler.handleTapped(payload);
  }

  /// Show a local notification with the given title, body, and payload.
  Future<void> showNotification(String? title, String? body, dynamic payload) async {
    // Android-specific notification details
    final androidDetails = AndroidNotificationDetails(
      _androidChannel.id,
      _androidChannel.name,
      channelDescription: _androidChannel.description,
      importance: _androidChannel.importance,
      playSound: _androidChannel.playSound,
      priority: Priority.high,
    );

    // iOS-specific notification details
    const iosDetails = DarwinNotificationDetails();

    // Combine platform-specific details
    final notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    log('Notification title: $title');
    log('Notification body: $body');
    // log('Notification payload: $payload');

    // log('Notification type: ${payload['type']}');
    // log('Notification order_data: ${payload['order_data']}');

    final notificationType = NotificationTypeEnum.fromName(payload['type']);
    final notificationHandler = NotificationHandler.fromType(notificationType);
    notificationHandler.handleReceived(payload);

    try {
      final int notificationId = notificationHandler.notificationId ?? _notificationIdCounter;

      // Display the notification
      await _flutterLocalNotificationsPlugin.show(
        notificationId,
        title,
        body,
        notificationDetails,
        payload: jsonEncode(payload),
      );

      _notificationIdCounter++;
    } catch (e) {
      log('Error showing notification: $e');
    }
  }
}
