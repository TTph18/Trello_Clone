import 'package:cloud_firestore/cloud_firestore.dart';

class Users {

  final String userID;
  final String userName;
  final String profileName;
  final String email;
  final String avatar;

  Users({required this.userID, required this.userName, required this.profileName, required this.email, required this.avatar});

  factory Users.fromDocument(DocumentSnapshot document) {
    return Users(
      email: document['email'],
      userName: document['userName'],
      profileName: document['profileName'],
      userID: document.id,
      avatar: document['avatar'],
    );
  }
}