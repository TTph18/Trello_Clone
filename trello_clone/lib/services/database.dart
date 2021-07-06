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

  //current user data
  static Future<DocumentSnapshot> getCurrentUserData() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    var snapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('userID', isEqualTo: uid)
        .get();
    return snapshot.docs.first;
  }

  //add a new user
  static Future<void> addUser(String userID, String email, String userName, String profileName) async {
    await FirebaseFirestore.instance.collection('users').add({
      'userID': userID,
      'email': email,
      "avatar": "",
      "profileName": profileName,
      'userName': userName,
      'workspaceList' : []
    });
  }

  //get current user workspace list
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

  //get current user boards in workspace
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

  // get lists in board
  static Future getlistList(String boardID) async {
    var snapshot = await FirebaseFirestore.instance
        .collection('boards')
        .doc(boardID)
        .collection('lists')
        .get();
    return snapshot.docs;
  }

  // get lists in board
  static Future getBoardData(String boardID) async {
    var snapshot = await FirebaseFirestore.instance
        .collection('boards')
        .doc(boardID)
        .get();
    return snapshot;
  }

  //add a board
  static Future<void> addBoard(String boardName, String workspaceID) async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    final docRef = await FirebaseFirestore.instance.collection('boards').add({
      'boardName': boardName,
      'createdBy': uid,
      "userList": FieldValue.arrayUnion([uid]),
      "background": "",
      'isPersonal': false,
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
  static Future<void> initializeComponent(String boardID) async {

  }

  //get list user data
  static Future getListUserData(List<String> userIDList) async {
    List listUser = [];
    for(var item in userIDList) {
        var snapshot = await FirebaseFirestore.instance
            .collection('users')
            .where('userID', isEqualTo: item)
            .get();
        listUser.add(snapshot.docs.first);
    }
    return listUser;
  }

  //get all user data
  static Future getAllUsesrData() async {
      var snapshot = await FirebaseFirestore.instance
          .collection('users')
          .get();
    return snapshot.docs;
  }

  //get a user data
  static Future getUserData(String uid) async {
    var snapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('userID', isEqualTo: uid)
        .get();
    return snapshot.docs.first;
  }

  //add a workspace
  static Future<void> addWorkspace(String workspaceName, List<String> userList) async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    final docRef = await FirebaseFirestore.instance.collection('workspaces').add({
      'workspaceName': workspaceName,
      'createdBy': uid,
      "userList": userList,
      'boardList' : [],
    });
    //update workspaceID = document ID
    var snap = await FirebaseFirestore.instance
        .collection('workspaces')
        .doc(docRef.id)
        .update({"workspaceID": docRef.id});
    //update workspaceID in user
    var snapshot =await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .update({"workspaceList": FieldValue.arrayUnion([docRef.id])});
  }

  //get a wp data
  static Future getWorkspaceData(String workspaceID) async {
    var snapshot = await FirebaseFirestore.instance
        .collection('workspaces')
        .doc(workspaceID)
        .get();
    return snapshot;
  }

  //rename a workspace
  static Future<void> renameWorkspace(String workspaceID, String newName) async {
    await FirebaseFirestore.instance
        .collection('workspaces')
        .doc(workspaceID)
        .update({"workspaceName": newName});
  }

  //delete a workspace
  static Future<void> deleteWorkspace(String workspaceID) async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    //delete workspace from user
    List<String> workspaceList;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get().then((value) {
      workspaceList = value['workspaceList'].cast<String>();
      workspaceList.remove(workspaceID);
      FirebaseFirestore.instance
          .collection('users')
          .doc(uid).update({"workspaceList": workspaceList});
    });
    //delete workspace
    await FirebaseFirestore.instance
        .collection('workspaces')
        .doc(workspaceID)
        .delete();
  }

  //delete a board
  static Future<void> deleteBoard(String boardID) async {
    var oldWorkspaceID;
    //get old wp id
    await FirebaseFirestore.instance
        .collection('boards')
        .doc(boardID)
        .get().then((value) {
      oldWorkspaceID = value['workspaceID'].toString();
    });
    //delete board
    await FirebaseFirestore.instance
        .collection('boards')
        .doc(boardID)
        .delete();
    //delete board from wp
    List<String> boardList;
    await FirebaseFirestore.instance
        .collection('workspaces')
        .doc(oldWorkspaceID)
        .get().then((value) {
          boardList = value['boardList'].cast<String>();
          boardList.remove(boardID);
          FirebaseFirestore.instance
              .collection('workspaces')
              .doc(oldWorkspaceID).update({"boardList": boardList});
    });
  }

  //delete a user in a board
  static Future<void> deleteUserInBoard(String userID, String boardID) async {
    List<String> userList;
    //get old wp id
    await FirebaseFirestore.instance
        .collection('boards')
        .doc(boardID)
        .get().then((value) {
      userList = value['userList'].cast<String>();
      userList.remove(userID);
      FirebaseFirestore.instance
          .collection('boards')
          .doc(boardID).update({"userList": userList});
    });
  }

  //move a board to other workspace
  static Future<void> addUserToBoard(String boardID, String userID) async {
    await FirebaseFirestore.instance
        .collection('boards')
        .doc(boardID)
        .update(({"userList": FieldValue.arrayUnion([userID])}));
  }

  //move a board to other workspace
  static Future<void> moveBoard(String boardID, String newWorkspaceID) async {
    var oldWorkspaceID;
    //get old wp id
    await FirebaseFirestore.instance
        .collection('boards')
        .doc(boardID)
        .get().then((value) {
        oldWorkspaceID = value['workspaceID'].toString();
    });
    //delete board id from old wp
    List<String> boardList;
    await FirebaseFirestore.instance
        .collection('workspaces')
        .doc(oldWorkspaceID)
        .get().then((value) {
      boardList = value['boardList'].cast<String>();
      boardList.remove(boardID);
      FirebaseFirestore.instance
          .collection('workspaces')
          .doc(oldWorkspaceID).update({"boardList": boardList});
    });
    //update board id in new wp
    await FirebaseFirestore.instance
        .collection('workspaces')
        .doc(newWorkspaceID)
        .update({"boardList": FieldValue.arrayUnion([boardID])});
    //update new wp id in board
    await FirebaseFirestore.instance
        .collection('boards')
        .doc(boardID)
        .update({"workspaceID": newWorkspaceID});
  }

  //leave a board
  static Future<void> leaveBoard(String boardID, String uid) async {
    List<String> userList;
    await FirebaseFirestore.instance
        .collection('boards')
        .doc(boardID)
        .get().then((value) {
      userList = value['userList'].cast<String>();
      userList.remove(uid);
      FirebaseFirestore.instance
          .collection('workspaces')
          .doc(boardID).update({"userList": userList});
    });
  }

  //rename a board
  static Future<void> renameBoard(String boardID, String newName) async {
    await FirebaseFirestore.instance
        .collection('boards')
        .doc(boardID)
        .update({"boardName": newName});
  }

  //add a card
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
    await FirebaseFirestore.instance
        .collection('boards')
        .doc(boardID)
        .collection('lists')
        .doc(listID)
        .update({"cardList": FieldValue.arrayUnion([docRef.id])});
  }
}