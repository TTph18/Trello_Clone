import 'package:cloud_firestore/cloud_firestore.dart';

class Workspaces {

  final List<String> boardList;
  final String workspaceName;

  Workspaces({required this.boardList, required this.workspaceName});

  factory Workspaces.fromDocument(DocumentSnapshot document) {
    return Workspaces(
      boardList: document['boardList'],
      workspaceName: document['workspaceName']
    );
  }
}