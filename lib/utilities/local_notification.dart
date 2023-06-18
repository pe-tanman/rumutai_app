import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import "dart:io";
import '../providers/local_data.dart';

class LocalNotification {
  static final flnp = FlutterLocalNotificationsPlugin();

  static InitializationSettings initializeLocNotification() {
    //現在時刻設定
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation("Asia/Tokyo"));
//権限設定
    const DarwinInitializationSettings initSettingsIOS =
        DarwinInitializationSettings(
            requestAlertPermission: true,
            requestBadgePermission: true,
            requestSoundPermission: false);
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('notification_icon');
    if (Platform.isAndroid) {
      flnp
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()!
          .requestPermission();
    }

// ignore: unused_local_variable
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initSettingsIOS,
    );

    return initializationSettings;
  }

  //通知予約解除
  static Future<void> cancelLocNotification(String gameId) async {
    await flnp.cancel(gameId.hashCode);
    await LocalData.saveLocalData<bool>(gameId, false);
  }

  static String _sport(String gameId) {
    if (gameId[1] == "b") {
      return "フットサル";
    } else if (gameId[1] == "m") {
      return "バレーボール";
    } else if (gameId[0] == "1") {
      return "バスケットボール";
    } else if (gameId[0] == "2") {
      return "ドッチビー";
    }
    return "";
  }

  //通知の予約
  static Future<void> registerLocNotification({
    required String place,
    required String gameId,
    required String day,
    required String hour,
    required String minute,
    required String team1,
    required String team2,
  }) async {
    //日時指定
    var date = tz.TZDateTime(tz.local, 2023, 6, 28 - 1 + int.parse(day),
        int.parse(hour), int.parse(minute) - 10);
    String message = "10分前：$place";
    //通知設定
    await flnp.zonedSchedule(
        gameId.hashCode,
        "${team1}vs$team2（${_sport(gameId)}）",
        message,
        date,
        payload: gameId,
        NotificationDetails(
          android: AndroidNotificationDetails(
            'HR対抗',
            'HR対抗',
            importance: Importance.max,
            priority: Priority.high,
            ongoing: true,
            styleInformation: BigTextStyleInformation(message),
            icon: 'notification_icon',
          ), //iosは設定事項がほぼないためアンドロイドのみの設定
        ),
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidAllowWhileIdle: true);

    await LocalData.saveLocalData<bool>(gameId, true);
  }
}
