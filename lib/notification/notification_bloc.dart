import 'package:expiree_app/notification/notification_data.dart';
import 'package:expiree_app/notification/notification_plugin.dart';
import 'package:expiree_app/notification/firestore_notification_service.dart';
import 'package:expiree_app/notification/bloc_base.dart';
import 'package:rxdart/rxdart.dart';

class NotificationBloc implements BlocBase {
  List<NotificationData> _notifications = List();
  NotificationPlugin _notificationPlugin = NotificationPlugin();

  final _notificationsController = BehaviorSubject<List<NotificationData>>();
  Function(List<NotificationData>) get _inNotifications => _notificationsController.sink.add;
  Stream<List<NotificationData>> get outNotifications => _notificationsController.stream;

  Future<void> init() async {
    final notificationStream = await FirestoreNotificationService.getAllNotifications();
    notificationStream.listen((querySnapshot) {
      _notifications = querySnapshot.documents.map((doc) => NotificationData.fromDb(doc.data, doc.documentID)).toList();
      startNotifications(_notifications);
      _inNotifications(_notifications);
    });
  }

  Future<void> cancelNotifications() async {
    await _notificationPlugin.cancelAllNotifications();
  }

  Future<void> startNotifications(List<NotificationData> notifications) async {
    print('notifications are: ');
    print(notifications);
    await _notificationPlugin.scheduleAllNotifications(notifications);
  }

  Future<void> addNotification(NotificationData notification) async {
    int id = 0;
    for (var i = 0; i < 100; i++) {
      bool exists = _checkIfIdExists(_notifications, i);
      if (!exists) {
        id = i; 
        break;
      }
    }
    notification.notificationId = id;
    _notifications.add(notification);
    print(_notifications);
    await FirestoreNotificationService.addNotification(notification);
  }

 Future<void> removeNotification(NotificationData notification) async {
   _notifications.remove(notification);
    await FirestoreNotificationService.removeNotification(notification);
  }

  bool _checkIfIdExists(List<NotificationData> notifications, int id) {
    for (final notification in notifications) {
      if (notification.notificationId == id) {
        return true;
      }
    }
    return false;
  }

  @override
  void dispose() {
    _notificationsController.close();
  }
}
