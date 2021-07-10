import 'package:cloud_firestore/cloud_firestore.dart';

import 'boards.dart';

class Cards {

  final String cardID;
  final String boardID;
  final String listID;
  final String cardName;
  final String createdBy;
  final String description;
  final String startDate;
  final String startTime;
  final String dueDate;
  final String dueTime;
  final int checklistNumber;
  final List<String> assignedUser;
  final bool status; //true: finish | false: not finish

  Cards({required this.cardID, required this.cardName, required this.createdBy, required this.description, required this.startDate, required this.startTime, required this.dueDate, required this.dueTime, required this.assignedUser, required this.status,required this.listID, required this.boardID, required this.checklistNumber});

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
      dueTime: document['dueTime'],
      startTime: document['startTime'],
      assignedUser: document['assignedUser'].cast<String>(),
      status: document['status'],
      checklistNumber: document['checklistNumber'],
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
  final String title;
  final String checklistID;
  final List<String> content;
  final List<bool> status;

  CheckLists({required this.title, required this.checklistID, required this.content, required this.status});

  factory CheckLists.fromDocument(DocumentSnapshot document) {
    return CheckLists(
      title: document['title'],
      checklistID: document['checklistID'],
      content: document['content'].cast<String>(),
      status: document['status'].cast<bool>()
    );
  }
}
