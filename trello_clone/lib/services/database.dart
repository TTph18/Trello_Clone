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

  //Current User
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
}