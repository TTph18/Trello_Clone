import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trello_clone/screens/board_screen/board_screen.dart';

class ChangeBackgroundScreen extends StatefulWidget {
  String boardName;
  ChangeBackgroundScreen(this.boardName);
  @override
  ChangeBackgroundScreenState createState() =>
      ChangeBackgroundScreenState(boardName);
}

class ChangeBackgroundScreenState extends State<ChangeBackgroundScreen> {
  String boardName;
  int state = 1;
  bool IsBackgroungColor = true;
  int bgSelectedIndex = 0;
  List<AssetImage> colors = [
    AssetImage("assets/images/bgImage/DarkBlueBG.png"),
    AssetImage("assets/images/bgImage/YellowBG.png"),
    AssetImage("assets/images/bgImage/DarkGreenBG.png"),
    AssetImage("assets/images/bgImage/BrownBG.png"),
    AssetImage("assets/images/bgImage/PurpleBG.png"),
    AssetImage("assets/images/bgImage/PinkBG.png"),
    AssetImage("assets/images/bgImage/LightGreenBG.png"),
    AssetImage("assets/images/bgImage/LightBlueBG.png"),
  ];

  List<AssetImage> landscapes = [
    AssetImage("assets/images/bgImage/Landscape1BG.jpg"),
    AssetImage("assets/images/bgImage/Landscape2BG.jpg"),
    AssetImage("assets/images/bgImage/Landscape3BG.jpg"),
    AssetImage("assets/images/bgImage/Landscape4BG.jpg"),
    AssetImage("assets/images/bgImage/Landscape5BG.jpg"),
    AssetImage("assets/images/bgImage/Landscape6BG.jpg"),
    AssetImage("assets/images/bgImage/Landscape7BG.jpg"),
    AssetImage("assets/images/bgImage/Landscape8BG.jpg"),
    AssetImage("assets/images/bgImage/Landscape9BG.jpg"),
  ];
  ChangeBackgroundScreenState(this.boardName);
  @override
  void initState() {
    state = 1;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            if (state == 1) {
              Route route = MaterialPageRoute(
                  builder: (context) => BoardScreen(boardName, true));
              Navigator.push(context, route);
            } else
              setState(() {
                state = 1;
              });
          },
          icon: Icon(Icons.arrow_back),
        ),
        title: Text("Phông nền bảng"),
      ),
      body: state == 1
          ? GridView.count(
              primary: false,
              padding: const EdgeInsets.all(4),
              crossAxisSpacing: 8,
              crossAxisCount: 2,
              children: <Widget>[
                Ink.image(
                  image: AssetImage('assets/images/bgImage/ColorBG.png'),
                  fit: BoxFit.fill,
                  child: Stack(children: [
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Container(
                        height: 40,
                        color: Color.fromARGB(100, 0, 0, 0),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          "Màu sắc",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          state = 2;
                        });
                      },
                    ),
                  ]),
                ),
                Ink.image(
                  image: AssetImage('assets/images/bgImage/PictureBG.png'),
                  fit: BoxFit.fill,
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Container(
                          height: 40,
                          color: Color.fromARGB(100, 0, 0, 0),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            "Ảnh",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            state = 3;
                          });
                        },
                      ),
                    ],
                  ),
                )
              ],
            )
          : state == 2
              ? GridView.count(
                  primary: false,
                  padding: const EdgeInsets.all(4),
                  crossAxisSpacing: 4,
                  mainAxisSpacing: 4,
                  crossAxisCount: 3,
                  children: List.generate(
                    colors.length,
                    (index) {
                      return Ink.image(
                        image: colors[index],
                        fit: BoxFit.fill,
                        child: (IsBackgroungColor && index == bgSelectedIndex)
                            ? Container(
                          alignment: Alignment.center,
                          child: Icon(
                            Icons.check,
                            size: 50,
                            color: Colors.white,
                          ),
                        )
                            : InkWell(
                          onTap: () {
                            setState(() {
                              bgSelectedIndex = index;
                              IsBackgroungColor = true;
                            });
                            /// TODO: Change background image of board
                          },
                        ),
                      );
                    },
                  ),
                )
              : GridView.count(
                  primary: false,
                  padding: const EdgeInsets.all(4),
                  crossAxisSpacing: 4,
                  mainAxisSpacing: 4,
                  crossAxisCount: 3,
                  children: List.generate(
                    landscapes.length,
                    (index) {
                      return Ink.image(
                        image: landscapes[index],
                        fit: BoxFit.fill,
                        child: (!IsBackgroungColor && index == bgSelectedIndex)
                            ? Container(
                                alignment: Alignment.center,
                                child: Icon(
                                  Icons.check,
                                  size: 50,
                                  color: Colors.white,
                                ),
                              )
                            : InkWell(
                                onTap: () {
                                  setState(() {
                                    bgSelectedIndex = index;
                                    IsBackgroungColor = false;
                                  });
                                  /// TODO: Change background image of board
                                },
                              ),
                      );
                    },
                  ),
                ),
    );
  }
}
