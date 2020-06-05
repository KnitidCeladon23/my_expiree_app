import 'package:flutter/material.dart';
import 'package:expiree_app/rootPage.dart';
import 'package:provider/provider.dart';
import 'package:expiree_app/states/currentUser.dart';

class ExpireeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CurrentUser(),
      child: MaterialApp(
          title: 'Expiree',
          theme: ThemeData(
            primarySwatch: Colors.green,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: Scaffold(
            body: RootPage(),
          )),
    );
  }
}
