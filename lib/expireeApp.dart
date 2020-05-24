import 'package:flutter/material.dart';
import 'expireeWelcome.dart';

class ExpireeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expiree',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: ExpireeWelcome(title: 'Expiree'),
    );
  }
}
