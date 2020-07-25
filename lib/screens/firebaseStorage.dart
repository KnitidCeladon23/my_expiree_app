import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expiree_app/screens/navBarImpl.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/widgets.dart';

class FirebaseStoragePage extends StatefulWidget {
  final File file;
  final String userID;
  final String itemID;
  final int pageRef;
  FirebaseStoragePage(
      {Key key, this.file, this.userID, this.itemID, this.pageRef})
      : super(key: key);
  @override
  _FirebaseStoragePageState createState() => _FirebaseStoragePageState();
}

class _FirebaseStoragePageState extends State<FirebaseStoragePage> {
  final FirebaseStorage _storage =
      FirebaseStorage(storageBucket: 'gs://expiree-login-51433.appspot.com/');

  StorageUploadTask _uploadTask;
  Firestore databaseReference = Firestore.instance;

  /// Starts an upload task
  void _startUpload() async {
    /// Unique file name for the file
    String filePath = 'images/${widget.userID}/${widget.itemID}.png';

    setState(() {
      _uploadTask = _storage.ref().child(filePath).putFile(widget.file);
    });

    StorageTaskSnapshot snapshot = await _uploadTask.onComplete;
    if (snapshot.error == null) {
      final String downloadUrl = await snapshot.ref.getDownloadURL();
      var itemReference = databaseReference
          .collection('inventoryLists')
          .document(widget.userID)
          .collection("indivInventory")
          .where("id", isEqualTo: widget.itemID)
          .getDocuments()
          .then((value) {
        value.documents.forEach((result) {
          result.reference.setData({"url": downloadUrl}, merge: true);
        });
      });

      Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    NavBarImpl(refPage: widget.pageRef)));
      // await Firestore.instance
      //     .collection('inventoryLists')
      //     .document(widget.userID)
      //     .collection("indivInventory")
      //     .document(widget.itemID)
      //     .setData({"url": downloadUrl}, merge: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_uploadTask != null) {
      /// Manage the task state and event subscription with a StreamBuilder
      return StreamBuilder<StorageTaskEvent>(
          stream: _uploadTask.events,
          builder: (_, snapshot) {
            var event = snapshot?.data?.snapshot;

            double progressPercent = event != null
                ? event.bytesTransferred / event.totalByteCount
                : 0;

            return Column(
              children: [
                // if (_uploadTask.isComplete)
                //   RaisedButton(
                //       onPressed: () {
                //         Navigator.push(
                //             context,
                //             MaterialPageRoute(
                //                 builder: (context) =>
                //                     NavBarImpl(refPage: widget.pageRef)));
                //       },
                //       child: Text("Return")),

                if (_uploadTask.isPaused)
                  FlatButton(
                    child: Icon(Icons.play_arrow),
                    onPressed: _uploadTask.resume,
                  ),

                if (_uploadTask.isInProgress)
                  FlatButton(
                    child: Icon(Icons.pause),
                    onPressed: _uploadTask.pause,
                  ),

                // Progress bar
                LinearProgressIndicator(value: progressPercent),
                Text('${(progressPercent * 100).toStringAsFixed(2)} % '),
              ],
            );
          });
    } else {
      // Allows user to decide when to start the upload
      return FlatButton.icon(
        label: Text('Use this image'),
        icon: Icon(Icons.cloud_upload),
        onPressed: _startUpload,
      );
    }
  }
}
