import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:trello_clone/icons/app_icons.dart';
import 'package:trello_clone/route_path.dart';

import 'package:trello_clone/screens/navigation/Navigation.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class MyAppBar extends AppBar with PreferredSizeWidget {
  @override
  get preferredSize => Size.fromHeight(50);

  MyAppBar({Key? key, Widget? title})
      : super(
          key: key,
          title: title,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
        );
}

class BoardInfo extends StatelessWidget {
  AssetImage image;
  String text;
  Function onTap;

  BoardInfo(this.image, this.text, this.onTap);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(15, 10, 15, 5),
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
    );
  }
}

class _MainScreenState extends State<MainScreen> {
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
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Navigation(),
      appBar: AppBar(title: Text('Bảng'), actions: [
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
              MyAppBar(
                title: Text(
                  "Bảng cá nhân",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                    fontSize: 16,
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  physics: ClampingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: boardName.length,
                  itemBuilder: (BuildContext context, int index) {
                    return BoardInfo(boardImage[index], boardName[index],
                        boardOnPress[index]);
                  },
                ),
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
                onTap: () {},
              ),
            ],
          )),
    );
  }
}
