import 'dart:developer';
import 'package:delivera/firebase_options.dart' show DefaultFirebaseOptions;
import 'package:delivera/services/local_notifications_service.dart';
import 'package:firebase_core/firebase_core.dart' show Firebase;
import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseMessagingService {
  // Private constructor for singleton pattern
  FirebaseMessagingService._internal();

  // Singleton instance
  static final FirebaseMessagingService _instance = FirebaseMessagingService._internal();

  // Factory constructor to provide singleton instance
  factory FirebaseMessagingService.instance() => _instance;

  // Reference to local notifications service for displaying notifications
  LocalNotificationsService? _localNotificationsService;

  LocalNotificationsService? get localNotificationsService => _localNotificationsService;

  /// Initialize Firebase Messaging and sets up all message listeners
  Future<void> init({required LocalNotificationsService localNotificationsService}) async {
    // Init local notifications service
    _localNotificationsService = localNotificationsService;

    // Handle FCM token
    _handlePushNotificationsToken();

    // Request user permission for notifications
    _requestPermission();

    // Register handler for background messages (app terminated)
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Listen for messages when the app is in foreground
    FirebaseMessaging.onMessage.listen(_onForegroundMessage);

    // Listen for notification taps when the app is in background but not terminated
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenedApp);

    // Check for initial message that opened the app from terminated state
    final RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      _onMessageOpenedApp(initialMessage);
    }
  }

  /// Retrieves and manages the FCM token for push notifications
  Future<void> _handlePushNotificationsToken() async {
    // Get the FCM token for the device
    final token = await FirebaseMessaging.instance.getToken();
    log('Push notifications token: $token');

    // Listen for token refresh events
    FirebaseMessaging.instance.onTokenRefresh.listen((fcmToken) {
      log('FCM token refreshed: $fcmToken');
      // TODO: optionally send token to your server for targeting this device
    }).onError((error) {
      // Handle errors during token refresh
      log('Error refreshing FCM token: $error');
    });
  }

  /// Requests notification permission from the user
  Future<void> _requestPermission() async {
    // Request permission for alerts, badges, and sounds
    final result = await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // Log the user's permission decision
    log('User granted permission: ${result.authorizationStatus}');
  }

  /// Handles messages received while the app is in the foreground
  void _onForegroundMessage(RemoteMessage message) {
    final notificationData = message.notification;
    log('Foreground message received: ${message.toMap()}');
    if (notificationData != null) {
      // Display a local notification using the service
      _localNotificationsService?.showNotification(
          notificationData.title, notificationData.body, message.data);
    }
  }

  /// Handles notification taps when app is opened from the background or terminated state
  void _onMessageOpenedApp(RemoteMessage message) {
    log('Notification caused the app to open: ${message.toMap()}');
    // TODO: Add navigation or specific handling based on message data
  }
}

/// Background message handler (must be top-level function or static)
/// Handles messages when the app is fully terminated
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final notificationData = message.notification;
  log('Background message received: ${message.toMap()}');
  if (notificationData != null) {
    // Display a local notification
    final localNotificationsService = LocalNotificationsService.instance();
    await localNotificationsService.init();
    await localNotificationsService.showNotification(
        notificationData.title, notificationData.body, message.data);
  }
}