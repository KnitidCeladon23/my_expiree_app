// import 'package:firebase_helpers/firebase_helpers.dart';
import '../../custom_firestore_service.dart';
import '../model/event.dart';

DatabaseService<EventModel> eventDBS = DatabaseService<EventModel>(
    //"inventoryLists",
    'inventoryLists',
    fromDS: (id, data) => EventModel.fromDS(id, data),
    toMap: (event) => event.toMap());
