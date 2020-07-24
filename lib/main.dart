import 'package:flutter/material.dart';
import 'package:expiree_app/expireeApp.dart';
import 'package:expiree_app/userProfile/locator.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setupServices();
  runApp(ExpireeApp());
}
