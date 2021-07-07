import 'package:cloud_firestore/cloud_firestore.dart';

class Lists {
  final String listName;
  final String listID;

  Lists({required this.listID, required this.listName});

  factory Lists.fromDocument(DocumentSnapshot document) {
    return Lists(
      listName: document['listName'],
      listID: document.id,
    );
  }
}