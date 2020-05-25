import 'package:flutter/material.dart';

class InventoryItem extends StatelessWidget {
  final String item;
  InventoryItem(this.item);

  @override
  Widget build(BuildContext context) {
    return new Card(
      child: new Container(
        padding: EdgeInsets.all(8.0),
        child: new Row(
          children: <Widget>[
            new CircleAvatar(
              child: new Text(item[0]),
            ),
            new Padding(padding: EdgeInsets.only(right: 10.0)),
            new Text(
              item,
              style: TextStyle(fontSize: 20.0),
            )
          ],
        ),
      ),
    );
  }
}
