import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:trello_clone/icons/app_icons.dart';
import 'package:trello_clone/models/boards.dart';
import 'package:trello_clone/models/workspaces.dart';
import 'package:trello_clone/route_path.dart';
import 'package:trello_clone/screens/board_screen/board_screen.dart';
import 'package:trello_clone/screens/navigation/Navigation.dart';
import 'package:trello_clone/services/database.dart';

import '../../route_path.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class BoardInfo extends StatelessWidget {
  AssetImage image;
  String text;
  Function onTap;

  BoardInfo(this.image, this.text, this.onTap);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Route route = MaterialPageRoute(builder: (context)=>BoardScreen(text, false));
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
              text,
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}

class GroupName extends StatelessWidget {
  late String grName;
  
  GroupName(this.grName);
  
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
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
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                child: Text(
                  grName,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class GroupInfo extends StatelessWidget {
  late String grName;
  late String grID;
  GroupInfo(this.grName, this.grID);

  List<AssetImage> boardImage = [
    AssetImage('assets/images/BlueBG.png'),
    AssetImage('assets/images/BlueBG.png'),
  ];
  List<String> boardName = [
    "Tên bảng 1",
    "Tên bảng 2",
  ];
  List<Function> boardOnPress = [
        () => {},
        () => {},
  ];
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GroupName(this.grName),
        FutureBuilder(
        future: DatabaseService.getBoardList(grID),
        builder: (BuildContext context, AsyncSnapshot snapshot){
          if (!snapshot.hasData)
            return Container(
                alignment: FractionalOffset.center,
                child: CircularProgressIndicator());
          return ListView.builder(
            physics: ClampingScrollPhysics(),
            shrinkWrap: true,
            itemCount: snapshot.data.length,
            itemBuilder: (BuildContext context, int index) {
              Boards _br = Boards.fromDocument(snapshot.data[index]);
              return BoardInfo(boardImage[index], _br.boardName.toString(),
                  boardOnPress[index]);
            },
          );
        }),
      ],
    );
  }
}

class _MainScreenState extends State<MainScreen> {
  int selectedIndex = 0;
  List<String> groupName = [
    "Tên bảng 1",
    "Tên bảng 2",
    "Tên bảng 3"
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Navigation(),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(0, 121, 191, 1.0),
          title: Text('Bảng'), actions: [
        IconButton(
          icon: Transform(
            alignment: Alignment.center,
            transform: Matrix4.rotationY(math.pi),
            child: Icon(MyFlutterApp.search),
          ),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(MyFlutterApp.bell),
          onPressed: () {},
        )
      ]),
      body: Scaffold(
          body: Column(
            children: [
              FutureBuilder(
                  future: DatabaseService.getUserWorkspaceList(),
                  builder: (BuildContext context, AsyncSnapshot snapshot){
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
                          Workspaces _wp = Workspaces.fromDocument(snapshot.data[index]);
                          return GroupInfo(_wp.workspaceName.toString(), _wp.workspaceID.toString());
                        },
                      ),
                    ) ;
                  })
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
                label: 'Nhóm',
                labelStyle: TextStyle(fontSize: 18.0),
                onTap: () {},
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
