import 'dart:ui';

import 'package:flutter/material.dart';

class NavigationMain extends StatelessWidget {
  List<String> namesTop = ["Bảng", "Trang chủ"];
  List<String> namesBot = ["Thẻ của tôi", "Cài đặt", "Trợ giúp"];
  List<String> grNames = ["Nhóm 1", "Nhóm 2"];
  List<IconData> iconsTop = [Icons.dashboard, Icons.home];
  List<IconData> iconsBot = [
    Icons.credit_card,
    Icons.settings,
    Icons.info_outlined
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        //Board, Home
        MediaQuery.removePadding(
          context: context,
          removeTop: true,
          child: ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: namesTop.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  child: Container(
                    padding: EdgeInsets.fromLTRB(15, 10, 15, 5),
                    child: Row(
                      children: [
                        Icon(iconsTop[index]),
                        SizedBox(
                          width: 30,
                        ),
                        Text(
                          namesTop[index],
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                  onTap: () {},
                );
              }),
        ),
        Divider(
          thickness: 2,
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Container(
            padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
            child: Text("Nhóm",
                textAlign: TextAlign.left,
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ),
        //Group name
        MediaQuery.removePadding(
          context: context,
          removeTop: true,
          child: GestureDetector(
            child: ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: grNames.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    padding: EdgeInsets.fromLTRB(15, 10, 15, 5),
                    child: Row(
                      children: [
                        Icon(Icons.group_outlined),
                        SizedBox(
                          width: 30,
                        ),
                        Text(
                          grNames[index],
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  );
                }),
            onTap: () {},
          ),
        ),
        Divider(
          thickness: 2,
        ),
        //My card, Setting, Help
        MediaQuery.removePadding(
          context: context,
          removeTop: true,
          child: GestureDetector(
            child: ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: namesBot.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    padding: EdgeInsets.fromLTRB(15, 10, 15, 5),
                    child: Row(
                      children: [
                        Icon(iconsBot[index]),
                        SizedBox(
                          width: 30,
                        ),
                        Text(
                          namesBot[index],
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  );
                }),
            onTap: () {},
          ),
        ),
      ],
    );
  }
}

class NavigationDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
          ),
          NavigationMain(),
        ],
      ),
    );
  }
}
