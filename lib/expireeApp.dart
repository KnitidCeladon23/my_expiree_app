import 'package:flutter/material.dart';
import 'package:expiree_app/screens/rootPage.dart';
import 'package:provider/provider.dart';
import 'package:expiree_app/states/currentUser.dart';
import 'package:expiree_app/notification/app_bloc.dart';

class ExpireeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AppBloc>(
          create: (_) => AppBloc(), //TODO: suspect this is the issue because they used builder
          dispose: (_, appBloc) => appBloc.dispose(),
        ),
        ChangeNotifierProvider(create: (context) => CurrentUser()),
      ],
      child: MaterialApp(
          title: 'Expiree',
          theme: ThemeData(
            primaryColor: Colors.green,
            primarySwatch: Colors.green,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: Scaffold(
            body: RootPage(),
          )),
          );
  }
}
