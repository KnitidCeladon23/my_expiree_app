import 'package:firebase_helpers/firebase_helpers.dart';

class EventModel extends DatabaseItem {
  final String id;
  final String item;
  final String description;
  final DateTime expiryDateTime;
  final String url;

  EventModel(
      {this.id, this.item, this.description, this.expiryDateTime, this.url})
      : super(id);

  factory EventModel.fromMap(Map data) {
    return EventModel(
      id: data['id'],
      item: data['item'],
      description: data['description'],
      expiryDateTime: data['expiryDateTime'],
      url: data['url'],
    );
  }

  factory EventModel.fromDS(String id, Map<String, dynamic> data) {
    return EventModel(
      id: id,
      item: data['item'],
      description: data['description'],
      expiryDateTime: data['expiryDateTime'].toDate(),
      url: data['url'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "item": item,
      "description": description,
      "expiryDateTime": expiryDateTime,
      "id": id,
      "url": url,
    };
  }
}
