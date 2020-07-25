import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class URLLauncher extends StatefulWidget {
  URLLauncher({Key key, this.title, this.foodItem}) : super(key: key);
  final String title;
  final String foodItem;

  @override
  _URLLauncherState createState() => _URLLauncherState();
}

class _URLLauncherState extends State<URLLauncher> {
  Future<void> _launched;
  String _phone = '';

  // Future<void> _launchInBrowser(String url) async {
  //   if (await canLaunch(url)) {
  //     await launch(
  //       url,
  //       forceSafariVC: false,
  //       forceWebView: false,
  //       headers: <String, String>{'my_header_key': 'my_header_value'},
  //     );
  //   } else {
  //     throw 'Could not launch $url';
  //   }
  // }

  Future<void> _launchInWebViewOrVC(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: true,
        forceWebView: true,
        headers: <String, String>{'my_header_key': 'my_header_value'},
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    String foodItem = widget.foodItem;
    String toLaunch = "https://www.google.com/search?q=" +
        foodItem.replaceAll(' ', '%20') +
        "%20recipe";

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Browse Recipe',
          style: GoogleFonts.permanentMarker(
            fontSize: 30,
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(color: Colors.brown),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              const Padding(padding: EdgeInsets.all(16.0)),
              SizedBox(height: 90),
              SizedBox(
                height: 210.0,
                child: Image.asset(
                  "assets/images/recipes.png",
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(height: 30),
              Material(
                elevation: 5.0,
                child: RaisedButton(
                  color: Colors.red[200],
                  padding: EdgeInsets.fromLTRB(20, 20.0, 20, 20.0),
                  onPressed: () => setState(() {
                    _launched = _launchInWebViewOrVC(toLaunch);
                  }),
                  child: Text(
                      "Recipes for: " +
                          foodItem
                              .split(' ')
                              .map((word) =>
                                  word[0].toUpperCase() + word.substring(1))
                              .join(' '),
                      textAlign: TextAlign.center,
                      style: GoogleFonts.kalam(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
