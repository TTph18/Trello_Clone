import 'package:cloud_firestore/cloud_firestore.dart';

class Lists {
  final String listName;
  final String listID;
  final List<String> cardList;
  final int position;
  final int cardNumber;

  Lists({required this.listID, required this.listName, required this.position, required this.cardList, required this.cardNumber});

  factory Lists.fromDocument(DocumentSnapshot document) {
    return Lists(
      listName: document['listName'],
      position: document['position'],
      listID: document.id,
      cardNumber : document['cardNumber'],
      cardList: document['cardList'].cast<String>(),
    );
  }
}