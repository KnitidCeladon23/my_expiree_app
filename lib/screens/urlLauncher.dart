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

  Future<void> _launchInBrowser(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: false,
        forceWebView: false,
        headers: <String, String>{'my_header_key': 'my_header_value'},
      );
    } else {
      throw 'Could not launch $url';
    }
  }

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

  Future<void> _launchInWebViewWithJavaScript(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: true,
        forceWebView: true,
        enableJavaScript: true,
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> _launchInWebViewWithDomStorage(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: true,
        forceWebView: true,
        enableDomStorage: true,
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> _launchUniversalLinkIos(String url) async {
    if (await canLaunch(url)) {
      final bool nativeAppLaunchSucceeded = await launch(
        url,
        forceSafariVC: false,
        universalLinksOnly: true,
      );
      if (!nativeAppLaunchSucceeded) {
        await launch(
          url,
          forceSafariVC: true,
        );
      }
    }
  }

  Widget _launchStatus(BuildContext context, AsyncSnapshot<void> snapshot) {
    if (snapshot.hasError) {
      return Text('Error: ${snapshot.error}');
    } else {
      return const Text('');
    }
  }

  Future<void> _makePhoneCall(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    String foodItem = widget.foodItem;
    String toLaunch =
        "https://www.google.com/search?q=" + foodItem + "%20recipe";

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView(
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Material(
                elevation: 5.0,
                child: RaisedButton(
                  color: Colors.red[200],
                  padding: EdgeInsets.fromLTRB(20, 20.0, 20, 20.0),
                  onPressed: () => setState(() {
                  _launched = _launchInBrowser(toLaunch);
                }),
                  child: Text("Launch in Browser",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.kalam(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      )),
                ),
              ),
              const Padding(padding: EdgeInsets.all(16.0)),
              Material(
                elevation: 5.0,
                child: RaisedButton(
                  color: Colors.red[200],
                  padding: EdgeInsets.fromLTRB(20, 20.0, 20, 20.0),
                  onPressed: () => setState(() {
                  _launched = _launchInWebViewOrVC(toLaunch);
                }),
                  child: Text("Launch in App",
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
        ],
      ),
    );
  }
}
