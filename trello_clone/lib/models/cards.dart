import 'package:cloud_firestore/cloud_firestore.dart';

import 'boards.dart';

class Cards {

  final String cardID;
  final String cardName;
  final String createdBy;
  final String description;
  final Timestamp startDate;
  final Timestamp dueDate;
  final List<String> assignedUser;
  final List<Labels> labels;
  final bool status;

  Cards({required this.cardID, required this.cardName, required this.createdBy, required this.description, required this.startDate, required this.dueDate, required this.assignedUser, required this.labels, required this.status});

  factory Cards.fromDocument(DocumentSnapshot document) {
    return Cards(
      cardID: document.id,
      cardName: document['cardName'],
      createdBy: document['createdBy'],
      labels: document['labels'],
      description: document['description'],
      dueDate: document['dueDate'],
      startDate: document['startDate'],
      assignedUser: document['assignedUser'],
      status: document['status']
    );
  }
}