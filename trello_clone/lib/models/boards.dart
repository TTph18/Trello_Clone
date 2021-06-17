import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trello_clone/models/user.dart';

class Boards {

  final String boardID;
  final String boardName;
  final String createdBy;
  final String background;
  final List<String> listList;
  final List<String> labelList;
  final List<String> userList;

  Boards({required this.boardID, required this.userList, required this.boardName, required this.createdBy, required this.background, required this.listList, required this.labelList});

  factory Boards.fromDocument(DocumentSnapshot document) {
    return Boards(
        boardID: document.id,
        userList: document['userList'].cast<String>(),
        boardName: document['boardName'],
        createdBy: document['createdBy'],
        background: document['background'],
        listList: document['listList'].cast<String>(),
        labelList: document['labelList'].cast<String>()
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