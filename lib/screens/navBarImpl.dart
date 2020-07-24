import 'package:expiree_app/calendar/calendar.dart';
import 'package:expiree_app/screens/inventoryListFirebase.dart';
import 'package:expiree_app/screens/reminderPage.dart';
import 'package:flutter/material.dart';
import 'package:expiree_app/screens/expireeHome.dart';
import 'package:provider/provider.dart';
import 'package:expiree_app/notification/app_bloc.dart';
import 'package:expiree_app/wall/postPage.dart';

class NavBarImpl extends StatefulWidget {
  final int refPage;
  NavBarImpl({Key key, this.refPage}) : super(key: key);

  @override
  _NavBarImplState createState() => _NavBarImplState();
}

class _NavBarImplState extends State<NavBarImpl> {
  int _selectedPage = 0;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () async {
      final appBloc = Provider.of<AppBloc>(context, listen: false);
      await appBloc.init();
    });
    _selectedPage = widget.refPage != null ? widget.refPage : 0;
  }

  final _pageOptions = [
    ExpireeHome(),
    Calendar(),
    PostPage(),
    InventoryListFirebase(),
    ReminderPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      color: Colors.green,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: _pageOptions[_selectedPage],
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedPage,
          onTap: (int index) {
            setState(() {
              _selectedPage = index;
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text('Home'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today),
              title: Text('Calendar'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.create),
              title: Text('Wall'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add_circle_outline),
              title: Text('Inventory'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.timer),
              title: Text('Reminders'),
            ),
          ],
          selectedItemColor: Colors.amber[800],
        ),
      ),
    );
  }
}
