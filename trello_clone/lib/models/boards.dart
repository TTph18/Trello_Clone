import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trello_clone/models/user.dart';

class Boards {

  final String boardID;
  final String boardName;
  final String createdBy;
  final String background;
  final bool isPersonal;
  final String workspaceID;
  final List<String> userList;
  final int listNumber;
  final int cardNumber;
  final String description;
  Boards({required this.boardID, required this.userList, required this.boardName, required this.createdBy, required this.background, required this.isPersonal, required this.workspaceID, required this.listNumber, required this.cardNumber, required this.description});

  factory Boards.fromDocument(DocumentSnapshot document) {
    return Boards(
        boardID: document.id,
        userList: document['userList'].cast<String>(),
        boardName: document['boardName'],
        createdBy: document['createdBy'],
        isPersonal: document['isPersonal'],
        background: document['background'],
        workspaceID: document['workspaceID'],
        listNumber : document['listNumber'],
        cardNumber : document['cardNumber'],
      description: document['description']
    );
  }
}

class Labels {
  final String labelID;
  final String color;
  final String labelName;

  Labels({required this.labelID, required this.color, required this.labelName});

  factory Labels.fromDocument(DocumentSnapshot document) {
    return Labels(
        labelID: document['labelID'],
        color: document['color'],
        labelName: document['labelName']
    );
  }
}