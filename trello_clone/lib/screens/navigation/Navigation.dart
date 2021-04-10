import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomListTile extends StatelessWidget {
  IconData icon;
  String text;
  Function onTap;
  CustomListTile(this.icon, this.text, this.onTap);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.cyanAccent,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 8.0, 0, 8.0),
        child: Row(
          children: <Widget>[
            Icon(icon),
            SizedBox(
              width: 30,
            ),
            Text(
              text,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

class NavigationMain extends StatelessWidget {
  List<String> grNames = [
    "Nhóm 1",
    "Nhóm 2"
  ]; //index: 10 + 1, 10 + 2, ... , 10 + n
  final Function onIndexChange;
  NavigationMain(this.onIndexChange);

  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        CustomListTile(Icons.dashboard, "Bảng", () => {}),
        CustomListTile(Icons.home, "Trang chủ", () => {}),
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
        MediaQuery.removePadding(
          context: context,
          removeTop: true,
          child: ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: grNames.length,
              itemBuilder: (BuildContext context, int index) {
                return CustomListTile(
                    Icons.group_outlined, grNames[index], () => {});
              }),
        ),
        Divider(
          thickness: 2,
        ),
        CustomListTile(Icons.credit_card, "Thẻ của tôi", () => {}),
        CustomListTile(Icons.shield, "Đổi mật khẩu", () => {}),
        CustomListTile(Icons.logout, "Đăng xuất", () => {}),
      ],
    );
  }
}

class Navigation extends StatefulWidget {
  @override
  _NavigationState createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  int selectedIndex = 0;
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
          NavigationMain((int index) {
            setState(() {
              selectedIndex = index;
            });
          }),
        ],
      ),
    );
    ;
  }
}
