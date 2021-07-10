import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:trello_clone/icons/app_icons.dart';
import 'package:trello_clone/models/boards.dart';
import 'package:trello_clone/models/workspaces.dart';
import 'package:trello_clone/route_path.dart';
import 'package:trello_clone/screens/board_screen/board_screen.dart';
import 'package:trello_clone/screens/navigation/Navigation.dart';
import 'package:trello_clone/services/database.dart';

import '../../route_path.dart';
import 'member_list.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class BoardInfo extends StatelessWidget {
  AssetImage image;
  Boards boards;
  Function onTap;

  BoardInfo(this.image, this.boards, this.onTap);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Route route =
            MaterialPageRoute(builder: (context) => BoardScreen(boards, false));
        Navigator.push(context, route);
      },
      child: Container(
        padding: EdgeInsets.fromLTRB(15, 7, 15, 7),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(0, 0, 15, 0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(3.0),
                child: Image(
                  image: image,
                  width: 50,
                  height: 50,
                ),
              ),
            ),
            Text(
              boards.boardName,
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}

class GroupName extends StatelessWidget {
  TextEditingController changeNameController = TextEditingController();
  String uid = FirebaseAuth.instance.currentUser!.uid;
  late Workspaces group;

  GroupName(this.group);

  @override
  Widget build(BuildContext context) {
    changeNameController.value = new TextEditingValue(text: group.workspaceName,);
    return Stack(
      children: <Widget>[
        Container(
          height: 50,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              top: BorderSide(width: 1.0, color: Colors.grey),
              bottom: BorderSide(width: 1.0, color: Colors.grey),
            ),
          ),
        ),
        Material(
          type: MaterialType.transparency,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                child: Text(
                  group.workspaceName,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                    fontSize: 16,
                  ),
                ),
              ),
              PopupMenuButton(
                iconSize: 25,
                padding: EdgeInsets.zero,
                icon: Icon(Icons.more_vert),
                onSelected: (value) {
                  if (value == 0)
                  {
                    showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: const Text(
                          'Sửa tên không gian làm việc',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        content: Container(
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextField(
                          controller: changeNameController,
                          decoration: InputDecoration(
                                  alignLabelWithHint: true,
                                  labelStyle: TextStyle(
                                    fontSize: 22.0,
                                    height: 0.9,
                                  ),
                                  labelText: "Tên không gian làm việc",
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text(
                                      "HỦY",
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      DatabaseService.renameWorkspace(group.workspaceID, changeNameController.text);
                                      Navigator.of(context).pushNamed(MAIN_SCREEN);
                                    },
                                    child: Text("SỬA"),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                  if (value == 1)
                    {
                      Route route =
                      MaterialPageRoute(builder: (context) => MemberList(group));
                      Navigator.push(context, route);
                    }
                  if (value == 2)
                  {
                    if(uid != group.createdBy){
                      showAlertDialog(context, "Bạn không có quyền xóa không gian làm việc này!");
                    } else {
                      DatabaseService.deleteWorkspace(group.workspaceID);
                    }
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 0,
                    child: Text('Sửa tên không gian làm việc'),
                  ),
                  PopupMenuItem(
                    value: 1,
                    child: Text('Thành viên không gian làm việc'),
                  ),
                  PopupMenuItem(
                    value: 2,
                    child: Text('Xóa không gian làm việc'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class GroupInfo extends StatelessWidget {
  late Workspaces group;
  bool hasData = false;
  GroupInfo(this.group);

  AssetImage boardImage = AssetImage('assets/images/BlueBG.png');
  Function boardOnPress = () => {};
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GroupName(this.group),
        StreamBuilder(
            stream: DatabaseService.streamListBoard(group.workspaceID),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData) {
                hasData = false;
                return Container(
                    alignment: FractionalOffset.center,
                    child: CircularProgressIndicator());
              } else
                hasData = true;
              if (!hasData) {
                return SizedBox();
              } else
                return ListView.builder(
                  physics: ClampingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    Boards _br = Boards.fromDocument(snapshot.data[index]);
                    return BoardInfo(
                        boardImage, _br, boardOnPress);
                  },
                );
            }),
      ],
    );
  }
}

class _MainScreenState extends State<MainScreen> {
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Navigation(),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(0, 121, 191, 1.0),
        title: Text('Bảng'),
        actions: [
          IconButton(
            icon: const Icon(MyFlutterApp.bell),
            onPressed: () {
              Navigator.of(context).pushNamed(NOTIFICATION_SCREEN);
            },
          ),
        ],
      ),
      body: Scaffold(
          body: Column(
            children: [
              StreamBuilder(
                stream: DatabaseService.streamWorkspaces(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData)
                    return Container(
                        alignment: FractionalOffset.center,
                        child: CircularProgressIndicator());
                  return Expanded(
                    child: ListView.builder(
                      physics: ClampingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        Workspaces _wp =
                            snapshot.data[index];
                        return GroupInfo(_wp);
                      },
                    ),
                  );
                },
              ),
            ],
          ),
          floatingActionButton: SpeedDial(
            icon: Icons.add,
            activeIcon: Icons.remove,
            useRotationAnimation: true,
            visible: true,
            closeManually: false,
            renderOverlay: false,
            overlayColor: Colors.white,
            overlayOpacity: 0.5,
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            shape: CircleBorder(),
            children: [
              SpeedDialChild(
                child: Icon(
                  Icons.group,
                  color: Colors.white,
                ),
                backgroundColor: Colors.green,
                label: 'Không gian làm việc',
                labelStyle: TextStyle(fontSize: 18.0),
                onTap: () {
                  Navigator.of(context).pushNamed(CREATE_WORKSPACE_SCREEN);
                },
              ),
              SpeedDialChild(
                child: Icon(
                  Icons.dashboard_customize,
                  color: Colors.white,
                ),
                backgroundColor: Colors.green,
                label: 'Bảng',
                labelStyle: TextStyle(fontSize: 18.0),
                onTap: () {
                  Navigator.of(context).pushNamed(CREATE_BOARD_SCREEN);
                },
              ),
              SpeedDialChild(
                child: Icon(
                  Icons.credit_card,
                  color: Colors.white,
                ),
                backgroundColor: Colors.green,
                label: 'Thẻ',
                labelStyle: TextStyle(fontSize: 18.0),
                onTap: () {
                  Navigator.of(context).pushNamed(CREATE_CARD_SCREEN);
                },
              ),
            ],
          )),
    );
  }
}
showAlertDialog(BuildContext context, String alertdialog) {
  // set up the buttons
  Widget cancelButton = ElevatedButton(
    child: Text("Đóng"),
    onPressed: () {
      Navigator.of(context).pop();
    },
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
