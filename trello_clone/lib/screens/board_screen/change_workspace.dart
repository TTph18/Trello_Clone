import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:trello_clone/screens/board_screen/board_screen.dart';

class ChangeWorkspace extends StatefulWidget {
  String currentWorkspace;
  String currentBoard;
  ChangeWorkspace(this.currentWorkspace, this.currentBoard);
  @override
  ChangeWorkspaceState createState() =>
      ChangeWorkspaceState(currentWorkspace, currentBoard);
}

class ChangeWorkspaceState extends State<ChangeWorkspace> {
  String currentWorkspace;
  String currentBoard;
  List<String> userWorkspaces = [
    "Workspace 1",
    "Workspace 2",
    "Workspace 3",
    "Shop ngáo và những người bạn"
  ];
  String? selectedWorkspace;
  ChangeWorkspaceState(this.currentWorkspace, this.currentBoard);
  @override
  void initState() {
    selectedWorkspace = currentWorkspace;
  }

  @override
  Widget build(BuildContext context) {
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
                ///TODO: Change workspace of board
                Route route = MaterialPageRoute(
                    builder: (context) => BoardScreen(currentBoard, true));
                Navigator.push(context, route);
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
            title: Text(userWorkspaces[index]),
            leading: Radio<String>(
              value: userWorkspaces[index],
              groupValue: selectedWorkspace,
              onChanged: (String? value) {
                setState(() {
                  selectedWorkspace = value;
                });
              },
            ),
          ),
        ),
      ),
    );
  }
}
