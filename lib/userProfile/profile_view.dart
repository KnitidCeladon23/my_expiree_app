import 'package:expiree_app/userProfile/locator.dart';
import 'package:expiree_app/userProfile/user_model.dart';
import 'package:expiree_app/userProfile/user_controller.dart';
import 'package:expiree_app/userProfile/manage_profile_information_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileView extends StatefulWidget {
  static String route = "profile-view";

  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  UserModel _currentUser = locator.get<UserController>().currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Manage User Profile",
          style: GoogleFonts.permanentMarker(
            fontSize: 30,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SizedBox(height: 20,),
          Text(
            "Hi ${_currentUser.displayName ?? 'nice to see you here.'}!",
            textAlign: TextAlign.center,
            style: GoogleFonts.oswald(fontSize: 30, color: Colors.black),
          ),
          ManageProfileInformationWidget(
            currentUser: _currentUser,
          ),
          // Expanded(
          //   flex: 2,
          //   child: ManageProfileInformationWidget(
          //     currentUser: _currentUser,
          //   ),
          // )
        ],
      ),
    );
  }
}
