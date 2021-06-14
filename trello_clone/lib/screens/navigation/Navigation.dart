import 'dart:ui';
import 'package:animated_icon_button/animated_icon_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:trello_clone/models/user.dart';
import 'package:trello_clone/route_path.dart';
import 'package:trello_clone/services/database.dart';
import 'package:trello_clone/widgets/reuse_widget/avatar.dart';
import 'package:trello_clone/widgets/reuse_widget/custom_list_tile.dart';

class AccountInfo extends StatelessWidget {

  String subtext;
  Users user;
  VoidCallback onTap;
  AccountInfo(this.subtext, this.user, this.onTap);

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
                  image: AssetImage(user.avatar),
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
                  child: Text(user.userName,
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
  List<String> grNames = ["Nhóm 1", "Nhóm 2"];
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
  List<String> subname = ["Subname1", "Subname2"];

  List<Users> users = [
    Users(
        userID: "12345",
        userName: "name1",
        profileName: "Name 1",
        email: '123456@gmail.com',
        avatar: 'assets/images/BlueBG.png'),
    Users(
        userID: "12345",
        userName: "name2",
        profileName: "Name 2",
        email: '123456@gmail.com',
        avatar: 'assets/images/BlueBG.png'),
  ];

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
              itemCount: users.length,
              itemBuilder: (BuildContext context, int index) {
                return AccountInfo(subname[index], users[index], () => {});
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

class _NavigationState extends State<Navigation> {
  late Users currentUser;
  late bool isMain;

  @override
  void initState() {
    super.initState();
    isMain = true;
  }

  @override
  Widget build(BuildContext context) {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    return Drawer(
      child: Column(
        children: <Widget>[
          FutureBuilder(
            future: DatabaseService.getUserData(context),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                Users currentUser = Users.fromDocument(snapshot.data) ;
                if (snapshot.hasData) {
                  print("true");
                }else if (snapshot.hasError) {
                  print("false");
                }
                return DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 4.0, 0, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        avatar(70, 70, Colors.grey,
                            AssetImage('assets/images/BlueBG.png')),
                        SizedBox(
                          height: 13,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(currentUser.profileName,
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white)),
                                SizedBox(
                                  height: 6,
                                ),
                                Text(
                                  '@' + currentUser.userName,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.white),
                                ),
                              ],
                            ),
                            AnimatedIconButton(
                                size: 25,
                                onPressed: () => {
                                  setState(() {
                                    isMain = !isMain;
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
                );
              }),
          isMain ? NavigationMain() : NavigationAccount(),
        ],
      ),
    );
  }
}


