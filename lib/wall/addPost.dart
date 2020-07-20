import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:random_color/random_color.dart';
import 'package:expiree_app/states/currentUser.dart';
import 'package:provider/provider.dart';

class AddNote extends StatefulWidget {
  AddNote({Key key}) : super(key: key);

  @override
  _AddNoteState createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  bool showFab = true;
  PersistentBottomSheetController bottomSheetController;

  @override
  Widget build(BuildContext context) {
    return showFab
        ? FloatingActionButton(
            child: Icon(Icons.add),
            mini: true,
            backgroundColor: Colors.green,
            onPressed: () {
              var bottomSheetController = showBottomSheet(
                  context: context, builder: (context) => BottomSheetWidget());
              showFloatingActionButton(false);
              bottomSheetController.closed.then((value) {
                showFloatingActionButton(true);
              });
            },
          )
        : Container();
  }

  void showFloatingActionButton(bool value) {
    setState(() {
      showFab = value;
    });
  }
}

//widget inside the pop-up
class BottomSheetWidget extends StatefulWidget {
  @override
  _BottomSheetWidgetState createState() => _BottomSheetWidgetState();
}

class _BottomSheetWidgetState extends State<BottomSheetWidget> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Container(
      margin: const EdgeInsets.only(top: 5, left: 15, right: 15),
      height: 400,
      child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: 400,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 10,
                        color: Colors.grey[300],
                        spreadRadius: 5)
                  ]),
              child: Column(children: [UserMessage()]),
            )
          ]),
    ));
  }
}

class UserMessage extends StatefulWidget {
  @override
  _UserMessageState createState() => _UserMessageState();
}

// Define a corresponding State class.
// This class holds the data related to the Form.
class _UserMessageState extends State<UserMessage> {
  final firestoreInstance = Firestore.instance;
  bool isButtonEnabled = false;
  // Create a text controller and use it to retrieve the current value
  // of the TextField.
  final messageController = TextEditingController();
  final titleController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    messageController.dispose();
    titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isEmpty() {
      setState(() {
        if ((messageController.text.isEmpty) ||
            (titleController.text.isEmpty)) {
          isButtonEnabled = false;
        } else {
          isButtonEnabled = true;
        }
      });
      return isButtonEnabled;
    }

    CurrentUser _currentUser = Provider.of<CurrentUser>(context, listen: false);
    String _uid = _currentUser.getUid;

    return Column(children: <Widget>[
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Spacer(),
          Column(
            children: <Widget>[
              FlatButton(
                  onPressed: isButtonEnabled
                      ? () {
                          firestoreInstance
                              .collection("wall")
                              .add({
                            "message": messageController.text,
                            "title": titleController.text,
                            "color": RandomColor()
                                .randomColor(
                                    colorBrightness: ColorBrightness.light)
                                .value,
                            "timestamp": FieldValue.serverTimestamp()
                          });
                          Navigator.of(context).pop();
                        }
                      : null,
                  child: Icon(Icons.check, size: 40)),
              Text('Post')
            ],
          ),
        ],
      ),
      Container(
          height: 80,
          alignment: Alignment.topCenter,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
              color: Colors.grey[300], borderRadius: BorderRadius.circular(10)),
          child: TextField(
              controller: titleController,
              onChanged: (val) {
                isEmpty();
              },
              textInputAction: TextInputAction.newline,
              maxLines: null,
              autocorrect: true,
              showCursor: true,
              maxLengthEnforced: true,
              maxLength: 50,
              textAlign: TextAlign.start,
              decoration: InputDecoration.collapsed(
                hintText: 'Title',
              ))),
      Container(
          height: 150,
          alignment: Alignment.topCenter,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
              color: Colors.grey[300], borderRadius: BorderRadius.circular(10)),
          child: TextField(
              controller: messageController,
              onChanged: (val) {
                isEmpty();
              },
              textInputAction: TextInputAction.newline,
              maxLines: null,
              autocorrect: true,
              showCursor: true,
              maxLengthEnforced: true,
              maxLength: 300,
              textAlign: TextAlign.start,
              decoration: InputDecoration.collapsed(
                hintText: 'Details...',
              ))),
      // ColorPicker()
    ]);
  }
}

class ColorPicker extends StatefulWidget {
  _ColorPickerState createState() => _ColorPickerState();
}

class _ColorPickerState extends State<ColorPicker> {
  // Use temp variable to only update color when press dialog 'submit' button
  ColorSwatch _tempMainColor;

  ColorSwatch _mainColor = Colors.brown;

  void _openDialog(String title, Widget content) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(6.0),
          title: Text(title),
          content: content,
          actions: [
            FlatButton(
              child: Text('CANCEL'),
              onPressed: Navigator.of(context).pop,
            ),
            FlatButton(
              child: Text('SUBMIT'),
              onPressed: () {
                Navigator.of(context).pop();
                setState(() => _mainColor = _tempMainColor);
              },
            ),
          ],
        );
      },
    );
  }

  void _openMainColorPicker() async {
    _openDialog(
      "Select Color",
      MaterialColorPicker(
        selectedColor: _mainColor,
        allowShades: false,
        onMainColorChange: (color) => setState(() => _tempMainColor = color),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 62.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OutlineButton(
              onPressed: _openMainColorPicker,
              child: const Text('Select Color'),
            ),
            SizedBox(width: 20),
            CircleAvatar(
              backgroundColor: _mainColor,
              radius: 25.0,
            ),
            const SizedBox(width: 16.0),
          ],
        ),
      ],
    );
  }
}
