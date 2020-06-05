import "package:expiree_app/expireeHome.dart";
import 'package:expiree_app/expireeWelcome.dart';
import 'package:flutter/material.dart';
import 'package:expiree_app/states/currentUser.dart';
import 'package:provider/provider.dart';

enum AuthStatus {
  notLoggedIn, 
  loggedIn 
  }

class RootPage extends StatefulWidget {
  @override
  _RootPageState createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  AuthStatus _authStatus = AuthStatus.notLoggedIn;

  @override 
  void didChangeDependencies() async {
    super.didChangeDependencies();
    //get the state, check current User, set AuthStatus based on state
    CurrentUser _currentUser = Provider.of<CurrentUser>(context, listen: false);
    String _returnString = await _currentUser.onStartUp();
    if (_returnString == "success") {
      setState(() {
        _authStatus = AuthStatus.loggedIn;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget retVal;

    switch (_authStatus) {
      case AuthStatus.notLoggedIn:
        retVal = ExpireeWelcome();
        break;
      case AuthStatus.loggedIn:
        retVal = ExpireeHome();
        break;
      default:
    }
    return retVal;
  }
}
