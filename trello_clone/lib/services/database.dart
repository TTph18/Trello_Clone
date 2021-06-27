import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:trello_clone/models/user.dart';
import 'package:trello_clone/models/workspaces.dart';

class DatabaseService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Stream<String?> get onAuthStateChanged => _firebaseAuth.authStateChanges().map(
        (User? user) => user?.uid,
  );

  //Current User DB Service
  static Future<DocumentSnapshot> getUserData(context) async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    var snapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('userID', isEqualTo: uid)
        .get();
    return snapshot.docs.first;
  }

  static Future getUserWorkspaceList() async {
    List wpList = [];
    String uid = FirebaseAuth.instance.currentUser!.uid;
    var snapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('userID', isEqualTo: uid)
        .get();
    List wpID = snapshot.docs.first["workspaceList"];
    for(var temp in wpID) {
      var _snapshot = await FirebaseFirestore.instance
          .collection('workspaces')
          .where('workspaceID', isEqualTo: temp)
          .get();
        wpList.add(_snapshot.docs.first);
    }
    return wpList;
  }

  static Future getBoardList(String workspaceID) async {
    List brList = [];
    var snapshot = await FirebaseFirestore.instance
        .collection('workspaces')
        .where('workspaceID', isEqualTo: workspaceID)
        .get();
    List brID = snapshot.docs.first["boardList"];
    for(var temp in brID) {
      var _snapshot = await FirebaseFirestore.instance
          .collection('boards')
          .where('boardID', isEqualTo: temp)
          .get();
      brList.add(_snapshot.docs.first);
    }
    return brList;
  }

  Future<void> addBoard(String boardName, String workspaceID) async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    final docRef = await FirebaseFirestore.instance.collection('boards').add({
      'boardName': boardName,
      'createdBy': uid,
    });
    //add board uid to wp 
    var snapshot = await FirebaseFirestore.instance
        .collection('workspaces')
        .doc(workspaceID)
        .update({"boardList": FieldValue.arrayUnion([docRef.id])});
  }
  Future<void> addCard(String boardID, String listID, String cardName, String userID, DateTime startDate, DateTime endDate) async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    final docRef = await FirebaseFirestore.instance.collection('card').add({
      'cardName': cardName,
      'assignedUser': [userID],
      'startDate': Timestamp.fromDate(startDate),
      'endDate': Timestamp.fromDate(startDate)
    });
    //add board uid to wp
    var snapshot = await FirebaseFirestore.instance
        .collection('boards')
        .doc(boardID)
        .collection('lists')
        .doc(listID)
        .update({"cardList": FieldValue.arrayUnion([docRef.id])});
  }
}