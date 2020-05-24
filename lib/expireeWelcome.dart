import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'expireeHome.dart';
import 'createAccount.dart';

class ExpireeWelcome extends StatefulWidget {
  ExpireeWelcome({Key key, this.title}) : super(key: key);
//hi
  final String title;

  @override
  _ExpireeWelcomeState createState() => _ExpireeWelcomeState();
}

class _ExpireeWelcomeState extends State<ExpireeWelcome> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _email, _password;
  TextStyle style = TextStyle(fontFamily: 'Comic Sans', fontSize: 20.0);

  @override
  Widget build(BuildContext context) {
    final expireeLogo = SizedBox(
      height: 200.0,
      child: Image.asset(
        "assets/images/expireeLogo.jpeg",
        fit: BoxFit.contain,
      ),
    );

    final emailField = 
    TextFormField(
      obscureText: false,
      style: style,
      validator: (input) {
                if(input.isEmpty){
                  return 'Provide an email';
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
      onSaved: (input) => _email = input,
    );

    final passwordField = 
    TextFormField(
      obscureText: true,
      style: style,
      validator: (input) {
                if(input.length < 6){
                  return 'Longer password please';
                }
                return null;
              },
      decoration: InputDecoration(
        fillColor: Colors.white,
        filled: true,
        contentPadding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
        hintText: "Password",
        border:
            OutlineInputBorder(borderRadius: BorderRadius.circular(15.0))),
      onSaved: (input) => _password = input,
    );

    final loginButton = 
    Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Colors.brown,
      child: MaterialButton(
        minWidth: 170,
        padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
        onPressed: logIn,
        child: Text("Login",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    final createAccountButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Colors.brown,
      child: MaterialButton(
        minWidth: 20,
        padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
        onPressed: () {
          //navigate to createaccount;
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CreateAccount(), fullscreenDialog: true),
          );
        },
        child: Text("Create a New Account",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Expiree',
          style: TextStyle(fontSize: 30.0, wordSpacing: 5.0),
        ),
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
                expireeLogo,
                SizedBox(height: 20.0),
                emailField,
                SizedBox(height: 20.0),
                passwordField,
                SizedBox(height: 20.0),
                loginButton,
                SizedBox(height: 20.0),
                createAccountButton,
                SizedBox(height: 20.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
  Future<void> logIn() async {
    if(_formKey.currentState.validate()){
      _formKey.currentState.save();
      try{
        FirebaseUser user = (await FirebaseAuth.instance.signInWithEmailAndPassword(email: _email, password: _password)).user;
        Navigator.push(context, MaterialPageRoute(builder: (context) => ExpireeHome()));
      }catch(e){
        print(e.message);
      }
    }
  }
}
