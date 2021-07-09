import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:trello_clone/models/lists.dart';
import 'package:trello_clone/models/user.dart';
import 'package:trello_clone/models/workspaces.dart';

class DatabaseService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Stream<String?> get onAuthStateChanged =>
      _firebaseAuth.authStateChanges().map(
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
  static Future<void> addUser(
      String userID, String email, String userName, String profileName) async {
    await FirebaseFirestore.instance.collection('users').doc(userID).set({
      'userID': userID,
      'email': email,
      "avatar": "",
      "profileName": profileName,
      'userName': userName,
      'workspaceList': []
    });
  }

  static Stream streamWorkspaces()  {
    String uid = FirebaseAuth.instance.currentUser!.uid;
      var snapshot = FirebaseFirestore.instance
          .collection('workspaces')
          .where('userList', arrayContains: uid)
          .snapshots();
    return snapshot.map((list) =>
        list.docs.map((doc) => Workspaces.fromDocument(doc)).toList());
  }

  static Stream streamUser()  {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    var snapshot = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .snapshots();
    return snapshot;
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
    if (brID == []) {
      return brList;
    }
    for (var temp in brID) {
      var _snapshot = await FirebaseFirestore.instance
          .collection('boards')
          .where('boardID', isEqualTo: temp)
          .where('userList', arrayContains: uid)
          .get();
      brList.add(_snapshot.docs.first);
    }
    return brList;
  }

  //get current user boards in workspace
  static Stream streamListBoard(String workspaceID) async* {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    List brList = [];
    var snapshot = await FirebaseFirestore.instance
        .collection('workspaces')
        .where('workspaceID', isEqualTo: workspaceID)
        .get();
    List brID = snapshot.docs.first["boardList"];
    if (brID == []) {
      yield brList;
    }
    for (var temp in brID) {
      var _snapshot = await FirebaseFirestore.instance
          .collection('boards')
          .where('boardID', isEqualTo: temp)
          .where('userList', arrayContains: uid)
          .get();
      brList.add(_snapshot.docs.first);
    }
    yield brList;
  }

  //add a list
  static Future<void> addList(String boardID, String listName) async {
    await FirebaseFirestore.instance
        .collection('boards')
        .doc(boardID)
        .get()
        .then((value) async {
      int listNumber = value['listNumber'];
      final docRef = await FirebaseFirestore.instance
          .collection('boards')
          .doc(boardID)
          .collection('lists')
          .add({
        'listName': listName,
        'cardList': [],
        "cardNumber": 0,
        "position": listNumber + 1
      });
      //update listID = document ID
      FirebaseFirestore.instance
          .collection('lists')
          .doc(docRef.id)
          .update({"listID": docRef.id});
      //update listID = document ID
      FirebaseFirestore.instance
          .collection('boards')
          .doc(boardID)
          .update({"listNumber": listNumber + 1});
    });
  }

  // get lists in board
  static Future getlistList(String boardID) async {
    var snapshot = await FirebaseFirestore.instance
        .collection('boards')
        .doc(boardID)
        .collection('lists')
        .orderBy("position")
        .get();
    return snapshot.docs;
  }

  static Stream? streamLists(String boardID) {
    if ( boardID.isNotEmpty){
      var ref = FirebaseFirestore.instance
          .collection('boards')
          .doc(boardID)
          .collection('lists')
          .orderBy("position")
          .snapshots();
      return ref;
    }
    else return null;
  }

  // rename lists in board
  static Future<void> renameList(
      String boardID, String listID, String listName) async {
    await FirebaseFirestore.instance
        .collection('boards')
        .doc(boardID)
        .collection('lists')
        .doc(listID)
        .update({'listName': listName});
  }

  static Future<void> deleteList(String boardID, String listID) async {
    await FirebaseFirestore.instance
        .collection('boards')
        .doc(boardID)
        .collection('lists')
        .doc(listID)
        .get()
        .then((value) async {
      int deletePos = value['position'];
      FirebaseFirestore.instance
          .collection('boards')
          .doc(boardID)
          .get()
          .then((value) async {
        int listNumber = value['listNumber'];
        for (int i = deletePos; i <= listNumber - 1; i++) {
           FirebaseFirestore.instance
              .collection('boards')
              .doc(boardID)
              .collection('lists')
              .where('position', isEqualTo: i + 1)
              .get()
              .then((value) => value.docs.forEach((element) {
                    String id = element['listID'];
                    FirebaseFirestore.instance
                        .collection('lists')
                        .doc(id)
                        .update({"position": i});
                  }));
        }
        FirebaseFirestore.instance
            .collection('boards')
            .doc(boardID)
            .update({'listNumber': listNumber - 1});
      });
    });
    await FirebaseFirestore.instance
        .collection('boards')
        .doc(boardID)
        .collection('lists')
        .doc(listID)
        .delete();
  }

  //move a list to other board
  static Future<void> moveListToABoard(
      String oldBoardID, String newBoardID, Lists curentlist) async {
    await FirebaseFirestore.instance
        .collection('boards')
        .doc(newBoardID)
        .get()
        .then((value) async {
      int listNumber = value['listNumber'] + 1;
      await FirebaseFirestore.instance
          .collection('boards')
          .doc(newBoardID)
          .update({'listNumber': listNumber});
      final docRef = await FirebaseFirestore.instance
          .collection('boards')
          .doc(newBoardID)
          .collection('lists')
          .add({
        'listName': curentlist.listName,
        'cardNumber': curentlist.cardNumber,
        "position": listNumber,
        "cardList": curentlist.cardList
      });
      //update new listID = document ID
      await FirebaseFirestore.instance
          .collection('boards')
          .doc(newBoardID)
          .collection('lists')
          .doc(docRef.id)
          .update({"listID": docRef.id});
    });
    await FirebaseFirestore.instance
        .collection('boards')
        .doc(oldBoardID)
        .get()
        .then((e) async {
      int _listNumber = e['listNumber'] - 1;
      if (_listNumber < 0) _listNumber = 0;
      await FirebaseFirestore.instance
          .collection('boards')
          .doc(oldBoardID)
          .update({'listNumber': _listNumber});
      //remove list from old board
      await FirebaseFirestore.instance
          .collection('boards')
          .doc(oldBoardID)
          .collection('lists')
          .doc(curentlist.listID)
          .delete();
    });
  }

  //move a list to other position
  static Future<void> moveListPosition(
      String boardID, String listID, int oldPosition, int newPosition) async {
    await FirebaseFirestore.instance
        .collection('boards')
        .doc(boardID)
        .collection('lists')
        .where('position', isEqualTo: newPosition)
        .get()
        .then((value) => value.docs.forEach((element) {
              String id = element['listID'];
              FirebaseFirestore.instance
                  .collection('lists')
                  .doc(id)
                  .update({"position": oldPosition});
            }));
    await FirebaseFirestore.instance
        .collection('boards')
        .doc(boardID)
        .collection('lists')
        .doc(listID)
        .update({'position': newPosition});
  }

  // get board
  static Future getBoardData(String boardID) async {
    var snapshot = await FirebaseFirestore.instance
        .collection('boards')
        .doc(boardID)
        .get();
    return snapshot;
  }
  static Future getListData(String boardID, String listID) async {
    var snapshot = await FirebaseFirestore
        .instance
        .collection('boards')
        .doc(boardID)
        .collection('lists')
        .doc(listID)
        .get();
    return snapshot;
  }

  // get lists in board
  static Future getAllBoards() async {
    var snapshot = await FirebaseFirestore.instance.collection('boards').get();
    return snapshot.docs;
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
      'listNumber': 3, 'cardNumber':0, 'description' : ""
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
        .update({
      "boardList": FieldValue.arrayUnion([docRef.id]),
    });
    initialize3List(docRef.id);
    initialize5Labels(docRef.id);
  }

  //initialize a default board: 3 lists, 6 labels
  static Future<void> initialize3List(String boardID) async {
    final docRef1 = await FirebaseFirestore.instance
        .collection('boards')
        .doc(boardID)
        .collection('lists')
        .add({'listName': "Done", 'cardList': [], 'position': 3, 'cardNumber': 0});
    await FirebaseFirestore.instance
        .collection('boards')
        .doc(boardID)
        .collection('lists')
        .doc(docRef1.id)
        .update({"listID": docRef1.id});
    final docRef2 = await FirebaseFirestore.instance
        .collection('boards')
        .doc(boardID)
        .collection('lists')
        .add({'listName': "Doing", 'cardList': [], 'position': 2, 'cardNumber':0});
    await FirebaseFirestore.instance
        .collection('boards')
        .doc(boardID)
        .collection('lists')
        .doc(docRef2.id)
        .update({"listID": docRef2.id});
    final docRef3 = await FirebaseFirestore.instance
        .collection('boards')
        .doc(boardID)
        .collection('lists')
        .add({'listName': "To do", 'cardList': [], 'position': 1, 'cardNumber':0});
    await FirebaseFirestore.instance
        .collection('boards')
        .doc(boardID)
        .collection('lists')
        .doc(docRef3.id)
        .update({"listID": docRef3.id});
  }

  static Future<void> initialize5Labels(String boardID) async {
    final docRef1 = await FirebaseFirestore.instance
        .collection('boards')
        .doc(boardID)
        .collection('labels')
        .add({'labelName': "", 'color': "0xff0079bf"});
    await FirebaseFirestore.instance
        .collection('boards')
        .doc(boardID)
        .collection('labels')
        .doc(docRef1.id)
        .update({"labelID": docRef1.id});

    final docRef2 = await FirebaseFirestore.instance
        .collection('boards')
        .doc(boardID)
        .collection('labels')
        .add({'labelName': "", 'color': "0xffc377e0"});
    await FirebaseFirestore.instance
        .collection('boards')
        .doc(boardID)
        .collection('labels')
        .doc(docRef2.id)
        .update({"labelID": docRef2.id});

    final docRef3 = await FirebaseFirestore.instance
        .collection('boards')
        .doc(boardID)
        .collection('labels')
        .add({'labelName': "", 'color': "0xffeb5a46"});
    await FirebaseFirestore.instance
        .collection('boards')
        .doc(boardID)
        .collection('labels')
        .doc(docRef3.id)
        .update({"labelID": docRef3.id});

    final docRef4 = await FirebaseFirestore.instance
        .collection('boards')
        .doc(boardID)
        .collection('labels')
        .add({'labelName': "", 'color': "0xff61bd4f"});
    await FirebaseFirestore.instance
        .collection('boards')
        .doc(boardID)
        .collection('labels')
        .doc(docRef4.id)
        .update({"labelID": docRef4.id});

    final docRef5 = await FirebaseFirestore.instance
        .collection('boards')
        .doc(boardID)
        .collection('labels')
        .add({'labelName': "", 'color': "0xfff2d600"});
    await FirebaseFirestore.instance
        .collection('boards')
        .doc(boardID)
        .collection('labels')
        .doc(docRef5.id)
        .update({"labelID": docRef5.id});
  }

  //get list user data
  static Future getListUserData(List<String> userIDList) async {
    List listUser = [];
    for (var item in userIDList) {
      var snapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('userID', isEqualTo: item)
          .get();
      listUser.add(snapshot.docs.first);
    }
    return listUser;
  }

  static Stream streamListUser(List<String> userIDList) async* {
    List listUser = [];
    for (var item in userIDList) {
      var snapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('userID', isEqualTo: item)
          .get();
      listUser.add(snapshot.docs.first);
    }
    yield listUser;
  }

  static Stream streamWorkspaceListUser(String workspaceID) async* {
    List listUser = [];
    var snapshot = await FirebaseFirestore.instance
        .collection('workspaces')
        .doc(workspaceID)
        .get();
    List userID = snapshot["userList"];
    if (userID == []) {
      yield userID;
    }
    for (var item in userID) {
      var snapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('userID', isEqualTo: item)
          .get();
      listUser.add(snapshot.docs.first);
    }
    yield listUser;
  }

  //get all user data
  static Future getAllUsersData() async {
    var snapshot = await FirebaseFirestore.instance.collection('users').get();
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
  static Future<void> addWorkspace(
      String workspaceName, List<String> userList) async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    final docRef =
        await FirebaseFirestore.instance.collection('workspaces').add({
      'workspaceName': workspaceName,
      'createdBy': uid,
      "userList": userList,
      'boardList': [],
    });
    //update workspaceID = document ID
    await FirebaseFirestore.instance
        .collection('workspaces')
        .doc(docRef.id)
        .update({"workspaceID": docRef.id});
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
  static Future<void> renameWorkspace(
      String workspaceID, String newName) async {
    await FirebaseFirestore.instance
        .collection('workspaces')
        .doc(workspaceID)
        .update({"workspaceName": newName});
  }

  //delete a workspace
  static Future<void> deleteWorkspace(String workspaceID) async {
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
        .get()
        .then((value) {
      oldWorkspaceID = value['workspaceID'].toString();
    });
    //delete board
    await FirebaseFirestore.instance.collection('boards').doc(boardID).delete();
    //delete board from wp
    List<String> boardList;
    await FirebaseFirestore.instance
        .collection('workspaces')
        .doc(oldWorkspaceID)
        .get()
        .then((value) {
      boardList = value['boardList'].cast<String>();
      boardList.remove(boardID);
      FirebaseFirestore.instance
          .collection('workspaces')
          .doc(oldWorkspaceID)
          .update({"boardList": boardList});
    });
  }

  //delete a user in a board
  static Future<void> deleteUserInBoard(String userID, String boardID) async {
    List<String> userList;
    //get old wp id
    await FirebaseFirestore.instance
        .collection('boards')
        .doc(boardID)
        .get()
        .then((value) {
      userList = value['userList'].cast<String>();
      userList.remove(userID);
      FirebaseFirestore.instance
          .collection('boards')
          .doc(boardID)
          .update({"userList": userList});
    });
  }

  //delete a user in a board
  static Future<void> deleteUserInWorkspace(String userID, String workspaceID) async {
    List<String> userList;
    //get old wp id
    await FirebaseFirestore.instance
        .collection('boards')
        .doc(workspaceID)
        .get()
        .then((value) {
      userList = value['userList'].cast<String>();
      userList.remove(userID);
      FirebaseFirestore.instance
          .collection('boards')
          .doc(workspaceID)
          .update({"userList": userList});
    });
  }

  //move a board to other workspace
  static Future<void> addUserToBoard(String boardID, String userID) async {
    await FirebaseFirestore.instance.collection('boards').doc(boardID).update(({
          "userList": FieldValue.arrayUnion([userID])
        }));
  }

  static Future<void> addUserToWorkspace(String workspaceID, List listUserID) async {
    await FirebaseFirestore.instance.collection('workspaces').doc(workspaceID).update(({
      "userList": FieldValue.arrayUnion(listUserID)
    }));
  }

  //move a board to other workspace
  static Future<void> moveBoard(String boardID, String newWorkspaceID) async {
    var oldWorkspaceID;
    //get old wp id
    await FirebaseFirestore.instance
        .collection('boards')
        .doc(boardID)
        .get()
        .then((value) {
      oldWorkspaceID = value['workspaceID'].toString();
    });
    //delete board id from old wp
    List<String> boardList;
    await FirebaseFirestore.instance
        .collection('workspaces')
        .doc(oldWorkspaceID)
        .get()
        .then((value) {
      boardList = value['boardList'].cast<String>();
      boardList.remove(boardID);
      FirebaseFirestore.instance
          .collection('workspaces')
          .doc(oldWorkspaceID)
          .update({"boardList": boardList});
    });
    //update board id in new wp
    await FirebaseFirestore.instance
        .collection('workspaces')
        .doc(newWorkspaceID)
        .update({
      "boardList": FieldValue.arrayUnion([boardID])
    });
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
        .get()
        .then((value) {
      userList = value['userList'].cast<String>();
      userList.remove(uid);
      FirebaseFirestore.instance
          .collection('workspaces')
          .doc(boardID)
          .update({"userList": userList});
    });
  }

  //rename a board
  static Future<void> renameBoard(String boardID, String newName) async {
    await FirebaseFirestore.instance
        .collection('boards')
        .doc(boardID)
        .update({"boardName": newName});
  }

  static Future getAllLabel(String boardID) async {
    var snapshot = await FirebaseFirestore.instance
        .collection('boards')
        .doc(boardID)
        .collection('labels')
        .get();
    return snapshot.docs;
  }

  static Future updateLabel(String boardID, String labelID, String labelName,
      String labelColor) async {
    var snapshot = await FirebaseFirestore.instance
        .collection('boards')
        .doc(boardID)
        .collection('labels')
        .doc(labelID)
        .update({"labelName": labelName, "labelColor": labelColor});
  }

  // get a card data
  static Future getCardData(String cardID) async {
    var snapshot =
        await FirebaseFirestore.instance.collection('cards').doc(cardID).get();
    return snapshot;
  }

  // get lists card
  static Future getListCard(String boardID) async {
    var snapshot = await FirebaseFirestore.instance
        .collection('cards')
        .where('boardID', isEqualTo: boardID)
        .get();
    return snapshot.docs;
  }

  static Stream streamCards(String boardID) {
    var ref = FirebaseFirestore.instance
        .collection('cards')
        .where('boardID', isEqualTo: boardID)
        .snapshots();
    return ref;
  }

//delete a board
  static Future<void> reduceCardNumberInBoard(String cardID) async {
    //get old list, board id
    FirebaseFirestore.instance
        .collection('cards')
        .doc(cardID)
        .get()
        .then((value) async {
      var oldBoardID;
      oldBoardID = value['boardID'].toString();
      //update card number in board
      FirebaseFirestore.instance
          .collection('boards')
          .doc(oldBoardID)
          .get()
          .then((value) async {
        int cardNumber = value['cardNumber'] - 1;
        if (cardNumber < 0) cardNumber = 0;
        await FirebaseFirestore.instance
            .collection('boards')
            .doc(oldBoardID)
            .update({'cardNumber': cardNumber});
      });
    });
  }

  //delete a board
  static Future<void> deleteCard(String cardID) async {
    //get old list, board id
    FirebaseFirestore.instance
        .collection('cards')
        .doc(cardID)
        .get()
        .then((value) {
      var oldListID;
      var oldBoardID;
      oldBoardID = value['boardID'].toString();
      oldListID = value['listID'].toString();
      //delete card id from list
      List<String> cardList;
      FirebaseFirestore.instance.collection('boards')
           .doc(oldBoardID)
          .collection('lists')
          .doc(oldListID)
          .get()
          .then((value) {
        cardList = value['cardList'].cast<String>();
        cardList.remove(cardID);
        FirebaseFirestore.instance.collection('boards')
            .doc(oldBoardID)
            .collection('lists')
            .doc(oldListID)
            .update({"cardList": cardList});
      });
      //update card number in list
      FirebaseFirestore.instance.collection('boards')
          .doc(oldBoardID)
          .collection('lists')
          .doc(oldListID)
          .get()
          .then((value) async {
        int cardNumber = value['cardNumber'] - 1;
        if(cardNumber<0) cardNumber = 0;
        await FirebaseFirestore.instance.collection('boards')
            .doc(oldBoardID)
            .collection('lists')
            .doc(oldListID)
            .update({'cardNumber': cardNumber});
      });
    });
    //delete card
     await FirebaseFirestore.instance.collection('cards').doc(cardID).delete();
  }

  //add a card
  static Future<void> addCard(
      String boardID,
      String listID,
      String cardName,
      String description,
      String userID,
      List<String> assignedUser,
      String startDate,
      String dueDate,
      String startTime,
      String dueTime) async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    final docRef = await FirebaseFirestore.instance.collection('cards').add({
      'cardName': cardName,
      'boardID': boardID,
      'createdBy': uid,
      'description': description,
      'assignedUser': assignedUser,
      'listID': listID,
      'labelList': [],
      'status': true,
      'startDate': startDate,
      'dueDate': dueDate,
      'startTime': startTime,
      'dueTime': dueTime
    });
    //add card uid to list
    FirebaseFirestore.instance
        .collection('boards')
        .doc(boardID)
        .collection('lists')
        .doc(listID)
        .update({
      "cardList": FieldValue.arrayUnion([docRef.id])
    });
    //update card number in list
    FirebaseFirestore.instance.collection('boards')
        .doc(boardID)
        .collection('lists')
        .doc(listID)
        .get()
        .then((value) async {
      int cardNumber = value['cardNumber'] + 1;
      FirebaseFirestore.instance.collection('boards')
          .doc(boardID)
          .collection('lists')
          .doc(listID)
          .update({'cardNumber': cardNumber});
    });
    FirebaseFirestore.instance
        .collection('boards')
        .doc(boardID)
        .get()
        .then((value) async {
      int cardNumber = value['cardNumber'] + 1;
       FirebaseFirestore.instance
          .collection('boards')
          .doc(boardID)
          .update({'cardNumber': cardNumber});
    });
  }
}
