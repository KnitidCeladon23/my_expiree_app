import 'package:expiree_app/screens/rootPage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:expiree_app/calendar/calendar.dart';
import "package:expiree_app/states/currentUser.dart";
import 'package:provider/provider.dart';
// import 'package:expiree_app/screens/inventoryListFirebase.dart';
// import 'package:expiree_app/screens/reminderPage.dart';
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
                SizedBox(height: 10,),
                signOutButton,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
