import 'package:cloud_firestore/cloud_firestore.dart';

import 'boards.dart';

class Cards {

  final String cardID;
  final String boardID;
  final String listID;
  final String cardName;
  final String createdBy;
  final String description;
  final Timestamp startDate;
  final Timestamp dueDate;
  final List<String> assignedUser;
  final bool status; //true: not due | false: is due

  Cards({required this.cardID, required this.cardName, required this.createdBy, required this.description, required this.startDate, required this.dueDate, required this.assignedUser, required this.status,required this.listID, required this.boardID});

  factory Cards.fromDocument(DocumentSnapshot document) {
    return Cards(
      cardID: document.id,
      cardName: document['cardName'],
      createdBy: document['createdBy'],
      listID: document['listID'],
      boardID: document['boardID'],
      description: document['description'],
      dueDate: document['dueDate'],
      startDate: document['startDate'],
      assignedUser: document['assignedUser'],
      status: document['status'],
    );
  }
}
class Comments {

  final String userID;
  final String userName;
  final Timestamp commentDate;
  final String content;

  Comments({required this.userID, required this.userName, required this.commentDate, required this.content});

  factory Comments.fromDocument(DocumentSnapshot document) {
    return Comments(
        userID: document['userID'],
        userName: document['userName'],
        commentDate: document['commentDate'],
        content: document['content'],
    );
  }
}

class CheckLists {

  final String content;
  final bool status;

  CheckLists({required this.content, required this.status});

  factory CheckLists.fromDocument(DocumentSnapshot document) {
    return CheckLists(
      content: document['content'],
      status: document['status'],
    );
  }
}