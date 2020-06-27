import 'package:firebase_auth_platform_interface/firebase_auth_platform_interface.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
//import 'expireeWelcome.dart';
import 'package:provider/provider.dart';
import "package:expiree_app/states/currentUser.dart";

class ChangePassword extends StatefulWidget {
  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  //final _formKey = GlobalKey<FormState>();
  //String _email, _password;
  final _passKey = GlobalKey<FormFieldState>();
  TextStyle style = GoogleFonts.chelseaMarket(
    fontSize: 20,
  );

  //TextEditingController _fullNameController = TextEditingController();
  TextEditingController _oldPWController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();

  void _signUpUser(String email, String password, BuildContext context) async {
    CurrentUser _currentUser = Provider.of<CurrentUser>(context, listen: false);

    try {
      String _returnString = await _currentUser.signUpUser(email, password);
      if (_returnString == "success") {
        Navigator.pop(context);
      } else {
        Scaffold.of(context).showSnackBar(
          SnackBar(
            content: Text(_returnString),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final newPasswordField = TextFormField(
      controller: _passwordController,
      key: _passKey,
      obscureText: true,
      //controller: TextEditingController(),
      style: GoogleFonts.roboto(
        fontSize: 17,
        color: Colors.black,
      ),
      decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          contentPadding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
          hintText: 'Type in a new password',
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(15.0))),
      validator: (input) {
        if (input.isEmpty) {
          return "Please provide a new password";
        } else if (input.length < 6) {
          return 'Password should be at least 6 characters long';
        }
        return null;
      },
      //onSaved: (input) => _password = input,
    );

    final confirmPasswordField = TextFormField(
      controller: _confirmPasswordController,
      obscureText: true,
      style: GoogleFonts.roboto(
        fontSize: 17,
        color: Colors.black,
      ),
      decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          contentPadding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
          hintText: 'Confirm your new password',
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(15.0))),
      validator: (input) {
        if (input.isEmpty) {
          return "Please confirm your password";
        }
        if (input != _passKey.currentState.value) {
          return 'Password does not match';
        }
        return null;
      },
    );

    final changePasswordButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Colors.brown,
      child: MaterialButton(
        minWidth: 90,
        padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
        onPressed: () async {
          if ((_passwordController.text == _confirmPasswordController.text)) {
            await FirebaseAuthPlatform.instance
                .updatePassword('Expiree Login', _passwordController.text);
          } else {
            Scaffold.of(context).showSnackBar(
              SnackBar(
                content: Text("Passwords do not match"),
                duration: Duration(seconds: 2),
              ),
            );
          }
        },
        child: Text(
          'Create Account',
          textAlign: TextAlign.center,
          style: GoogleFonts.permanentMarker(fontSize: 22, color: Colors.white),
        ),
      ),
    );

    final cancelButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Colors.red[900],
      child: MaterialButton(
        minWidth: 90,
        //MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
        onPressed: () {
          Navigator.pop(context);
        },
        child: Text('Cancel and Go Back',
            textAlign: TextAlign.center,
            style:
                GoogleFonts.permanentMarker(fontSize: 22, color: Colors.white)),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Create a new account'),
      ),
      body: SingleChildScrollView(
        child: Form(
          //key: _formKey,
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(36.0),
              child: Column(
                //infinite height
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'New Password',
                    style: GoogleFonts.kalam(fontSize: 20, color: Colors.black),
                    textAlign: TextAlign.start,
                  ),
                  newPasswordField,
                  SizedBox(height: 20.0),
                  Text(
                    'Confirm your new password',
                    style: GoogleFonts.kalam(fontSize: 20, color: Colors.black),
                    textAlign: TextAlign.start,
                  ),
                  confirmPasswordField,
                  SizedBox(height: 20.0),
                  changePasswordButton,
                  SizedBox(height: 20.0),
                  cancelButton,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /*Future<void> signUp() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      try {
        FirebaseUser user = (await FirebaseAuth.instance
                .createUserWithEmailAndPassword(
                    email: _email, password: _password))
            .user;
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ExpireeWelcome()));
      } catch (e) {
        print(e.message);
      }
    }
  }*/
}
