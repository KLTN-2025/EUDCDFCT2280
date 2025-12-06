import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class FirebaseMsg {
  final msgService = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // 🟢 1. ĐỊNH NGHĨA KÊNH THÔNG BÁO (BẮT BUỘC CHO ANDROID 8.0+)
  // Nếu không tạo kênh này, Android sẽ không cho phép hiện thông báo dạng Popup (Heads-up)
  final AndroidNotificationChannel channel = const AndroidNotificationChannel(
    'default_channel_id', // id (Phải trùng với trong AndroidManifest và code show)
    'Default Channel', // title
    description: 'For showing default notifications', // description
    importance: Importance.max, // Max để có âm thanh và popup
    playSound: true,
  );

  // 1. Hàm này chỉ dùng để XIN QUYỀN (Gọi ở màn hình Onboarding)
  Future<void> requestPermission() async {
    NotificationSettings settings = await msgService.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );
    // ignore: avoid_print
    print('User granted permission: ${settings.authorizationStatus}');
  }

  // 2. Hàm này dùng để KHỞI TẠO LẮNG NGHE (Gọi ở Splash Screen hoặc main)
  Future<void> initFCM() async {
    // Get token
    var token = await msgService.getToken();
    // ignore: avoid_print
    print("FCM Token: $token");

    // 🟢 2. TẠO KÊNH THÔNG BÁO TRÊN HỆ THỐNG
    // Dòng này cực quan trọng, nó đăng ký kênh với Android
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    // 🟢 3. CẤU HÌNH HIỂN THỊ KHI APP ĐANG MỞ (FOREGROUND)
    // Để iOS cũng hiện thông báo khi đang mở app
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    // Background Handler
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Foreground Handler
    FirebaseMessaging.onMessage.listen((RemoteMessage msg) {
      showNotification(msg);
    });

    // Init Local Notification
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@drawable/ic_notification');

    // Thêm cấu hình iOS (để tránh lỗi nếu build iOS sau này)
    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings();

    const InitializationSettings initSettings =
        InitializationSettings(android: androidSettings, iOS: iosSettings);

    await flutterLocalNotificationsPlugin.initialize(initSettings);
  }

  Future<void> showNotification(RemoteMessage message) async {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;

    if (notification != null && android != null) {
      // Sử dụng channel đã định nghĩa ở trên
      AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
        channel.id,
        channel.name,
        channelDescription: channel.description,
        importance: Importance.max,
        priority: Priority.high,
        icon: '@drawable/ic_notification',
        playSound: true,
      );

      NotificationDetails notificationDetails =
          NotificationDetails(android: androidDetails);

      await flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        notificationDetails,
      );
    }
  }
}

// 🟢 4. THÊM PRAGMA ĐỂ TRÁNH LỖI KHI BUILD RELEASE
// Nếu thiếu dòng này, khi build file APK release, hàm này có thể bị xóa nhầm gây lỗi không nhận tin khi tắt app
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // ignore: avoid_print
  print('🔙 Handling background message: ${message.messageId}');
}
