import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../models/reminder.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class ReminderProvider with ChangeNotifier {
  final List<Reminder> _reminders = [];

  List<Reminder> get reminders => _reminders;

  ReminderProvider() {
    initializeNotifications();
    tz.initializeTimeZones();
  }

  void initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void addReminder(Reminder reminder) {
    _reminders.add(reminder);
    notifyListeners();
    // Schedule notification
    scheduleNotification(reminder);
  }

  void removeReminder(String id) {
    _reminders.removeWhere((reminder) => reminder.id == id);
    notifyListeners();
    // Cancel notification
    cancelNotification(id);
  }

  void scheduleNotification(Reminder reminder) async {
    var notificationId = int.parse(reminder.id.hashCode.toString());

    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
        'your_channel_id', 'your_channel_name',
        importance: Importance.max, priority: Priority.high, showWhen: false);
    
    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

     await flutterLocalNotificationsPlugin.zonedSchedule(
      notificationId,
      'Class Reminder',
      reminder.title,
      tz.TZDateTime.from(reminder.dateTime, tz.local),
      platformChannelSpecifics,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  void cancelNotification(String id) async {
    var notificationId = int.parse(id.hashCode.toString());

    await flutterLocalNotificationsPlugin.cancel(notificationId);
  }
}
