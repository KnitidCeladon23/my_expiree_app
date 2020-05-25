import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'inventoryItem.dart';

class InventoryList extends StatefulWidget {
  @override
  _InventoryListState createState() => _InventoryListState();
}

class _InventoryListState extends State<InventoryList> {
  List<String> items = List();
  String newItem;

  @override
  void initState() {
    super.initState();
    items.add('Hello');
    items.add('World');
  }

  TextStyle style = GoogleFonts.chelseaMarket(
    fontSize: 20,
  );

  @override
  Widget build(BuildContext context) {
    final addItemButton = FloatingActionButton(
      backgroundColor: Colors.green,
      onPressed: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Add Item"),
                content: TextField(onChanged: (String input) {
                  newItem = input;
                }),
                actions: <Widget>[
                  RaisedButton(
                      onPressed: () {
                        setState(() {
                          items.add(newItem);
                        });
                        print(newItem);
                        print(items);
                        Navigator.of(context).pop();
                      },
                      child: Text("Add"))
                ],
              );
            });
      },
      child: Icon(Icons.add, color: Colors.white),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Inventory',
          style: style,
        ),
      ),
      body: Container(
          child: ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          return InventoryItem(this.items[index]);
        },
        itemCount: this.items.length,
      )),
      floatingActionButton: addItemButton,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
