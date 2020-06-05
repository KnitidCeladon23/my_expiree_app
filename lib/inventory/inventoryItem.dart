import 'package:flutter/material.dart';

class InventoryItem extends StatelessWidget {
  final String item;
  final String dateTime;
  InventoryItem(this.item, this.dateTime);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: EdgeInsets.all(8.0),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  CircleAvatar(
                    child: Text(item[0]),
                  ),
                  Padding(padding: EdgeInsets.only(right: 10.0)),
                  Text(
                    item,
                    style: TextStyle(fontSize: 20.0),
                  )
                ],
              ),
              SizedBox(height: 10),
              Text(
                dateTime.substring(0, 10),
                style: TextStyle(fontSize: 10.0),
              ),
            ]),
      ),
    );
  }

  @override
  String toString({DiagnosticLevel minLevel: DiagnosticLevel.info}) {
    return "[" + item + ", " + dateTime + "]";
  }
}