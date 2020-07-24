import 'package:expiree_app/screens/rootPage.dart';
import 'package:expiree_app/userProfile/profile_view.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import "package:expiree_app/states/currentUser.dart";
import 'package:provider/provider.dart';
import 'package:expiree_app/notification/app_bloc.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
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
    var listView = ListView(
      children: <Widget>[
        ListTile(
          leading: Icon(Icons.account_circle),
          title: Text(
            "Sign out",
          ),
          trailing: Icon(Icons.update),
          onTap: () async {
            CurrentUser _currentUser =
                Provider.of<CurrentUser>(context, listen: false);
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
        ),
        ListTile(
            leading: Icon(Icons.track_changes),
            title: Text(
              "Change Password",
            ),
            trailing: Icon(Icons.update),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ProfileView()));
            }),
        ListTile(
            leading: Icon(Icons.language),
            title: Text("Languages"),
            subtitle: Text("Choose which language to use"),
            trailing: Icon(Icons.update),
            onTap: () {}),
      ],
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Settings",
          style: GoogleFonts.permanentMarker(
            fontSize: 30,
          ),
        ),
      ),
      body: listView,
    );
  }
}
