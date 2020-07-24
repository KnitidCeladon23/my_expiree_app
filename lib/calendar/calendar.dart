import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expiree_app/screens/imagePickerPage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'res/event_firestore_service.dart';
import 'ui/pages/view_event.dart';
import 'package:expiree_app/calendar/res/event_firestore_service.dart';
import 'package:expiree_app/calendar/ui/pages/view_event.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:provider/provider.dart';
import 'model/event.dart';
import 'package:expiree_app/states/currentUser.dart';
import 'package:google_fonts/google_fonts.dart';

class Calendar extends StatefulWidget {
  final EventModel note;
  const Calendar({Key key, this.note}) : super(key: key);
  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  CalendarController _controller;
  Map<DateTime, List<dynamic>> _events;
  List<dynamic> _selectedEvents;
  TextStyle style = GoogleFonts.permanentMarker(
    fontSize: 30,
  );
  DateTime _entryDateTime;
  DateTime _expiryDateTime;
  String newItem;
  final databaseReference = Firestore.instance;
  String deleteExpiryDateTime;
  String deleteItem;
  TextEditingController _description;

  String descriptionInfo;

  File _imageFile;

  @override
  void initState() {
    super.initState();
    _controller = CalendarController();
    _events = {};
    _selectedEvents = [];
    _description = TextEditingController(
        text: widget.note != null ? widget.note.description : "");
  }

  Map<DateTime, List<dynamic>> _groupEvents(List<EventModel> allEvents) {
    Map<DateTime, List<dynamic>> data = {};
    allEvents.forEach((event) {
      DateTime date = DateTime(event.expiryDateTime.year,
          event.expiryDateTime.month, event.expiryDateTime.day, 12);
      if (data[date] == null) data[date] = [];
      data[date].add(event);
    });
    return data;
  }

