import 'package:flutter/material.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:expiree_app/expireeHome.dart';
import 'package:expiree_app/createAccount.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import "package:expiree_app/states/currentUser.dart";

enum LoginType {
  email,
  google,
}

class ExpireeWelcome extends StatefulWidget {
  ExpireeWelcome({Key key, this.title}) : super(key: key);
//hi
  final String title;

  @override
  _ExpireeWelcomeState createState() => _ExpireeWelcomeState();
}

class _ExpireeWelcomeState extends State<ExpireeWelcome> {
  //final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  //String _email, _password;
  TextStyle style = GoogleFonts.chelseaMarket(
    fontSize: 20,);

  @override
  Widget build(BuildContext context) {

    void _loginUser({
    @required LoginType type,
    String email,
    String password,
    BuildContext context,
  }) async {
    CurrentUser _currentUser = Provider.of<CurrentUser>(context, listen: false);

    try {
      String _returnString;

      switch (type) {
        case LoginType.email:
          _returnString = await _currentUser.loginUserWithEmail(email, password);
          break;
        case LoginType.google:
          _returnString = await _currentUser.loginUserWithGoogle();
          break;
        default:
      }

      if (_returnString == "success") {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => ExpireeHome(),
          ),
          (route) => false,
        );
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

    final expireeLogo = SizedBox(
      height: 200.0,
      child: Image.asset(
        "assets/images/expireeLogo.jpeg",
        fit: BoxFit.contain,
      ),
    );

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

    final passwordField = TextFormField(
      controller: _passwordController,
      obscureText: true,
      style: GoogleFonts.roboto(
        fontSize: 17,
        color: Colors.black,
      ),
      validator: (input) {
        if (input.isEmpty) {
          return "Please key in your password";
        }
        if (input.length < 6) {
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
      //onSaved: (input) => _password = input,
    );

    final loginButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Colors.brown,
      child: MaterialButton(
        minWidth: 170,
        padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
        onPressed: () {
              _loginUser(
                  type: LoginType.email,
                  email: _emailController.text,
                  password: _passwordController.text,
                  context: context);
            },
        child: Text("Login",
            textAlign: TextAlign.center,
            style: GoogleFonts.permanentMarker(
              fontSize: 20,
              color: Colors.white),
                //color: Colors.white, fontWeight: FontWeight.bold)
                ),
      ),
    );

    final createAccountButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Colors.brown,
      child: MaterialButton(
        elevation: 1000,
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
            style: GoogleFonts.permanentMarker(
              fontSize: 20,
              color: Colors.white),
              ),
      ),
    );

  //not implemented properly yet, can be used as an extension
    Widget googleButton() {
    return OutlineButton(
      splashColor: Colors.grey,
      onPressed: () {
        _loginUser(type: LoginType.google, context: context);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CreateAccount(), fullscreenDialog: true),
          );
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      highlightElevation: 0,
      borderSide: BorderSide(color: Colors.grey),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(image: AssetImage("assets/images/google_logo.png"), height: 25.0),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                'Sign in with Google',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.grey,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Expiree',
          style: TextStyle(fontSize: 30.0, wordSpacing: 5.0),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          //key: _formKey,
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: EdgeInsets.all(36.0),
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
                  googleButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

/*Future<void> logIn() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      try {
        FirebaseUser user = (await FirebaseAuth.instance
                .signInWithEmailAndPassword(email: _email, password: _password))
            .user;
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ExpireeHome()));
      } catch (e) {
        print(e.message);
      }
    }
  }*/
}
