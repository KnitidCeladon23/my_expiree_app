import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseMethods {
  Future<void> addUserInfo(userData) async {
    Firestore.instance.collection("username").add(userData).catchError((e) {
      print(e.toString());
    });
  }

  getUserInfo(String email) async {
    return Firestore.instance
        .collection("username")
        .where("userEmail", isEqualTo: email)
        .getDocuments()
        .catchError((e) {
      print(e.toString());
    });
  }

  searchByName(String searchField) {
    return Firestore.instance
        .collection("username")
        .where('userName', isEqualTo: searchField)
        .getDocuments();
  }

  Future<bool> addChatRoom(chatRoom, chatRoomId, userName) async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    FirebaseUser _firebaseUser = await _auth.currentUser();
    String username = _firebaseUser.displayName;
    Firestore.instance
        .collection("chatRoom")
        .document(username)
        .collection("chatName")
        .document(chatRoomId)
        .setData(chatRoom)
        .catchError((e) {
      print(e);
    });

    Firestore.instance
        .collection("chatRoom")
        .document(userName)
        .collection("chatName")
        .document(chatRoomId)
        .setData(chatRoom)
        .catchError((e) {
      print(e);
    });
  }

  getChats(String chatRoomId) async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    FirebaseUser _firebaseUser = await _auth.currentUser();
    String username = _firebaseUser.displayName;
    return Firestore.instance
        .collection("chatRoom")
        .document(username)
        .collection("chatName")
        .document(chatRoomId)
        .collection("chats")
        .orderBy('time', descending: false)
        .snapshots();
  }

  Future<void> addMessage(String chatRoomId, chatMessageData, String otherUser) async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    FirebaseUser _firebaseUser = await _auth.currentUser();
    String username = _firebaseUser.displayName;
    Firestore.instance
        .collection("chatRoom")
        .document(username)
        .collection("chatName")
        .document(chatRoomId)
        .collection("chats")
        .add(chatMessageData)
        .catchError((e) {
      print(e.toString());
    });

    Firestore.instance
        .collection("chatRoom")
        .document(otherUser)
        .collection("chatName")
        .document(chatRoomId)
        .collection("chats")
        .add(chatMessageData)
        .catchError((e) {
      print(e.toString());
    });
  }

  getUserChats(String itIsMyName) async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    FirebaseUser _firebaseUser = await _auth.currentUser();
    String username = _firebaseUser.displayName;
    return await Firestore.instance
        .collection("chatRoom")
        .document(username)
        .collection("chatName")
        .where('username', arrayContains: itIsMyName)
        .snapshots();
  }
}
