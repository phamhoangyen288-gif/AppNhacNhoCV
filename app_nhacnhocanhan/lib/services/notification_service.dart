import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;


class NotificationService {
  static Future cancelAll() async {
    await _noti.cancelAll();
  }

  static final FlutterLocalNotificationsPlugin _noti =
  FlutterLocalNotificationsPlugin();

  static Future init() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: android);

    await _noti.initialize(settings);
  }

  static Future show(int id, String title) async {
    const android = AndroidNotificationDetails(
      'channel_id',
      'Reminders',
      importance: Importance.max,
      priority: Priority.high,
    );

    await _noti.show(
      id,
      title,
      "Reminder",
      const NotificationDetails(android: android),
    );
  }


  static Future schedule({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    //required TimeOfDay? quietStart,
    //required TimeOfDay? quietEnd,
  }) async {
    //if (quietStart != null && quietEnd != null) {
      //if (isInQuietHours(quietStart, quietEnd, scheduledDate)) {
       // return; //  KHÔNG SET NOTIFICATION
      //}
    //}

    await NotificationService._noti.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledDate, tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'task_channel',
          'Task Notifications',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,

    );
  }

  static bool isInQuietHours(
      TimeOfDay start,
      TimeOfDay end,
      DateTime time,
      ) {
    final now = TimeOfDay(hour: time.hour, minute: time.minute);

    final nowMin = now.hour * 60 + now.minute;
    final startMin = start.hour * 60 + start.minute;
    final endMin = end.hour * 60 + end.minute;

    if (startMin > endMin) {
      return nowMin >= startMin || nowMin <= endMin;
    }

    return nowMin >= startMin && nowMin <= endMin;
  }

  static Future cancel(int id) async {
    await _noti.cancel(id);
  }

  static Future scheduleReminder({
    required int id,
    required String title,
    required DateTime scheduledTime,
  }) async {
    await _noti.zonedSchedule(
      id,
      title,
      "Reminder",
      tz.TZDateTime.from(scheduledTime, tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'reminder_channel',
          'Reminders',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,

    );
  }

  Duration getReminderDuration(String option) {
    switch (option) {
      case "5 minutes":
        return Duration(minutes: 5);
      case "15 minutes":
        return Duration(minutes: 15);
      case "1 hour":
        return Duration(hours: 1);
      case "1 day":
        return Duration(days: 1);
      default:
        return Duration(minutes: 15);
    }
  }

  Future scheduleReminderNEW({
    required int id,
    required String title,
    required DateTime endDate,
    required String remindBefore,
  }) async {
    final duration = getReminderDuration(remindBefore);

    final remindTime = endDate.subtract(duration);

    await NotificationService._noti.zonedSchedule(
      id + 1000,
      "Upcoming Task",
      title,
      tz.TZDateTime.from(remindTime, tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'reminder_channel',
          'Reminders',
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      //uiLocalNotificationDateInterpretation:
      //UILocalNotificationDateInterpretation.absoluteTime,
    );
  }
}