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
  static Future<DocumentSnapshot> getCurrentUserData() async {
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
    String uid = FirebaseAuth.instance.currentUser!.uid;
    List brList = [];
    var snapshot = await FirebaseFirestore.instance
        .collection('workspaces')
        .where('workspaceID', isEqualTo: workspaceID)
        .get();
    List brID = snapshot.docs.first["boardList"];
    if (brID == []) { return brList; }
    for(var temp in brID) {
      var _snapshot = await FirebaseFirestore.instance
          .collection('boards')
          .where('boardID', isEqualTo: temp)
          .where('userList', arrayContains: uid)
          .get();
      brList.add(_snapshot.docs.first);
    }
    return brList;
  }

  static Future getlistList(String boardID) async {
    var snapshot = await FirebaseFirestore.instance
        .collection('boards')
        .doc(boardID)
        .collection('lists')
        .get();
    return snapshot.docs;
  }

  static Future<void> addBoard(String boardName, String workspaceID) async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    final docRef = await FirebaseFirestore.instance.collection('boards').add({
      'boardName': boardName,
      'createdBy': uid,
      "userList": FieldValue.arrayUnion([uid]),
      "background": "",
      'workspaceID': workspaceID,
      'listList' : FieldValue.arrayUnion([]),
      'labelList' : FieldValue.arrayUnion([]),
    });
    //update boardID = document ID
    var snap = await FirebaseFirestore.instance
        .collection('boards')
        .doc(docRef.id)
        .update({"boardID": docRef.id});
    //add board uid to wp 
    var snapshot = await FirebaseFirestore.instance
        .collection('workspaces')
        .doc(workspaceID)
        .update({"boardList": FieldValue.arrayUnion([docRef.id]),});
  }

  //initialize a default board: 3 lists, 7 labels
  static Future<void> createThreeList(String boardID) async {

  }

  static Future<void> addCard(String boardID, String listID, String cardName, String userID, DateTime startDate, DateTime dueDate) async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    final docRef = await FirebaseFirestore.instance.collection('card').add({
      'cardName': cardName,
      'createdBy': uid,
      'description' : "",
      'assignedUser': FieldValue.arrayUnion([uid]),
      'labelList' : FieldValue.arrayUnion([]),
      'status' : true,
      'startDate': Timestamp.fromDate(startDate),
      'dueDate': Timestamp.fromDate(dueDate)
    });
    //add card uid to list
    var snapshot = await FirebaseFirestore.instance
        .collection('boards')
        .doc(boardID)
        .collection('lists')
        .doc(listID)
        .update({"cardList": FieldValue.arrayUnion([docRef.id])});
  }

  //get list user data
  static Future getListUserData(List<String> userIDList) async {
    List listUser = [];
    for(var item in userIDList)
      {
        var snapshot = await FirebaseFirestore.instance
            .collection('users')
            .where('userID', isEqualTo: item)
            .get();
        listUser.add(snapshot.docs.first);
      }
    return listUser;
  }

  //get a user data
  static Future getUserData(String uid) async {
    var snapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('userID', isEqualTo: uid)
        .get();
    return snapshot.docs.first;
  }

  //get a wp data
  static Future getWorkspaceData(String workspaceID) async {
    var snapshot = await FirebaseFirestore.instance
        .collection('workspaces')
        .doc(workspaceID)
        .get();
    return snapshot;
  }
}