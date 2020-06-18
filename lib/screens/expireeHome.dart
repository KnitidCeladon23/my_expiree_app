import 'package:expiree_app/screens/rootPage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:expiree_app/calendar/calendar.dart';
import "package:expiree_app/states/currentUser.dart";
import 'package:provider/provider.dart';
import 'package:expiree_app/screens/inventoryListFirebase.dart';
import 'package:expiree_app/screens/reminderPage.dart';
import 'package:expiree_app/notification/app_bloc.dart';

class ExpireeHome extends StatefulWidget {
  @override
  _ExpireeHomeState createState() => _ExpireeHomeState();
}

class _ExpireeHomeState extends State<ExpireeHome> {
  TextStyle style = TextStyle(fontFamily: 'Comic Sans', fontSize: 20.0);
  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () async {
      final appBloc = Provider.of<AppBloc>(context, listen: false); 
      await appBloc.init();
    });
  }

  @override
  Widget build(BuildContext context) {
    final calendarButton = Material(
      elevation: 5.0,
      child: RaisedButton(
        color: Colors.lightBlue[300],
        padding: EdgeInsets.fromLTRB(20, 20.0, 20, 20.0),
        onPressed: moveToCalendar,
        child: Text("Calendar",
            textAlign: TextAlign.center,
            style: GoogleFonts.kalam(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            )),
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
            style: GoogleFonts.kalam(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            )),
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

    final signOutButton = Material(
      elevation: 5.0,
      child: RaisedButton(
        color: Colors.red,
        padding: EdgeInsets.fromLTRB(20, 20.0, 20, 20.0),
        onPressed: () async {
            CurrentUser _currentUser = Provider.of<CurrentUser>(context, listen: false);
            String _returnString = await _currentUser.signOut();
            if (_returnString == "success") {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => RootPage(),
                ),
                (route) => false,
              );
            }
          },
        child: Text("Sign Out",
            textAlign: TextAlign.center,
            style: GoogleFonts.kalam(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            )),
      ),
    );

    final remindersButton = Material(
      elevation: 5.0,
      child: RaisedButton(
        color: Colors.red[200],
        padding: EdgeInsets.fromLTRB(20, 20.0, 20, 20.0),
        onPressed: moveToReminder,
        child: Text("Reminders",
            textAlign: TextAlign.center,
            style: GoogleFonts.kalam(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            )),
      ),
    );

    final buttons1 = Center(
      child: Container(
          child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
            remindersButton,
            SizedBox(width: 20.0),
            signOutButton,
          ])),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text("Welcome back",
        style: GoogleFonts.permanentMarker(
          fontSize: 30,),
      ),),
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
                SizedBox(height: 10,),
                buttons1,
              ],
            ),
          ),
        ),
      ),
    );
  }

  void moveToReminder() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => ReminderPage()));
  }

  void moveToInventory() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => InventoryListFirebase()));
  }

  void moveToCalendar() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => Calendar()));
  }
}
