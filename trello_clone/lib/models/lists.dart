import 'package:cloud_firestore/cloud_firestore.dart';

class Lists {
  final String listName;

  Lists({ required this.listName});

  factory Lists.fromDocument(DocumentSnapshot document) {
    return Lists(
        listName: document['listName'],
    );
  }
}