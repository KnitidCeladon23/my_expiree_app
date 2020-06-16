import 'package:expiree_app/states/currentUser.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ReminderPage extends StatefulWidget {
  @override
  _ReminderPageState createState() => _ReminderPageState();
}

class _ReminderPageState extends State<ReminderPage> {
  TextStyle style = GoogleFonts.permanentMarker(
    fontSize: 20,
  );
  //String newItem;
  final databaseReference = Firestore.instance;
  //String deleteExpiryDateTime;
  //String deleteItem;
  

  List<Widget> makeListWidget(AsyncSnapshot snapshot) {
    CurrentUser _currentUser = Provider.of<CurrentUser>(context, listen: false);
    String _uid = _currentUser.getUid;
    
    return snapshot.data.documents.map<Widget>((document) {
      return Card(
        child: Container(
          padding: EdgeInsets.all(8.0),
          child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(document['title'],
                          style: TextStyle(fontSize: 20.0)),
                          Padding(padding: EdgeInsets.only(right: 10.0)),
                          Text(
                            document['description'],
                            style: TextStyle(fontSize: 15.0),
                          ),
                          Padding(padding: EdgeInsets.only(right: 10.0)),
                        ],
                      ),
                    ),
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
                                  .collection('users')
                                  .document(_uid)
                                  .collection("notifications")
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
        ),
      );
    }).toList();
  }

  /*void deleteEntry(String documentID) {
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
  }*/

  @override
  Widget build(BuildContext context) {
    CurrentUser _currentUser = Provider.of<CurrentUser>(context, listen: false);
    String _uid = _currentUser.getUid;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Reminders',
          style: style,
        ),
      ),
      body: Container(
          child: StreamBuilder(
              stream: databaseReference
                  .collection('users')
                  .document(_uid)
                  .collection("notifications")
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
    );
  }
}
