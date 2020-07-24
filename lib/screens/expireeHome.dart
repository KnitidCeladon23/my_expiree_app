import 'package:expiree_app/chats/chatrooms.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:expiree_app/screens/settingsPage.dart';
//import 'package:google_fonts/google_fonts.dart';
import 'package:expiree_app/calendar/model/event.dart';
import 'package:expiree_app/calendar/res/event_firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:expiree_app/states/currentUser.dart';

class ExpireeHome extends StatefulWidget {
  final EventModel note;
  const ExpireeHome({Key key, this.note}) : super(key: key);

  @override
  _ExpireeHomeState createState() => _ExpireeHomeState();
}

class _ExpireeHomeState extends State<ExpireeHome> {
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

  @override
  void initState() {
    super.initState();
    _description = TextEditingController(
        text: widget.note != null ? widget.note.description : "");
  }

  @override
  Widget build(BuildContext context) {
    CurrentUser _currentUser = Provider.of<CurrentUser>(context, listen: false);
    String _uid = _currentUser.getUid;
    print(_currentUser.getUsername);
    final addItemButton = FloatingActionButton(
      backgroundColor: Colors.green,
      onPressed: () {
        newItem = null;
        descriptionInfo = null;
        _expiryDateTime = null;
        showDialog(
            context: context,
            builder: (BuildContext context) {
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
                      child: Text("Enter expiry date")),
                  RaisedButton(
                      onPressed: () async {
                        // if (newItem != null && _expiryDateTime != null) {
                        //   addToList(newItem, _expiryDateTime.toString(),
                        //       _description.text);
                        // }
                        // print(newItem);
                        // print(_expiryDateTime);
                        if (newItem != null && _expiryDateTime != null) {
                          if (widget.note != null) {
                            await eventDBS.updateData(widget.note.id, _uid, {
                              "item": newItem,
                              "description": _description.text,
                              "expiryDateTime": _expiryDateTime
                            });
                          } else {
                            await eventDBS.createItem(
                                _uid,
                                EventModel(
                                    item: newItem,
                                    description: _description.text,
                                    expiryDateTime: _expiryDateTime));
                          }
                        }
                        Navigator.of(context).pop();
                      },
                      child: Text("Confirm new item")),
                ],
              );
            });
      },
      child: Icon(Icons.add, color: Colors.white),
    );

    final settingsButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Colors.green,
      child: MaterialButton(
        elevation: 1000,
        minWidth: 50,
        padding: EdgeInsets.fromLTRB(100.0, 20.0, 100.0, 20.0),
        onPressed: moveToSettings,
        child: Text(
          "Settings",
          textAlign: TextAlign.center,
          style: GoogleFonts.kalam(
              fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );

    final chatRoomPageButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Colors.grey[800],
      child: MaterialButton(
        elevation: 1000,
        minWidth: 50,
        padding: EdgeInsets.fromLTRB(100.0, 20.0, 100.0, 20.0),
        onPressed: moveToChats,
        child: Text(
          "Chats",
          textAlign: TextAlign.center,
          style: GoogleFonts.kalam(
              fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );

    final expireeLogo = SizedBox(
      height: 230.0,
      child: Image.asset(
        "assets/images/expireelogo.png",
        fit: BoxFit.contain,
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Welcome back ${_currentUser.getUsername}",
          style: GoogleFonts.permanentMarker(
            fontSize: 30,
          ),
        ),
      ),
      body: Container(
        color: Colors.brown,
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 60,
              ),
              expireeLogo,
              SizedBox(
                height: 90,
              ),
              chatRoomPageButton,
              SizedBox(
                height: 10,
              ),
              settingsButton,
            ],
          ),
        ),
      ),
      floatingActionButton: addItemButton,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  void moveToSettings() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => SettingsPage()));
  }

  void moveToChats() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => ChatRoom()));
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
}
