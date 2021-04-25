import 'package:cloud_firestore/cloud_firestore.dart';

class Lists {

  final List<String> cardList;
  final String listName;

  Lists({required this.cardList, required this.listName});

  factory Lists.fromDocument(DocumentSnapshot document) {
    return Lists(
        cardList: document['cardList'],
        listName: document['listName'],
    );
  }
}