import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:expiree_app/wall/addPost.dart';
import 'package:expiree_app/states/currentUser.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:expiree_app/helper/helperfunctions.dart';

class PostPage extends StatefulWidget {
  @override
  _PostPageState createState() {
    return _PostPageState();
  }
}

class _PostPageState extends State<PostPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Wall",
          style: GoogleFonts.permanentMarker(
            fontSize: 30,
          ),
        ),
        ),
      body: _buildBody(context),
      floatingActionButton: AddNote(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildBody(BuildContext context) {
    CurrentUser _currentUser = Provider.of<CurrentUser>(context, listen: false);
    String _uid = _currentUser.getUid;
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('wall').orderBy("timestamp", descending: true).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();

        return _buildList(context, snapshot.data.documents);
      },
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {

    return ListView.builder(
      padding: const EdgeInsets.only(top: 20.0),
      itemBuilder: (context, index) => _buildListItem(context, snapshot[index]),
      itemCount: snapshot.length,
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    final note = Note.fromSnapshot(data);
    CurrentUser _currentUser = Provider.of<CurrentUser>(context, listen: false);
    String _username = _currentUser.getUsername;
    return Padding(
      key: ValueKey(note.message),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          color: new Color(data["color"]),
          // color: Colors.primaries[Random().nextInt(Colors.primaries.length)],
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0,3),
            )
          ],
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: ListTile(
          title: Row( 
            children: 
            <Widget> [Text(_username, style: TextStyle(fontSize:15)),
            Text(": ", style: TextStyle(fontSize:15)),
            Text(note.title, style: TextStyle(fontSize:15))
          ]),
          subtitle: Text(note.message, style:TextStyle(fontSize:15)),
        ),
      ),
    );
  }
}

class Note {
  final String title;
  final String message;
  final DocumentReference reference;

  Note.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['message'] != null),
        assert(map['title'] != null),
        title = map['title'],
        message = map['message'];

  Note.fromSnapshot(DocumentSnapshot snapshot) 
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  // @override
  // String toString() => "Note<$name:$numberOfAs>";
}

