import 'package:cloud_firestore/cloud_firestore.dart';

class Lists {
  final String listName;
  final String listID;
  final List<String> cardList;
  final int position;

  Lists({required this.listID, required this.listName, required this.position, required this.cardList});

  factory Lists.fromDocument(DocumentSnapshot document) {
    return Lists(
      listName: document['listName'],
      position: document['position'],
      listID: document.id,
      cardList: document['cardList'].cast<String>(),
    );
  }
}