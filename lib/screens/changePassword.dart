import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import "package:expiree_app/states/currentUser.dart";
import 'package:firebase_auth/firebase_auth.dart';

class ChangePassword extends StatefulWidget {
  ChangePassword({Key key, this.title}) : super(key: key);
//hi
  final String title;

  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  TextEditingController _emailController = TextEditingController();
  TextStyle style = GoogleFonts.chelseaMarket(
    fontSize: 20,);
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {

    final emailField = TextFormField(
      controller: _emailController,
      obscureText: false,
      style: GoogleFonts.roboto(
        fontSize: 17,
        color: Colors.black,
      ),
      validator: (input) {
        if (input.isEmpty) {
          return 'Please key in your email';
        }
        return null;
      },
      decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          contentPadding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
          hintText: "Email",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(15.0))),
      //onSaved: (input) => _email = input,
    );

    final submitButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Colors.white,
      child: MaterialButton(
        minWidth: 170,
        padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
        onPressed: () async {
                await _firebaseAuth.sendPasswordResetEmail(email: _emailController.text);
                Navigator.pop(context);
            },
        child: Text("Submit",
            textAlign: TextAlign.center,
            style: GoogleFonts.permanentMarker(
              fontSize: 20,
              color: Colors.black),
                //color: Colors.white, fontWeight: FontWeight.bold)
                ),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Change Password',
          style: TextStyle(fontSize: 30.0, wordSpacing: 5.0),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
            color: Colors.white,
            child: Padding(
              padding: EdgeInsets.all(36.0),
              child: Column(
                //infinite height
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Please key in an Email address to receive a link',
                    style: GoogleFonts.kalam(fontSize: 20, color: Colors.black),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20.0),
                  emailField,
                  SizedBox(height: 20.0),
                  submitButton,
                ],
              ),
            ),
          ),
      ),
    );
  }
}
