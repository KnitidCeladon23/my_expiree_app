import 'package:expiree_app/helper/constants.dart';
import 'package:expiree_app/helper/helperfunctions.dart';
import 'package:expiree_app/database.dart';
import 'package:expiree_app/chats/chat.dart';
import 'package:expiree_app/chats/search.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:expiree_app/states/currentUser.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  Stream chatRooms;



  Widget chatRoomsList() {
    CurrentUser _currentUser = Provider.of<CurrentUser>(context, listen: false);
    print("hi the current user name is: ${_currentUser.getUsername}");
    return StreamBuilder(
      stream: chatRooms,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.documents.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return ChatRoomsTile(
                    userName: snapshot.data.documents[index].data['chatRoomId']
                        .toString()
                        .replaceAll("_", "")
                        .replaceAll(_currentUser.getUsername, ""),
                        //.replaceAll(Constants.myName, ""),
                    chatRoomId:
                        snapshot.data.documents[index].data["chatRoomId"],
                  );
                })
            : Container();
      },
    );
  }

  @override
  void initState() {
    getUserInfogetChats();
    super.initState();
    CurrentUser _currentUser = Provider.of<CurrentUser>(context, listen: false);
    print("current username is: ${_currentUser.getUsername}");
    print("Constants.myName is: ${Constants.myName}");
    print("hello");
  }

  getUserInfogetChats() async {
    Constants.myName = await HelperFunctions.getUserNameSharedPreference();
    FirebaseAuth _auth = FirebaseAuth.instance;
    FirebaseUser _firebaseUser = await _auth.currentUser();
    String username = _firebaseUser.displayName;
    DatabaseMethods().getUserChats(username).then((snapshots) {
      setState(() {
        chatRooms = snapshots;
        print(
            "we got the data + ${chatRooms.toString()} this is name  ${Constants.myName}");
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Chats",
          style: GoogleFonts.permanentMarker(
            fontSize: 30,
          ),
        ),
      ),
      body: Container(
        child: chatRoomsList(),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.search),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Search()));
        },
      ),
    );
  }
}

class ChatRoomsTile extends StatelessWidget {
  final String userName;
  final String chatRoomId;

  ChatRoomsTile({this.userName, @required this.chatRoomId});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Chat(
                      otherUser: userName,
                      chatRoomId: chatRoomId,
                    )));
      },
      child: Container(
        color: Colors.grey[300],
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Row(
          children: [
            CircleAvatar(
                child: Text(userName.substring(0, 1).toUpperCase()),
                // backgroundColor: RandomColor()
                //     .randomColor(colorBrightness: ColorBrightness.primary)
                    backgroundColor: Colors.brown,),
            SizedBox(
              width: 12,
            ),
            Text(userName,
                textAlign: TextAlign.start,
                style: GoogleFonts.roboto(fontSize: 25),
                // style: TextStyle(
                //     color: Colors.white,
                //     fontSize: 16,
                //     fontFamily: 'OverpassRegular',
                //     fontWeight: FontWeight.w300)
                    )
          ],
        ),
      ),
    );
  }
}
