import 'package:cloud_firestore/cloud_firestore.dart';

class Boards {

  final String boardID;
  final String boardName;
  final String createdBy;
  final String background;
  final List<String> listList;
  final List<Labels> label;

  Boards({required this.boardID, required this.boardName, required this.createdBy, required this.background, required this.listList, required this.label});

  factory Boards.fromDocument(DocumentSnapshot document) {
    return Boards(
        boardID: document.id,
        boardName: document['boardName'],
        createdBy: document['createdBy'],
        background: document['background'],
        listList: document['listList'],
        label: document['label']
    );
  }
}

class Labels {

  final String color;
  final String labelName;

  Labels({required this.color, required this.labelName});

  factory Labels.fromDocument(DocumentSnapshot document) {
    return Labels(
        color: document['color'],
        labelName: document['labelName']
    );
  }
}