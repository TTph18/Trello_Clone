import 'dart:ui';
import 'package:animated_icon_button/animated_icon_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:trello_clone/models/user.dart';
import 'package:trello_clone/route_path.dart';
import 'package:trello_clone/services/authentication_service.dart';
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
                  child: Text(user.userName, textAlign: TextAlign.left, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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

class NavigationMain extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => NavigationMainState();
}

class NavigationMainState extends State<NavigationMain> {
  TextEditingController changeNameController = TextEditingController();
  bool _validate = false;
  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  List<String> grNames = ["Nhóm 1", "Nhóm 2"];
  late bool hasData = false;
  List<Function> grOnPress = [
    () => {},
    () => {},
  ];

  @override
  Widget build(BuildContext context) {
    FirebaseAuth auth = FirebaseAuth.instance;
    String uid = auth.currentUser!.uid;
    var curUser = FirebaseFirestore.instance.collection('users').doc(uid).snapshots();
    signOut() async {
      await auth.signOut();
    }

    String oldPasswordValidation = "";
    String newPasswordValidation = "";
    String confirmPasswordValidation = "";
    return Column(
      children: <Widget>[
        CustomListTile(Icons.dashboard, "Bảng", () => {}),
        Divider(
          thickness: 2,
        ),
        CustomListTile(
          Icons.title,
          "Sửa tên hiển thị",
          () => showDialog<String>(
            context: context,
            builder: (BuildContext context) => StatefulBuilder(
              builder: (context, setState) {
                return AlertDialog(
                  title: const Text(
                    'Sửa tên hiển thị',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  content: Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        StreamBuilder<DocumentSnapshot>(
                            stream: curUser,
                            builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                              if (snapshot.connectionState == ConnectionState.active) {
                                // get sections from the document
                                changeNameController.text = _validate ? "" : snapshot.data!['profileName'];
                              }
                              return TextField(
                                controller: changeNameController,
                                decoration: InputDecoration(
                                  alignLabelWithHint: true,
                                  labelStyle: TextStyle(
                                    fontSize: 22.0,
                                    height: 0.9,
                                  ),
                                  labelText: "Tên hiển thị",
                                  errorText: _validate ? 'Tên hiển thị không được rỗng' : null,
                                ),
                              );
                            }),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  _validate = false;
                                });
                                Navigator.of(context).pop();
                              },
                              child: Text(
                                "HỦY",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  if (changeNameController.text == "") {
                                    _validate = true;
                                  } else
                                    _validate = false;
                                });
                                if (_validate) return;

                                ///Change username
                                FirebaseFirestore.instance.collection('users').doc(uid).update({'profileName': changeNameController.text});
                                Navigator.of(context).pop();
                              },
                              child: Text("SỬA"),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        CustomListTile(
          Icons.shield,
          "Đổi mật khẩu",
          () => showDialog<String>(
            context: context,
            builder: (BuildContext context) => StatefulBuilder(
              builder: (context, setState) {
                return AlertDialog(
                  title: const Text(
                    'Đổi mật khẩu',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  content: SingleChildScrollView(
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextField(
                            controller: oldPasswordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              alignLabelWithHint: true,
                              labelStyle: TextStyle(
                                fontSize: 22.0,
                                height: 0.9,
                              ),
                              labelText: "Mật khẩu cũ",
                              errorText: oldPasswordValidation != "" ? oldPasswordValidation : null,
                            ),
                          ),
                          TextField(
                            controller: newPasswordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              alignLabelWithHint: true,
                              labelStyle: TextStyle(
                                fontSize: 22.0,
                                height: 0.9,
                              ),
                              labelText: "Mật khẩu mới",
                              errorText: newPasswordValidation != "" ? newPasswordValidation : null,
                            ),
                          ),
                          TextField(
                            controller: confirmPasswordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              alignLabelWithHint: true,
                              labelStyle: TextStyle(
                                fontSize: 22.0,
                                height: 0.9,
                              ),
                              labelText: "Xác nhận mật khẩu mới",
                              errorText: confirmPasswordValidation != "" ? confirmPasswordValidation : null,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: () {
                                  newPasswordValidation = "";
                                  oldPasswordValidation = "";
                                  confirmPasswordValidation = "";
                                  newPasswordController.text = "";
                                  oldPasswordController.text = "";
                                  confirmPasswordController.text = "";
                                  Navigator.of(context).pop();
                                },
                                child: Text(
                                  "HỦY",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              StreamBuilder<DocumentSnapshot>(
                                stream: curUser,
                                builder: (context, snapshot) {
                                  return TextButton(
                                    onPressed: () async {
                                      if (newPasswordController.text.length < 6) {
                                        setState(() {
                                          newPasswordValidation = "Mật khẩu phải nhiều hơn 6 ký tự";
                                        });
                                        return;
                                      }
                                      else
                                        {
                                          setState(() {
                                            newPasswordValidation = "";
                                          });
                                        }

                                      if (newPasswordController.text != confirmPasswordController.text) {
                                        setState(() {
                                          confirmPasswordValidation = "Mật khẩu xác nhận không đúng";
                                        });
                                        return;
                                      }
                                      else
                                      {
                                        setState(() {
                                          confirmPasswordValidation = "";
                                        });
                                      }

                                      String? shouldNavigate = await signIn(snapshot.data!['email'], oldPasswordController.text);
                                      if (shouldNavigate != "Signed In") {
                                        setState(() {
                                          oldPasswordValidation = "Mật khẩu không đúng";
                                        });
                                        return;
                                      }
                                      else
                                      {
                                        setState(() {
                                          oldPasswordValidation = "";
                                        });
                                      }

                                      ///Change user's password
                                      //Create an instance of the current user.
                                      var user = await FirebaseAuth.instance.currentUser!;
                                      print(user);
                                      //Pass in the password to updatePassword.
                                      user.updatePassword(newPasswordController.text).then((_){
                                        print("Successfully changed password");
                                      }).catchError((error){
                                        print("Password can't be changed" + error.toString());
                                      });
                                      Navigator.of(context).pop();
                                      newPasswordController.text = "";
                                      oldPasswordController.text = "";
                                      confirmPasswordController.text = "";
                                    },
                                    child: Text("ĐỔI"),
                                  );
                                },
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        CustomListTile(Icons.logout, "Đăng xuất", () {
          signOut();
          Navigator.of(context).pushNamed(LOGIN);
        }),
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
      avatar: 'assets/images/BlueBG.png',
    ),
    Users(
      userID: "12345",
      userName: "name2",
      profileName: "Name 2",
      email: '123456@gmail.com',
      avatar: 'assets/images/BlueBG.png',
    ),
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
  late bool hasData = false;

  @override
  void initState() {
    super.initState();
    isMain = true;
  }

  @override
  Widget build(BuildContext context) {
    FirebaseAuth auth = FirebaseAuth.instance;
    String uid = auth.currentUser!.uid;
    var curUser = FirebaseFirestore.instance.collection('users').doc(uid).snapshots();
    print(uid);
    return Drawer(
      child: Column(
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 4.0, 0, 0),
              child: StreamBuilder<DocumentSnapshot>(
                  stream: curUser,
                  builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                    if (snapshot.connectionState == ConnectionState.active) {
                      // get sections from the document
                      //changeNameController.text = snapshot.data!['profileName'];
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          avatar(70, 70, Colors.grey, Image.network(snapshot.data!['avatar'])),
                          SizedBox(
                            height: 13,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(snapshot.data!['profileName'],
                                      textAlign: TextAlign.left, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                                  SizedBox(
                                    height: 6,
                                  ),
                                  Text(
                                    '@' + snapshot.data!['userName'],
                                    textAlign: TextAlign.left,
                                    style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic, color: Colors.white),
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
                      );
                    } else
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          avatar(70, 70, Colors.grey, Image.asset("assets/images/BlueBG.png")),
                          SizedBox(
                            height: 13,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("", textAlign: TextAlign.left, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                                  SizedBox(
                                    height: 6,
                                  ),
                                  Text(
                                    '@',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic, color: Colors.white),
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
                                ],
                              )
                            ],
                          ),
                        ],
                      );
                  }),
            ),
          ),
          isMain ? NavigationMain() : NavigationAccount(),
        ],
      ),
    );
  }
}
