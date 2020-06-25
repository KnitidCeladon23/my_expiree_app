import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
//import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:expiree_app/notification/notification_data.dart';
import 'package:expiree_app/notification/app_bloc.dart';
import 'package:expiree_app/notification/notification_bloc.dart';
//import 'package:water_reminder_app/src/widgets/buttons/custom_wide_flat_button.dart';
import 'package:expiree_app/notification/custom_input_field.dart';

class CreateNotificationPage extends StatefulWidget {
  @override
  _CreateNotificationPageState createState() => _CreateNotificationPageState();
}

class _CreateNotificationPageState extends State<CreateNotificationPage> {
  DateTime _reminderDate;
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool dateSelected = false;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final notificationBloc = Provider.of<AppBloc>(context).notificationBloc;

    final createReminder = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Colors.brown,
      child: MaterialButton(
        minWidth: 170,
        padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
        onPressed: () {
          if (dateSelected == false) {
            setState(() {
              _reminderDate = new DateTime.now().add(new Duration(
                days: 3,
              ));
            });
          }
          createNotification(notificationBloc);
          setState(() {
            dateSelected = false;
          });
        },
        child: Text(
          "Create Reminder",
          textAlign: TextAlign.center,
          style: GoogleFonts.permanentMarker(fontSize: 20, color: Colors.white),
          //color: Colors.white, fontWeight: FontWeight.bold)
        ),
      ),
    );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Create Reminder',
          style: GoogleFonts.permanentMarker(fontSize: 30, color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    CustomInputField(
                      controller: _titleController,
                      hintText: 'Title',
                      inputType: TextInputType.text,
                      autoFocus: true,
                    ),
                    SizedBox(height: 12),
                    CustomInputField(
                      controller: _descriptionController,
                      hintText: 'Description',
                      inputType: TextInputType.text,
                      autoFocus: true,
                    ),
                    SizedBox(height: 12),
                    OutlineButton(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 12),
                      onPressed: () {
                        selectDate(context);
                      },
                      child: Text('Select Date'),
                    ),
                    SizedBox(height: 30),
                    Text(
                        '(If no date is selected, you will be reminded 3 days later!)',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.roboto(
                            fontSize: 20, color: Colors.brown),
                      ),
                  ],
                ),
              ),
            ),
          ),
          createReminder,
        ],
      ),
    );
  }

  Future<Null> selectDate(BuildContext context) async {
    final DateTime pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2101));
    final initTime = new TimeOfDay(
      hour: 0,
      minute: 0,
    );
    final TimeOfDay pickedTime =
        await showTimePicker(context: context, initialTime: initTime);

    if (pickedDate != null && pickedTime != null)
      setState(() {
        _reminderDate = DateTime(pickedDate.year, pickedDate.month,
            pickedDate.day, pickedTime.hour, pickedTime.minute);
      });
    else if (pickedDate != null && pickedTime == null)
      setState(() {
        _reminderDate = DateTime(pickedDate.year, pickedDate.month,
            pickedDate.day, initTime.hour, initTime.minute);
      });
    else
      setState(() {
        _reminderDate = new DateTime.now().add(new Duration(
          days: 3,
        ));
      });
    print(_reminderDate);
    setState(() {
      dateSelected = true;
    });
  }

  void createNotification(NotificationBloc notificationBloc) {
    if (_formKey.currentState.validate()) {
      final title = _titleController.text;
      final description = _descriptionController.text;
      String _reminderString = _reminderDate.toString();
      print(_reminderString);
      final notificationData =
          NotificationData(title, description, _reminderString);
      notificationBloc.addNotification(notificationData);
      Navigator.of(context).pop();
    }
  }
}
