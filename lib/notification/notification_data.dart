class NotificationData {
  static const String idField = 'id';
  static const String notificationIdField = 'notificationId';
  static const String titleField = 'title';
  static const String descriptionField = 'description';
  static const String dateTimeStrField = 'dateTimeStr';

  String id;
  int notificationId;
  String title;
  String description;
  String dateTimeStr;

  NotificationData(this.title, this.description, this.dateTimeStr);

  NotificationData.fromDb(Map<String, dynamic> json, String id) {
    this.id = id;
    this.notificationId = json[notificationIdField];
    this.title = json[titleField];
    this.description = json[descriptionField];
    this.dateTimeStr = json[dateTimeStrField];
  }

  Map<String, dynamic> toJson() {
    return {
      notificationIdField: this.notificationId,
      titleField: this.title,
      descriptionField: this.description,
      dateTimeStrField: this.dateTimeStr,
    };
  }

  @override
  String toString() {
    //return 'title: $title, notificationId: $notificationId, hour: $hour, minute: $minute';
    return 'title: $title, notificationId: $notificationId, dateTimeStr: $dateTimeStr';
  }
}
