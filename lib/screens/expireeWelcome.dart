import 'package:flutter/material.dart';
import 'package:expiree_app/screens/rootPage.dart';
import 'package:expiree_app/screens/createAccount.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import "package:expiree_app/states/currentUser.dart";
import 'package:expiree_app/screens/changePassword.dart';

enum LoginType {
  email,
  // google,
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
      }

      if (_returnString == "success") {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => RootPage(),
          ),
          (route) => false,
        );
      } else {
        Scaffold.of(context).showSnackBar(
          SnackBar(
            content: Text(_returnString),
            duration: Duration(seconds: 5),
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
        //"assets/images/expireeLogo.jpeg",
        "assets/images/expireelogo.png",
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

    final forgotPasswordButton = Material(
      elevation: 0.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Colors.white,
      child: MaterialButton(
        minWidth: 170,
        padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ChangePassword(), fullscreenDialog: true),
          );
            },
        child: Text("Forgot password?",
            textAlign: TextAlign.center,
            style: GoogleFonts.roboto(
              fontSize: 15,
              color: Colors.black,
              decoration: TextDecoration.underline,),
                ),
      ),
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
                  forgotPasswordButton,
                  SizedBox(height: 20.0),
                  loginButton,
                  SizedBox(height: 20.0),
                  createAccountButton,
                  SizedBox(height: 20.0),
                  //googleButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