  Future<Null> _selectExpiryDate(BuildContext context) async {
    final DateTime pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2101));
    if (pickedDate != null && pickedDate != _expiryDateTime)
      setState(() {
        _entryDateTime = DateTime.now();
        _expiryDateTime = pickedDate;
      });
  }

  Future<void> _pickImage(ImageSource source) async {
    File selected = await ImagePicker.pickImage(source: source);

    setState(() {
      _imageFile = selected;
    });
  }

  void addToList(String item, String expiryDateTime, String description) async {
    CurrentUser _currentUser = Provider.of<CurrentUser>(context, listen: false);
    String _uid = _currentUser.getUid;
    await databaseReference
        .collection("inventoryLists")
        .document(_uid)
        .collection("indivInventory")
        .add({
      'item': item,
      'expiryDateTime': expiryDateTime,
      'description': description,
      'id': null,
    });
  }

  @override
  Widget build(BuildContext context) {
    CurrentUser _currentUser = Provider.of<CurrentUser>(context, listen: false);
    String _uid = _currentUser.getUid;

    final addItemButton = FloatingActionButton(
      backgroundColor: Colors.green,
      onPressed: () {
        newItem = null;
        descriptionInfo = null;
        _expiryDateTime = null;
        _imageFile = null;
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return StatefulBuilder(builder: (context, setState) {
                return AlertDialog(
                  title: Text("Add Item"),
                  content: SingleChildScrollView(
                    child: ListBody(
                      children: <Widget>[
                        TextField(
                          style: style,
                          onChanged: (String input) {
                            newItem = input;
                          },
                          decoration: InputDecoration(
                              labelText: "Item Name",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10))),
                        ),
                        // TextFormField(
                        //   controller: _description,
                        //   minLines: 3,
                        //   maxLines: 5,
                        //   validator: (value) =>
                        //       (value.isEmpty) ? "Please enter description" : null,
                        //   style: style,
                        //   decoration: InputDecoration(
                        //       labelText: "Description",
                        //       border: OutlineInputBorder(
                        //           borderRadius: BorderRadius.circular(10))),
                        // ),
                        SizedBox(height: 15),
                        TextField(
                          // initialValue: "",
                          // controller: _description,
                          minLines: 3,
                          maxLines: 5,
                          // validator: (value) =>
                          //     (value.isEmpty) ? "Please enter description" : null,
                          // style: style,
                          onChanged: (String input) {
                            descriptionInfo = input;
                          },
                          decoration: InputDecoration(
                              labelText: "Description",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10))),
                        ),
                      ],
                    ),
                  ),
                  actions: <Widget>[
                    FlatButton(
                      onPressed: () {
                        _selectExpiryDate(context);
                      },
                      child: Text("Enter expiry date"),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        FlatButton(
                          onPressed: () => _pickImage(ImageSource.camera),
                          child: Icon(IconData(58288,
                              fontFamily: 'MaterialIcons')), //camera icon
                        ),
                        FlatButton(
                          onPressed: () => _pickImage(ImageSource.gallery),
                          child: Icon(Icons.photo_library), //gallery icon
                        )
                      ],
                    ),
                    RaisedButton(
                        onPressed: () async {
                          // if (newItem != null && _expiryDateTime != null) {
                          //   addToList(newItem, _expiryDateTime.toString(),
                          //       _description.text);
                          // }
                          // print(newItem);
                          // print(_expiryDateTime);
                          DateTime foodID = DateTime.now();
                          if (newItem != null && _expiryDateTime != null) {
                            if (widget.note != null) {
                              await eventDBS.updateData(widget.note.id, _uid, {
                                "item": newItem,
                                "description": descriptionInfo,
                                "expiryDateTime": _expiryDateTime,
                                "id": foodID.toString()
                              });
                            } else {
                              await eventDBS.createItem(
                                  _uid,
                                  EventModel(
                                      item: newItem,
                                      description: descriptionInfo,
                                      expiryDateTime: _expiryDateTime,
                                      id: foodID.toString()));
                            }
                          }
                          print(_imageFile != null);
                          if (_imageFile != null) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ImagePickerPage(
                                        pageRef: 1,
                                        userID: _uid,
                                        itemID: foodID.toString(),
                                        image: _imageFile)));
                          } else {
                            Navigator.pop(context);
                          }
                        },
                        child: Text("Confirm new item")),
                  ],
                );
              });
            });
      },
      child: Icon(Icons.add, color: Colors.white),
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Track your food!',
          style: GoogleFonts.permanentMarker(
            fontSize: 30,
          ),
        ),
      ),
      body: StreamBuilder<List<EventModel>>(
          stream: eventDBS.streamList(_uid),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<EventModel> allEvents = snapshot.data;
              if (allEvents.isNotEmpty) {
                _events = _groupEvents(allEvents);
              } else {
                _events = {};
                _selectedEvents = [];
              }
            }
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TableCalendar(
                    events: _events,
                    initialCalendarFormat: CalendarFormat.month,
                    calendarStyle: CalendarStyle(
                        canEventMarkersOverflow: true,
                        todayColor: Colors.orange,
                        selectedColor: Theme.of(context).primaryColor,
                        todayStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                            color: Colors.white)),
                    headerStyle: HeaderStyle(
                      centerHeaderTitle: true,
                      formatButtonDecoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      formatButtonTextStyle: TextStyle(color: Colors.white),
                      formatButtonShowsNext: false,
                    ),
                    startingDayOfWeek: StartingDayOfWeek.monday,
                    onDaySelected: (date, events) {
                      setState(() {
                        _selectedEvents = events;
                      });
                    },
                    builders: CalendarBuilders(
                      selectedDayBuilder: (context, date, events) => Container(
                          margin: const EdgeInsets.all(4.0),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.circular(10.0)),
                          child: Text(
                            date.day.toString(),
                            style: TextStyle(color: Colors.white),
                          )),
                      todayDayBuilder: (context, date, events) => Container(
                          margin: const EdgeInsets.all(4.0),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: Colors.orange,
                              borderRadius: BorderRadius.circular(10.0)),
                          child: Text(
                            date.day.toString(),
                            style: TextStyle(color: Colors.white),
                          )),
                    ),
                    calendarController: _controller,
                  ),
                  ..._selectedEvents.map((event) => ListTile(
                        title: Text(
                          event.item,
                          style: GoogleFonts.oswald(
                            fontSize: 35,
                            color: Colors.green[900],
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => EventDetailsPage(
                                        event: event,
                                      )));
                        },
                      )),
                ],
              ),
            );
          }),
      floatingActionButton: addItemButton,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
