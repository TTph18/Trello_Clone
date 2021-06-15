import 'package:cloud_firestore/cloud_firestore.dart';

class Workspaces {

  final List<String> boardList;
  final String workspaceName;
  final String workspaceID;

  Workspaces({required this.boardList, required this.workspaceName, required this.workspaceID});

  factory Workspaces.fromDocument(DocumentSnapshot document) {
    return Workspaces(
      boardList: document['boardList'],
      workspaceName: document['workspaceName'],
      workspaceID: document.id
    );
  }
}