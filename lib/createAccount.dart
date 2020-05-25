import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'expireeWelcome.dart';

class CreateAccount extends StatefulWidget {
  @override
  _CreateAccountState createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  final _formKey = GlobalKey<FormState>();
  String _email, _password;
  final _passKey = GlobalKey<FormFieldState>();
  TextStyle style = GoogleFonts.chelseaMarket(
    fontSize: 20,
  );

  @override
  Widget build(BuildContext context) {
    final newEmailField = TextFormField(
      obscureText: false,
      style: style,
      decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          contentPadding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
          hintText: 'Type in your email',
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(15.0))),
      validator: (input) {
        if (input.isEmpty) {
          return 'No email detected';
        } else if (!input.contains('@')) {
          return 'Input is not an email';
        }
        return null;
      },
      onSaved: (input) => _email = input,
    );

    final newPasswordField = TextFormField(
      key: _passKey,
      obscureText: true,
      controller: TextEditingController(),
      style: style,
      decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          contentPadding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
          hintText: 'Type in a new password',
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(15.0))),
      validator: (input) {
        if (input.length < 6) {
          return 'Password should be at least 6 characters long';
        }
        return null;
      },
      onSaved: (input) => _password = input,
    );

    final confirmPasswordField = TextFormField(
      obscureText: true,
      style: style,
      decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          contentPadding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
          hintText: 'Type in password again',
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(15.0))),
      validator: (input) {
        if (input != _passKey.currentState.value) {
          return 'Password does not match';
        }
        return null;
      },
    );

    final createAccountButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Colors.brown,
      child: MaterialButton(
        minWidth: 90,
        padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
        onPressed: signUp,
        child: Text('Create Account',
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
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
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Create a new account'),
      ),
      body: Form(
        key: _formKey,
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
                  'Email',
                  style: TextStyle(fontSize: 20, color: Colors.black),
                  textAlign: TextAlign.start,
                ),
                newEmailField,
                SizedBox(height: 20.0),
                Text(
                  'Password',
                  style: TextStyle(fontSize: 20, color: Colors.black),
                  textAlign: TextAlign.start,
                ),
                newPasswordField,
                SizedBox(height: 20.0),
                Text(
                  'Confirm your new password',
                  style: TextStyle(fontSize: 20, color: Colors.black),
                  textAlign: TextAlign.start,
                ),
                confirmPasswordField,
                SizedBox(height: 20.0),
                createAccountButton,
                SizedBox(height: 20.0),
                cancelButton,
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> signUp() async {
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
  }
}
