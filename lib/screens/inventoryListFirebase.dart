import 'package:expiree_app/states/currentUser.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:expiree_app/notification/createNotifPage.dart';
import 'package:provider/provider.dart';

class InventoryListFirebase extends StatefulWidget {
  @override
  _InventoryListFirebaseState createState() => _InventoryListFirebaseState();
}

class _InventoryListFirebaseState extends State<InventoryListFirebase> {
  TextStyle style = GoogleFonts.permanentMarker(
    fontSize: 20,
  );
  DateTime _entryDateTime;
  DateTime _expiryDateTime;
  String newItem;
  final databaseReference = Firestore.instance;
  String deleteExpiryDateTime;
  String deleteItem;
  

  List<Widget> makeListWidget(AsyncSnapshot snapshot) {
    CurrentUser _currentUser = Provider.of<CurrentUser>(context, listen: false);
    String _uid = _currentUser.getUid;
    return snapshot.data.documents.map<Widget>((document) {
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
                            child: Text(document['item'][0]),
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

  void deleteEntry(String documentID) {
    CurrentUser _currentUser = Provider.of<CurrentUser>(context, listen: false);
    String _uid = _currentUser.getUid;
    try {
      databaseReference
          .collection('inventorylists')
          .document(_uid)
          .collection("indivInventory")
          .document(documentID)
          .delete();
    } catch (e) {
      print(e.toString());
    }
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
    //print(_expiryDateTime.toString());
  }

  void addToList(String item, String expiryDateTime) async {
    CurrentUser _currentUser = Provider.of<CurrentUser>(context, listen: false);
    String _uid = _currentUser.getUid;
    await databaseReference
        .collection("inventorylists")
        .document(_uid)
        .collection("indivInventory")
        .add({
      'item': item,
      'expiryDateTime': expiryDateTime,
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
                content: TextField(onChanged: (String input) {
                  newItem = input;
                }),
                actions: <Widget>[
                  FlatButton(
                      onPressed: () {
                        _selectExpiryDate(context);
                      },
                      child: Text("Enter expiry date")),
                  RaisedButton(
                      onPressed: () {
                        if (newItem != null && _expiryDateTime != null) {
                          addToList(newItem, _expiryDateTime.toString());
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
