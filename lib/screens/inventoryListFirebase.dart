import 'dart:typed_data';

import 'package:expiree_app/screens/imagePickerPage.dart';
import 'package:expiree_app/states/currentUser.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:expiree_app/notification/createNotifPage.dart';
import 'package:provider/provider.dart';
//import 'package:google_fonts/google_fonts.dart';
import 'package:expiree_app/calendar/model/event.dart';
import 'package:expiree_app/calendar/res/event_firestore_service.dart';
import 'package:expiree_app/screens/urlLauncher.dart';
// import 'package:firebase_storage/firebase_storage.dart';

class InventoryListFirebase extends StatefulWidget {
  final EventModel note;
  const InventoryListFirebase({Key key, this.note}) : super(key: key);
  @override
  _InventoryListFirebaseState createState() => _InventoryListFirebaseState();
}

class _InventoryListFirebaseState extends State<InventoryListFirebase> {
  TextStyle style = GoogleFonts.permanentMarker(
    fontSize: 30,
  );
  DateTime _entryDateTime;
  DateTime _expiryDateTime;
  String newItem;
  String itemID;
  final databaseReference = Firestore.instance;
  // final storage = FirebaseStorage.instance;
  final FirebaseStorage _storage =
      FirebaseStorage(storageBucket: 'gs://expiree-login-51433.appspot.com/');

  StorageUploadTask _uploadTask;

  String deleteExpiryDateTime;
  String deleteItem;
  TextEditingController _description;

  @override
  void initState() {
    super.initState();
    _description = TextEditingController(
        text: widget.note != null ? widget.note.description : "");
    itemID = null;
  }

  void moveToURL(String foodItem) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => URLLauncher(
                title: "Recipe for " + foodItem, foodItem: foodItem)));
  }

  Widget findRecipeButton(String foodItem) {
    return SizedBox(
      width: 50,
      child: RaisedButton(
        onPressed: () {
          moveToURL(foodItem);
        },
        child: Text('R'),
      ),
    );
  }

  List<Widget> makeListWidget(AsyncSnapshot snapshot) {
    CurrentUser _currentUser = Provider.of<CurrentUser>(context, listen: false);
    String _uid = _currentUser.getUid;
    StorageReference photosReference = _storage.ref().child(_uid);
    Uint8List imageFile;
    getImage() {}

    return snapshot.data.documents.map<Widget>((document) {
      Widget avatar(String foodID) {
        int maxSize = 7 * 1024 * 1024;
        photosReference.child(foodID + ".png").getData(maxSize).then((data) {
          imageFile = data;
        }).catchError((error) {
          print(error);
          print(foodID);
        });

        if (imageFile == null) {
          return Text(document['item'][0]);
        } else {
          return Image.memory(imageFile);
        }
      }

      return Card(
        child: Container(
          padding: EdgeInsets.all(8.0),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          CircleAvatar(
                            child: avatar(document['id']),
                          ),
                          Padding(padding: EdgeInsets.only(right: 10.0)),
                          Text(
                            document['item'],
                            style: TextStyle(fontSize: 20.0),
                          ),
                          Padding(padding: EdgeInsets.only(right: 10.0)),
                        ],
                      ),
                    ),
                    findRecipeButton(document['item']),
                    SizedBox(
                      width: 10,
                    ),
                    ButtonTheme(
                        buttonColor: Colors.brown[400],
                        materialTapTargetSize: MaterialTapTargetSize
                            .shrinkWrap, //limits the touch area to the button area
                        minWidth: 0, //wraps child's width
                        height: 0, //wraps child's height
                        child: RaisedButton(
                            padding: EdgeInsets.all(8.0),
                            onPressed: navigateToNotificationCreation,
                            child: Text('Remind me!'))),
                    SizedBox(width: 15),
                    ButtonTheme(
                        buttonColor: Colors.grey[300],
                        materialTapTargetSize: MaterialTapTargetSize
                            .shrinkWrap, //limits the touch area to the button area
                        minWidth: 0, //wraps child's width
                        height: 0, //wraps child's height
                        child: RaisedButton(
                          padding: EdgeInsets.all(8.0),
                          onPressed: () {
                            try {
                              databaseReference
                                  .collection('inventorylists')
                                  .document(_uid)
                                  .collection("indivInventory")
                                  .document(document.documentID)
                                  .delete();
                            } catch (e) {
                              print(e.toString());
                            }
                          },
                          child: Icon(
                            IconData(59506, fontFamily: 'MaterialIcons'),
                            size: 30,
                          ),
                        ))
                  ],
                ),
                SizedBox(height: 10),
                Text(
                  document['expiryDateTime'].substring(0, 10),
                  style: TextStyle(fontSize: 10.0),
                ),
              ]),
        ),
      );
    }).toList();
  }

  Future<void> navigateToNotificationCreation() async {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CreateNotificationPage(),
      ),
    );
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

  void addToList(String item, String expiryDateTime, String description,
      String foodID) async {
    CurrentUser _currentUser = Provider.of<CurrentUser>(context, listen: false);
    String _uid = _currentUser.getUid;
    await databaseReference
        .collection("inventorylists")
        .document(_uid)
        .collection("indivInventory")
        .add({
      'item': item,
      'expiryDateTime': expiryDateTime,
      'description': description,
      'id': foodID,
    });
    setState(() {
      itemID = foodID;
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
        _expiryDateTime = null;
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Add Item"),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      TextField(onChanged: (String input) {
                        newItem = input;
                      }),
                      SizedBox(height: 15),
                      TextFormField(
                        controller: _description,
                        minLines: 3,
                        maxLines: 5,
                        validator: (value) =>
                            (value.isEmpty) ? "Please enter description" : null,
                        style: style,
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
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ImagePickerPage(
                                    userID: widget.note.id, itemID: itemID)));
                        setState(() {
                          itemID = null;
                        });
                      },
                      child: Text("Picture")),
                  FlatButton(
                      onPressed: () {
                        _selectExpiryDate(context);
                      },
                      child: Text("Enter expiry date")),
                  RaisedButton(
                      onPressed: () async {
                        if (newItem != null && _expiryDateTime != null) {
                          addToList(newItem, _expiryDateTime.toString(),
                              _description.text, DateTime.now().toString());
                        }
                        if (widget.note != null) {
                          await eventDBS.updateData(widget.note.id, _uid, {
                            "item": newItem,
                            "description": _description.text,
                            "expiryDateTime": _expiryDateTime,
                          });
                        } else {
                          await eventDBS.createItem(
                              _uid,
                              EventModel(
                                  item: newItem,
                                  description: _description.text,
                                  expiryDateTime: _expiryDateTime));
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
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Inventory',
          style: style,
        ),
      ),
      body: Container(
          child: StreamBuilder(
              stream: databaseReference
                  .collection('inventorylists')
                  .document(_uid)
                  .collection("indivInventory")
                  .snapshots(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return Center(child: CircularProgressIndicator());
                  default:
                    return ListView(
                      children: makeListWidget(snapshot),
                    );
                }
              })),
      floatingActionButton: addItemButton,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
