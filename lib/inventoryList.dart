import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'inventoryItem.dart';

class InventoryList extends StatefulWidget {
  @override
  _InventoryListState createState() => _InventoryListState();
}

class _InventoryListState extends State<InventoryList> {
  final GlobalKey<FormState> _inventoryKey = GlobalKey<FormState>();
  List<String> items = List();
  String newItem;

  @override
  void initState() {
    super.initState();
  }

  TextStyle style = GoogleFonts.chelseaMarket(
    fontSize: 20,
  );

  DateTime _dateTime;

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
                content: TextFormField(
                  validator: (input) {
                          if (input == null || input.isEmpty) {
                            return "Please fill in the item";
                          }
                          // (to be implemented) if item is already existing, prompt the users to check
                          else return null;
                        },
                  onChanged: (String input) {
                  newItem = input;
                }),
                actions: <Widget>[
                  RaisedButton(
                      onPressed: () {
                        _selectExpiryDate(context);
                      },
                      child: Text(
                        "Enter expiry date",)),
                  RaisedButton(
                      onPressed: () async {
                        if (_inventoryKey.currentState.validate()) {
                        _addItemToList(newItem);
                        }
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
        child: Form(
          key : _inventoryKey,
          child: ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          return InventoryItem(this.items[index], this._dateTime.toString());
        },
        itemCount: this.items.length,
      ),)),
      floatingActionButton: addItemButton,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      );
  }

  void _addItemToList(String newItem) {
    if (_inventoryKey.currentState.validate()) {
    setState(() {
      items.add(newItem);
    });
    //print(newItem);
    print(items);
    Navigator.of(context).pop();
    }
  }

  Future<Null> _selectExpiryDate(BuildContext context) async {
    final DateTime pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (pickedDate != null && pickedDate != _dateTime)
      setState(() {
        _dateTime = pickedDate;
      });
    print(_dateTime.toString());
  }
}
