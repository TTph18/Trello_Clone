import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:trello_clone/models/boards.dart';
import 'package:trello_clone/models/workspaces.dart';
import 'package:trello_clone/screens/board_screen/board_screen.dart';
import 'package:trello_clone/services/database.dart';

class ChangeWorkspace extends StatefulWidget {
  Workspaces currentWorkspace;
  Boards currentBoard;
  ChangeWorkspace(this.currentWorkspace, this.currentBoard);
  @override
  ChangeWorkspaceState createState() =>
      ChangeWorkspaceState(currentWorkspace, currentBoard);
}

class ChangeWorkspaceState extends State<ChangeWorkspace> {
  Workspaces currentWorkspace;
  Boards currentBoard;
  List<Workspaces> userWorkspaces = [];
  Workspaces? selectedWorkspace;
  ChangeWorkspaceState(this.currentWorkspace, this.currentBoard);
  @override
  void initState() {
    selectedWorkspace = currentWorkspace;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: DatabaseService.getUserWorkspaceList(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData)
            return Scaffold(
              appBar: AppBar(
                  leading: IconButton(
                      onPressed: () {
                        Route route = MaterialPageRoute(
                            builder: (context) => BoardScreen(currentBoard, true));
                        Navigator.push(context, route);
                      },
                      icon: Icon(Icons.close)),
                  title: Text("Đổi không gian làm việc"),));
          else {
            userWorkspaces.clear();
            for (DocumentSnapshot item in snapshot.data) {
              Workspaces _wp = Workspaces.fromDocument(item);
              userWorkspaces.add(_wp);
            }
          }
          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                  onPressed: () {
                    Route route = MaterialPageRoute(
                        builder: (context) => BoardScreen(currentBoard, true));
                    Navigator.push(context, route);
                  },
                  icon: Icon(Icons.close)),
              title: Text("Đổi không gian làm việc"),
              actions: [
                IconButton(
                    onPressed: () {
                      String uid = FirebaseAuth.instance.currentUser!.uid;
                     if (currentBoard.createdBy == uid){
                       DatabaseService.moveBoard(currentBoard.boardID, selectedWorkspace!.workspaceID);
                     } else showAlertDialog(context, "Bạn không có quyền sửa bảng này!");

                    },
                    icon: Icon(Icons.check)),
              ],
            ),
            body: Column(
              children: List.generate(
                userWorkspaces.length,
                (index) => ListTile(
                  onTap: () {
                    setState(() {
                      selectedWorkspace = userWorkspaces[index];
                    });
                  },
                  title: Text(userWorkspaces[index].workspaceName),
                  leading: Radio<String>(
                    value: userWorkspaces[index].workspaceID,
                    groupValue: selectedWorkspace!.workspaceID,
                    onChanged: (String? value) {
                      setState(() {
                        selectedWorkspace = userWorkspaces.where(
                                (element) => element.workspaceID == value)
                            as Workspaces?;
                      });
                    },
                  ),
                ),
              ),
            ),
          );
        });
  }
  showAlertDialog(BuildContext context, String alertdialog) {

    // set up the buttons
    Widget cancelButton = ElevatedButton(
      child: Text("Đóng"),
      onPressed:  () {Navigator.of(context).pop();},
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      content: Text(alertdialog),
      actions: [
        cancelButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
