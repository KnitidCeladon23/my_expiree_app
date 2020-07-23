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
  final databaseReference = Firestore.instance;

  List<Widget> makeListWidget(AsyncSnapshot snapshot) {
    CurrentUser _currentUser = Provider.of<CurrentUser>(context, listen: false);
    String _uid = _currentUser.getUid;

    return snapshot.data.documents.map<Widget>((document) {
      return Card(
        color: Colors.brown[400],
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(27.0)),
        child: Container(
          padding: EdgeInsets.all(8.0),
          child: Row(
            children: <Widget>[
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                        document['title'][0].toUpperCase() +
                            (document['title'] + ':').substring(
                              1,
                            ),
                        style: GoogleFonts.anton(fontSize: 25)),
                    Padding(padding: EdgeInsets.only(right: 10.0)),
                    Text(
                      document['description'],
                      style: TextStyle(fontSize: 19.0),
                    ),
                    Padding(padding: EdgeInsets.only(right: 10.0)),
                    Text(
                      document['dateTimeStr'].substring(0, 16),
                      style: TextStyle(fontSize: 15.0),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 20,
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
          style: GoogleFonts.permanentMarker(
            fontSize: 30,
          ),
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
