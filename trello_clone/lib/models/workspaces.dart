import 'package:cloud_firestore/cloud_firestore.dart';

class Workspaces {

  final List<String> boardList;
  final List<String> userList;
  final String workspaceName;

  Workspaces({required this.boardList, required this.userList, required this.workspaceName});

  factory Workspaces.fromDocument(DocumentSnapshot document) {
    return Workspaces(
      boardList: document['boardList'],
      userList: document['userList'],
      workspaceName: document['workspaceName']
    );
  }
}