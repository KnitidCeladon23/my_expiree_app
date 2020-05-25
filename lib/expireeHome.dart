import 'package:flutter/material.dart';
import 'package:expiree_app/inventoryList.dart';

class ExpireeHome extends StatefulWidget {
  @override
  _ExpireeHomeState createState() => _ExpireeHomeState();
}

class _ExpireeHomeState extends State<ExpireeHome> {
  TextStyle style = TextStyle(fontFamily: 'Comic Sans', fontSize: 20.0);

  @override
  Widget build(BuildContext context) {
    final calendarButton = Material(
      elevation: 5.0,
      child: RaisedButton(
        color: Colors.lightBlue[300],
        padding: EdgeInsets.fromLTRB(20, 20.0, 20, 20.0),
        onPressed: () {
          //to be implemented
        },
        child: Text("Calendar",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.black, fontWeight: FontWeight.bold)),
      ),
    );

    final inventoryButton = Material(
      elevation: 5.0,
      child: RaisedButton(
        color: Colors.red[200],
        padding: EdgeInsets.fromLTRB(20, 20.0, 20, 20.0),
        onPressed: moveToInventory,
        child: Text("Inventory",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.black, fontWeight: FontWeight.bold)),
      ),
    );

    final buttons = Center(
      child: Container(
          child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
            calendarButton,
            SizedBox(width: 20.0),
            inventoryButton,
          ])),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text("Welcome back"),
      ),
      body: Center(
          child: Container(
            color: Colors.brown,
            child: Padding(
              padding: const EdgeInsets.all(50.4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  buttons,
                ],
              ),
            ),
          ),
        ),
      );
  }

  void moveToInventory() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => InventoryList()));
  }
}
