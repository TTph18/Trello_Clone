import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trello_clone/models/workspaces.dart';

class Users {

  final String userID;
  final String userName;
  final String profileName;
  final String email;
  final String avatar;
  final List<String> workspaceList;

  Users({required this.userID, required this.userName, required this.profileName, required this.email, required this.avatar, required this.workspaceList});

  factory Users.fromDocument(DocumentSnapshot document) {
    return Users(
      email: document['email'],
      userName: document['userName'],
      profileName: document['profileName'],
      userID: document.id,
      avatar: document['avatar'],
      workspaceList: document['workspaceList'].cast<String>()
    );
  }
}