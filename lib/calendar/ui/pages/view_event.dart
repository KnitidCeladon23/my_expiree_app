import 'package:expiree_app/notification/createNotifPage.dart';
import 'package:expiree_app/screens/urlLauncher.dart';
import 'package:flutter/material.dart';
import '../../model/event.dart';

class EventDetailsPage extends StatelessWidget {
  final EventModel event;

  const EventDetailsPage({Key key, this.event}) : super(key: key);

  Widget findRecipeButton(String foodItem) {
    return RaisedButton(
      color: Colors.brown[400],
      padding: EdgeInsets.all(8.0),
      onPressed: () {},
      child: Text(
        'Recipes',
        style: TextStyle(
            fontSize: 15.0, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Event details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              event.item,
              style: Theme.of(context).textTheme.headline4,
            ),
            SizedBox(height: 20.0),
            Text(event.description),
            SizedBox(height: 20.0),
            RaisedButton(
              color: Colors.brown[400],
              padding: EdgeInsets.all(8.0),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => URLLauncher(
                            title: "Recipe for " + event.item,
                            foodItem: event.item)));
              },
              child: Text(
                'Recipes',
                style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
            SizedBox(height: 20.0),
            RaisedButton(
              color: Colors.grey[700],
              padding: EdgeInsets.all(8.0),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => CreateNotificationPage(),
                  ),
                );
              },
              child: Text(
                'Remind me!',
                style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
