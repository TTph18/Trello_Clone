import 'package:cloud_firestore/cloud_firestore.dart';

class Workspaces {

  final List<String> boardList;
  final String workspaceName;
  final String workspaceID;
  final List<String> userList;

  Workspaces({required this.boardList, required this.userList, required this.workspaceName, required this.workspaceID});

  factory Workspaces.fromDocument(DocumentSnapshot document) {
    return Workspaces(
      boardList: document['boardList'].cast<String>(),
      workspaceName: document['workspaceName'],
      workspaceID: document.id,
      userList: document['userList'].cast<String>(),
    );
  }
}