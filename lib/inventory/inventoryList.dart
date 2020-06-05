import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:expiree_app/inventory/inventoryItem.dart';

class InventoryList extends StatefulWidget {
  @override
  _InventoryListState createState() => _InventoryListState();
}

class _InventoryListState extends State<InventoryList> {
  //List<String> items = List();
  List<InventoryItem> items = List(); //new
  //list will store InventoryItem objects instead,
  //which encapsulates name of item and their expiry dates in string
  String newItem;

  @override
  void initState() {
    super.initState();
  }

  TextStyle style = GoogleFonts.chelseaMarket(
    fontSize: 20,
  );

  DateTime _dateTime;

  Future<Null> _selectExpiryDate(BuildContext context) async {
    final DateTime pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        //firstDate: DateTime(2015, 8),
        firstDate: DateTime.now(), //new
        //would make sense to set the lower limit to the current date
        //because users won't add expired food to their inventory
        lastDate: DateTime(2101));
    if (pickedDate != null && pickedDate != _dateTime)
      setState(() {
        _dateTime = pickedDate;
      });
    print(_dateTime.toString());
  }

  //void _addItemToList(String newItem) {
  void _addItemToList(String newItem, String dateTimeString) {
    setState(() {
      //items.add(newItem);
      items.add(InventoryItem(newItem, dateTimeString)); //new
      //adding InventoryItem objects into the list
    });
    //print(newItem);
    //print(items);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {

    final addItemButton = FloatingActionButton(
      backgroundColor: Colors.green,
      onPressed: () {
        newItem = null; //new
        _dateTime = null; //new
        //initialising values to zero, otherwise
        //the app will still have values from the
        //previous entry, this means that if a new blank entry
        //was made, it would end up copying the previous item on the list
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
                      onPressed: () {
                        //new
                        if (newItem != null && _dateTime != null) {
                          //_addItemToList(newItem);
                          _addItemToList(newItem, _dateTime.toString()); //new
                        } else {
                          Navigator.of(context).pop(); //new
                        }
                        //if there are no inputs, the app will simply return to the
                        //inventory list
                      },
                      child: Text("Confirm new item"))
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
          child: ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          //return InventoryItem(this.items[index], this._dateTime.toString());
          return this.items[index]; //new
          //will return the inventory item
        },
        itemCount: this.items.length,
      ),)),
      floatingActionButton: addItemButton,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      );
  }
}