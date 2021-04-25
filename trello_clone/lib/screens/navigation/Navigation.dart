import 'dart:ui';
import 'package:animated_icon_button/animated_icon_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:trello_clone/route_path.dart';

class CustomListTile extends StatelessWidget {
  IconData icon;
  String text;
  VoidCallback onTap;

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
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}

class AccountInfo extends StatelessWidget {
  AssetImage image;
  String text;
  String subtext;
  VoidCallback onTap;

  AccountInfo(this.image, this.text, this.subtext, this.onTap);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10.0, 8.0, 0, 8.0),
        child: Row(
          children: <Widget>[
            Container(
              width: 40,
              height: 40,
              decoration: new BoxDecoration(
                shape: BoxShape.circle,
                image: new DecorationImage(
                  fit: BoxFit.fill,
                  image: image,
                ),
              ),
            ),
            SizedBox(
              width: 20,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(text,
                      textAlign: TextAlign.left,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '@' + subtext,
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                  ),
                ),
              ],
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
  ];
  List<Function> grOnPress = [
        () => {},
        () => {},
  ];
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

class NavigationAccount extends StatelessWidget {
  List<AssetImage> avatar = [
    AssetImage('assets/images/BlueBG.png'),
    AssetImage('assets/images/BlueBG.png'),
  ];
  List<String> name = ["Name 1", "Name 2"];
  List<String> subname = ["Subname 1", "Subname 2"];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        MediaQuery.removePadding(
          context: context,
          removeTop: true,
          child: ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: name.length,
              itemBuilder: (BuildContext context, int index) {
                return AccountInfo(
                    avatar[index], name[index], subname[index], () => {});
              }),
        ),
        InkWell(
          onTap: () {
            Navigator.of(context).pushNamed(LOGIN);
          },
          child: Padding(
            padding: EdgeInsets.fromLTRB(15, 20, 15, 20),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(13, 0, 10, 0),
                  child: Icon(
                    Icons.add,
                    color: Colors.black,
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Text(
                  "Thêm tài khoản",
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class Navigation extends StatefulWidget {
  @override
  _NavigationState createState() => _NavigationState();
}

class _NavigationState extends State<Navigation>{
  late bool isMain;

  @override
  void initState() {
    super.initState();
    isMain = true;
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 4.0, 0, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 70,
                    height: 70,
                    decoration: new BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey),
                      image: new DecorationImage(
                        fit: BoxFit.fill,
                        image: AssetImage('assets/images/BlueBG.png'),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 13,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Name 1",
                              textAlign: TextAlign.left,
                              style:
                              TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                          SizedBox(
                            height: 6,
                          ),
                          Text(
                            '@' + "Subname1",
                            textAlign: TextAlign.left,
                            style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic, color: Colors.white),
                          ),
                        ],
                      ),
                      AnimatedIconButton(
                          size: 25,
                          onPressed: () => {
                            setState(() {
                            isMain =  !isMain;
                            })
                          },
                          icons: [
                            AnimatedIconItem(
                              icon: Icon(Icons.keyboard_arrow_down),
                            ),
                            AnimatedIconItem(
                              icon: Icon(Icons.keyboard_arrow_up),
                            ),
                          ])
                    ],
                  ),
                ],
              ),
            ),
          ),
          isMain ? NavigationMain() : NavigationAccount(),
        ],
      ),
    );
  }
}
