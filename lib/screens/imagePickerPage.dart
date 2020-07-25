import 'dart:io';
import 'package:expiree_app/screens/firebaseStorage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerPage extends StatefulWidget {
  final int pageRef;
  final String userID;
  final String itemID;
  final File image;
  ImagePickerPage({Key key, this.userID, this.itemID, this.pageRef, this.image})
      : super(key: key);
  @override
  _ImagePickerPageState createState() => _ImagePickerPageState();
}

class _ImagePickerPageState extends State<ImagePickerPage> {
  /// Active image file
  File _imageFile;

  @override
  void initState() {
    super.initState();
    _imageFile = widget.image;
  }

  /// Cropper plugin
  Future<void> _cropImage() async {
    File cropped = await ImageCropper.cropImage(
        sourcePath: _imageFile.path,
        // ratioX: 1.0,
        // ratioY: 1.0,
        // maxWidth: 512,
        // maxHeight: 512,
        toolbarColor: Colors.purple,
        toolbarWidgetColor: Colors.white,
        toolbarTitle: 'Crop It');

    setState(() {
      _imageFile = cropped ?? _imageFile;
    });
  }

  /// Select an image via gallery or camera
  Future<void> _pickImage(ImageSource source) async {
    File selected = await ImagePicker.pickImage(source: source);

    setState(() {
      _imageFile = selected;
    });
  }

  /// Remove image
  void _clear() {
    setState(() => _imageFile = null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Select an image from the camera or gallery

      appBar: AppBar(
        title: Text('Preview Image'),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // IconButton(
            //   icon: Icon(Icons.photo_camera),
            //   onPressed: () => _pickImage(ImageSource.camera),
            // ),
            RaisedButton(
              onPressed: () => _pickImage(ImageSource.camera),
              child: Text("Retake Photo"),
            ),
            Padding(padding: EdgeInsets.only(right: 10.0)),
            RaisedButton(
              onPressed: () => _pickImage(ImageSource.gallery),
              child: Text("Repick from Gallery"),
            )
          ],
        ),
      ),

      // Preview the image and crop it
      body: ListView(
        children: <Widget>[
          if (_imageFile != null) ...[
            Image.file(_imageFile),
            Row(
              children: <Widget>[
                FlatButton(
                  child: Icon(Icons.crop),
                  onPressed: _cropImage,
                ),
                FlatButton(
                  child: Icon(Icons.refresh),
                  onPressed: _clear,
                ),
              ],
            ),
            FirebaseStoragePage(
              file: _imageFile,
              userID: widget.userID,
              itemID: widget.itemID,
              pageRef: widget.pageRef,
            )
          ]
        ],
      ),
    );
  }
}
