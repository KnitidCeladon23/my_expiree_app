import 'package:expiree_app/screens/inventoryListFirebase.dart';
import 'package:expiree_app/screens/rootPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:expiree_app/notification/notification_data.dart';
import 'package:flutter/material.dart';

class NotificationPlugin {
  FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;

  NotificationPlugin() {
    _initializeNotifications();
  }

  //get context => null;

  void _initializeNotifications() {
    _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    final initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    final initializationSettingsIOS = IOSInitializationSettings(); /*IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);*/ //TODO: replace
    final initializationSettings = InitializationSettings(
      initializationSettingsAndroid,
      initializationSettingsIOS,
    );
    _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: onSelectNotification,
    );
  }

  Future onSelectNotification(String payload) async {
    if (payload != null) {
      debugPrint('print payload : $payload');
    }
    /*await Navigator.push(
      context,
      new MaterialPageRoute(builder: (context) => new RootPage()),
    );*/
  }

  /*Future onDidReceiveLocalNotification(
      int id, String title, String body, String payload) async {
    // display a dialog with the notification details, tap ok to go to another page
    await showDialog(
      context: context,
      builder: (BuildContext context) => new CupertinoAlertDialog(
        title: new Text(title),
        content: new Text(body),
        actions: <Widget>[
          CupertinoDialogAction(
            isDefaultAction: true,
            child: new Text('Ok'),
            onPressed: () async {
              Navigator.of(context, rootNavigator: true).pop();
              await Navigator.push(
                    context,
                    new MaterialPageRoute(
                      builder: (context) => new InventoryListFirebase(),
                    ),
                  );
            },
          )
        ],
      ),
    );
  }*/

  /*Future<void> show(
    int id,
    String title,
    String body,
  ) async {
    AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        importance: Importance.Max, priority: Priority.High, ticker: 'ticker');
    IOSNotificationDetails iOSPlatformChannelSpecifics = IOSNotificationDetails();
    NotificationDetails platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await _flutterLocalNotificationsPlugin.show(
        id, 
        title, 
        body, 
        platformChannelSpecifics,);
  }*/

  Future<void> schedule(
    int id, String title, String description, String dateTimeStr) async {
    DateTime dateTime = DateTime.parse(dateTimeStr);
    DateTime scheduledNotificationDateTime =
        dateTime.add(new Duration(hours:3,minutes:15));
    print(scheduledNotificationDateTime.toString() + " time of notification");
    final androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'show weekly channel id',
      'show weekly channel name',
      'show weekly description',
      importance: Importance.Max,
      priority: Priority.High,
      ticker: 'test',
    );
    final iOSPlatformChannelSpecifics = IOSNotificationDetails();
    final platformChannelSpecifics = NotificationDetails(
      androidPlatformChannelSpecifics,
      iOSPlatformChannelSpecifics,
    );
    await _flutterLocalNotificationsPlugin.schedule(
      id,
      title,
      description,
      scheduledNotificationDateTime,
      platformChannelSpecifics,
    );
  }

  Future<List<PendingNotificationRequest>> getScheduledNotifications() async {
    final pendingNotifications =
        await _flutterLocalNotificationsPlugin.pendingNotificationRequests();
    return pendingNotifications;
  }

  Future<void> cancelNotification(int id) async {
    await _flutterLocalNotificationsPlugin.cancel(id);
  }

  Future<void> cancelAllNotifications() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
  }

  Future<void> scheduleAllNotifications(
      List<NotificationData> notifications) async {
      print('scheduleallnotifications ran'); ///TODO: remove this
    for (final notification in notifications) {
      await schedule(
        notification.notificationId,
        notification.title,
        notification.description,
        notification.dateTimeStr,
      );
    }
  }
}
