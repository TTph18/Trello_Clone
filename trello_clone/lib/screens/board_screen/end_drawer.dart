import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_chips_input/flutter_chips_input.dart';
import 'package:trello_clone/icons/app_icons.dart';
import 'package:trello_clone/models/boards.dart';
import 'package:trello_clone/models/user.dart';
import 'package:trello_clone/models/workspaces.dart';
import 'package:trello_clone/screens/board_screen/change_background_screen.dart';
import 'package:trello_clone/screens/board_screen/change_workspace.dart';
import 'package:trello_clone/screens/main_screen/main_screen.dart';
import 'package:trello_clone/screens/navigation/Navigation.dart';
import 'package:trello_clone/services/database.dart';
import 'package:trello_clone/widgets/reuse_widget/avatar.dart';
import 'package:trello_clone/widgets/reuse_widget/custom_list_tile.dart';

import '../../route_path.dart';

class inforContent extends StatefulWidget {
  late Users creator;
  late String description;
  inforContent(this.creator, this.description);
  @override
  inforContentState createState() => inforContentState(creator, description);
}

class inforContentState extends State<inforContent> {
  late Users creator;
  late String description;
  late bool isTypingDescription;

  inforContentState(this.creator, this.description);

  @override
  void initState() {
    super.initState();
    isTypingDescription = false;
  }

  @override
  Widget build(BuildContext context) {
    var content = <Widget>[];
    content.add(Padding(
        padding: EdgeInsets.fromLTRB(10, 20, 0, 5),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "Người tạo",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        )));
    content.add(AccountInfo(creator.profileName, creator, () {}));
    content.add(
      Padding(
        padding: EdgeInsets.fromLTRB(10, 20, 0, 5),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "Mô tả",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
    if (!isTypingDescription) if (description == "")
      content.add(InkWell(
          onTap: () {
            setState(() {
              isTypingDescription = true;
            });
          },
          child: Padding(
              padding: EdgeInsets.fromLTRB(10, 5, 5, 5),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Đã đến lúc bảng của bạn tỏa sáng! Hãy để mọi người biết rằng bảng này được sử dụng để làm gì và họ có thể kì vọng được thấy những gì.",
                  style: TextStyle(fontSize: 15, color: Colors.grey),
                ),
              ))));
    else
      content.add(InkWell(
          onTap: () {
            setState(() {
              isTypingDescription = true;
            });
          },
          child: Padding(
              padding: EdgeInsets.fromLTRB(10, 5, 0, 5),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  description,
                  style: TextStyle(fontSize: 18, color: Colors.black),
                ),
              ))));
    else
      content.add(
        Padding(
          padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
          child: TextField(
            autofocus: true,
            style: TextStyle(fontSize: 18, color: Colors.black),
            decoration: InputDecoration(
              border: new UnderlineInputBorder(),
            ),
            onSubmitted: (String desContent) {
              setState(() {
                description = desContent;
                isTypingDescription = false;
              });
            },
          ),
        ),
      );

    return Column(
      children: content,
    );
  }
}

Widget customDivide() {
  return Padding(
    padding: EdgeInsets.fromLTRB(70, 0, 0, 0),
    child: Divider(
      height: 2,
      color: Colors.black,
    ),
  );
}

Widget customColorInkWell(Labels labels, BuildContext context) {
  return InkWell(
    onTap: () {
      showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return LabelDetailModalBottom(false, labels);
        },
        isScrollControlled: true,
      );
    },
    child: Ink(
      child: Container(
        height: 40,
        width: double.infinity,
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Color(int.parse(labels.color)),
          ),
          child: Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                child: Text(
                  labels.labelName,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.left,
                ),
              )),
        ),
      ),
    ),
  );
}

Widget LabelDetailModalBottom(bool isCreate, Labels label) {
  TextEditingController mycontroller = TextEditingController();
  mycontroller.value = new TextEditingValue(text: label.labelName);
  String title = "Nhãn mới";
  if (!isCreate) title = "Sửa nhãn";
  List<Labels> labelColors = [
    Labels(color: "0xff61bd4f", labelName: ""),
    Labels(color: "0xfff2d600", labelName: ""),
    Labels(color: "0xffffab4a", labelName: ""),
    Labels(color: "0xffeb5a46", labelName: ""),
    Labels(color: "0xffc377e0", labelName: ""),
    Labels(color: "0xff0079bf", labelName: ""),
    Labels(color: "0xff00c2e0", labelName: ""),
    Labels(color: "0xff51e898", labelName: ""),
    Labels(color: "0xffff80ce", labelName: ""),
    Labels(color: "0xff355263", labelName: ""),
    Labels(color: "0xffb3bec4", labelName: ""),
  ];

  String labelSelectedColor = label.color;
  return StatefulBuilder(
    builder: (BuildContext context, StateSetter mystate) {
      return Padding(
        padding: EdgeInsets.all(20),
        child: Container(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  title,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                controller: mycontroller,
                decoration: InputDecoration(
                  hintText: "Tên nhãn…",
                  hintStyle: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                child: GridView.count(
                  shrinkWrap: true,
                  primary: false,
                  padding: const EdgeInsets.all(4),
                  childAspectRatio: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  crossAxisCount: 4,
                  children: List.generate(
                    labelColors.length,
                    (index) {
                      return Ink(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          color: Color(int.parse(labelColors[index].color)),
                        ),
                        child: labelColors[index].color == labelSelectedColor
                            ? Container(
                                alignment: Alignment.center,
                                child: Icon(
                                  Icons.check,
                                  size: 30,
                                  color: Colors.white,
                                ),
                              )
                            : InkWell(
                                onTap: () {
                                  mystate(
                                    () {
                                      labelSelectedColor =
                                          labelColors[index].color;
                                    },
                                  );
                                },
                              ),
                      );
                    },
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              isCreate
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            "HỦY",
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            if (isCreate) {
                              ///TODO: Create new label if text field contain text
                            } else {
                              ///TODO: Edit label
                            }
                            Navigator.pop(context);
                          },
                          child: Text(
                            "HOÀN THÀNH",
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () {
                            ///TODO: Delete label info
                            Navigator.pop(context);
                          },
                          child: Text(
                            "XÓA",
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                "HỦY",
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                if (isCreate) {
                                  ///TODO: Create new label if text field contain text
                                } else {
                                  ///TODO: Edit label
                                }
                                Navigator.pop(context);
                              },
                              child: Text(
                                "HOÀN THÀNH",
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
            ],
          ),
        ),
      );
    },
  );
}

class settingContent extends StatefulWidget {
  late Boards board;
  settingContent(this.board);
  @override
  settingContentState createState() => settingContentState(board);
}

class settingContentState extends State<settingContent> {
  TextEditingController mycontroller = TextEditingController();
  late Boards board;
  late Workspaces workspace;
  late String boardName = "Đặc tả hình thức";
  late String grName = "Shop ngáo và những người bạn";
  List<Labels> currentLabels = [
    new Labels(color: "0xff61bd4f", labelName: ""),
    new Labels(color: "0xfff2d600", labelName: ""),
    new Labels(color: "0xffffab4a", labelName: ""),
    new Labels(color: "0xffeb5a46", labelName: ""),
    new Labels(color: "0xffc377e0", labelName: ""),
    new Labels(color: "0xff0079bf", labelName: ""),
  ];
  settingContentState(this.board);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var content = <Widget>[];

    /// Board name inkwell
    content.add(
      InkWell(
        onTap: () {
          mycontroller.value = new TextEditingValue(text: board.boardName);
          showDialog<String>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: const Text(
                'Tên',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              content: Container(
                width: MediaQuery.of(context).size.width * 0.8,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: mycontroller,
                      decoration: InputDecoration(
                        hintStyle: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          child: Text(
                            'HỦY',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        TextButton(
                          child: Text(
                            'HOÀN THÀNH',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              builder: (BuildContext bc) {
                                return LabelDetailModalBottom(true,
                                    Labels(color: "0xffb3bec4", labelName: ""));
                              },
                              isScrollControlled: true,
                            );
                          },
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        enableFeedback: false,
        child: Padding(
            padding: EdgeInsets.fromLTRB(70, 18, 0, 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    board.boardName,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ),
                SizedBox(
                  height: 2,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Tên",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
    content.add(customDivide());

    /// Group name inkwell
    content.add(
      FutureBuilder(
          future: DatabaseService.getWorkspaceData(board.workspaceID),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              Workspaces wp = Workspaces.fromDocument(snapshot.data);
              workspace = wp;
            } else {
              return Container(
                  alignment: FractionalOffset.center,
                  child: CircularProgressIndicator());
            }
            return InkWell(
              onTap: () {
                Route route = MaterialPageRoute(
                    builder: (context) => ChangeWorkspace(workspace, board));
                Navigator.push(context, route);
              },
              enableFeedback: false,
              child: Padding(
                padding: EdgeInsets.fromLTRB(70, 18, 0, 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        workspace.workspaceName,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 15,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.visible,
                      ),
                    ),
                    SizedBox(
                      height: 2,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Không gian làm việc",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
    content.add(customDivide());

    /// Label inkwell
    content.add(
      InkWell(
        onTap: () => showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text(
              'Chỉnh sửa nhãn',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            content: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: CreateBody(),
              ),
            ),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(70, 18, 0, 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Chỉnh sửa nhãn",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.visible,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
    content.add(customDivide());

    /// Background inkwell
    content.add(
      InkWell(
        onTap: () {
          Route route = MaterialPageRoute(
              builder: (context) => ChangeBackgroundScreen(board));
          Navigator.push(context, route);
        },
        child: Padding(
          padding: EdgeInsets.fromLTRB(0, 18, 0, 15),
          child: Row(
            children: [
              Container(
                width: 70,
                height: 20,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/BlueBG.png'),
                  ),
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Phông nền",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.visible,
                ),
              ),
            ],
          ),
        ),
      ),
    );
    content.add(customDivide());

    /// Background inkwell
    content.add(
      InkWell(
        onTap: () => showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text(
              'Rời khỏi bảng',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            content: Text(
                "Bạn có chắc muốn rời khỏi bảng này không? Bạn có thể sẽ không được tham gia bảng sau này."),
            actions: [
              TextButton(
                child: Text('HỦY',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text(
                  'RỜI BỎ',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                onPressed: () {
                  /// TODO: delete user from board
                  Route route =
                      MaterialPageRoute(builder: (context) => MainScreen());
                  Navigator.push(context, route);
                },
              )
            ],
          ),
        ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(70, 18, 0, 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Rời khỏi bảng",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.visible,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    return Column(
      children: content,
    );
  }

  List<Widget> CreateBody() {
    var content = <Widget>[];
    for (int i = 0; i < currentLabels.length; i++) {
      content.add(
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 4),
          child: customColorInkWell(
            currentLabels[i],
            context,
          ),
        ),
      );
    }

    content.add(
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
            child: Text(
              'HOÀN TẤT',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text(
              'TẠO NHÃN MỚI',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (BuildContext bc) {
                  return LabelDetailModalBottom(
                      true, Labels(color: "0xffb3bec4", labelName: ""));
                },
                isScrollControlled: true,
              );
            },
          )
        ],
      ),
    );
    return content;
  }
}

class memberContent extends StatefulWidget {
  late Boards board;
  memberContent(this.board);
  @override
  memberContentState createState() => memberContentState(board);
}

class memberContentState extends State<memberContent> {
  final _chipKey = GlobalKey<ChipsInputState>();
  List<Users> users = [
    Users(
      userID: "12345",
      userName: "name1",
      profileName: "Name 1",
      email: '123456@gmail.com',
      avatar: 'assets/images/BlueBG.png',
      workspaceList: [],
    ),
    Users(
      userID: "12345",
      userName: "name2",
      profileName: "Name 2",
      email: '123456@gmail.com',
      avatar: 'assets/images/BlueBG.png',
      workspaceList: [],
    ),
    Users(
      userID: "12345",
      userName: "name3",
      profileName: "Name 3",
      email: '123456@gmail.com',
      avatar: 'assets/images/BlueBG.png',
      workspaceList: [],
    ),
    Users(
      userID: "12345",
      userName: "Test4",
      profileName: "Cun cun cute",
      email: '123456@gmail.com',
      avatar: 'assets/images/BlueBG.png',
      workspaceList: [],
    ),
  ];
  GlobalKey key = GlobalKey();
  late Boards board;
  late List<Users> userList = [];
  memberContentState(this.board);



  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: DatabaseService.getListUserData(board.userList),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return Container(
                alignment: FractionalOffset.center,
                child: CircularProgressIndicator());
          }
          for (DocumentSnapshot item in snapshot.data) {
            Users _user = Users.fromDocument(item);
            userList.add(_user);
          }
          return Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height - 72,
                child: ListView(
                  children: [
                    Column(
                      children: List.generate(userList.length, (int index) {
                        return Column(
                          children: [
                            InkWell(
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    16.0, 14.0, 0, 14.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        avatar(
                                          40,
                                          40,
                                          Colors.grey,
                                          Image.network(
                                            userList[index].avatar,
                                            width: 40,
                                            height: 40,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 20,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                  userList[index].userName,
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                            ),
                                            Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                '@' +
                                                    userList[index].profileName,
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontStyle:
                                                        FontStyle.italic),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    IconButton(
                                        onPressed: () {
                                          ///TODO: delete this user form board
                                        },
                                        icon: Icon(Icons.close)),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(70, 0, 0, 0),
                              child: Divider(
                                height: 1,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        );
                      }),
                    ),
                  ],
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height - 85,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: FloatingActionButton.extended(
                          key: key,
                          onPressed: () {
                            showDialog<String>(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                title: const Text(
                                  'Thêm thành viên',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SingleChildScrollView(
                                      child: Column(
                                        children: <Widget>[
                                          ChipsInput(
                                            key: _chipKey,
                                            keyboardAppearance: Brightness.dark,
                                            textCapitalization:
                                                TextCapitalization.words,
                                            // maxChips: 5,
                                            textStyle: const TextStyle(
                                                height: 1.5, fontSize: 20),
                                            decoration: const InputDecoration(
                                              // hintText: formControl.hint,
                                              labelText: 'Tài khoản hoặc email',
                                            ),
                                            findSuggestions: (String query) {
                                              print("Query: '$query'");
                                              if (query.isNotEmpty) {
                                                var lowercaseQuery =
                                                    query.toLowerCase();
                                                return users.where((profile) {
                                                  return profile.userName
                                                          .toLowerCase()
                                                          .contains(query
                                                              .toLowerCase()) ||
                                                      profile.email
                                                          .toLowerCase()
                                                          .contains(query
                                                              .toLowerCase());
                                                }).toList(growable: false)
                                                  ..sort((a, b) => a.userName
                                                      .toLowerCase()
                                                      .indexOf(lowercaseQuery)
                                                      .compareTo(b.userName
                                                          .toLowerCase()
                                                          .indexOf(
                                                              lowercaseQuery)));
                                              }
                                              return users;
                                            },
                                            onChanged: (data) {
                                              // print(data);
                                            },
                                            chipBuilder: (context, state,
                                                dynamic profile) {
                                              return InputChip(
                                                key: ObjectKey(profile),
                                                label: Text(profile.userName),
                                                avatar: CircleAvatar(
                                                  backgroundImage: AssetImage(
                                                      profile.avatar),
                                                ),
                                                onDeleted: () =>
                                                    state.deleteChip(profile),
                                                materialTapTargetSize:
                                                    MaterialTapTargetSize
                                                        .shrinkWrap,
                                              );
                                            },
                                            suggestionBuilder: (context, state,
                                                dynamic profile) {
                                              return ListTile(
                                                key: ObjectKey(profile),
                                                leading: CircleAvatar(
                                                  backgroundImage: AssetImage(
                                                      profile.avatar),
                                                ),
                                                title: Text(profile.userName),
                                                onTap: () => state
                                                    .selectSuggestion(profile),
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                    child: Text('HỦY',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16)),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  TextButton(
                                    child: Text(
                                      'THÊM',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                    onPressed: () {
                                      ///TODO: Add user in chip to board
                                    },
                                  )
                                ],
                              ),
                            );
                          },
                          label: const Text('THÊM THÀNH VIÊN'),
                          icon: const Icon(Icons.group_add),
                          backgroundColor: Colors.green,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        });
  }
}

class mainMenu extends StatefulWidget {
  Users creator;
  Boards board;
  mainMenu(this.creator, this.board);
  @override
  mainMenuState createState() => mainMenuState(creator, board);
}

class mainMenuState extends State<mainMenu> {
  late int state;
  late String title = "";
  Users creator;
  Boards board;

  mainMenuState(this.creator, this.board);

  @override
  void initState() {
    super.initState();
    state = 0;
  }

  @override
  Widget build(BuildContext context) {
    switch (state) {
      case 1:
        title = "Về bảng này";
        break;
      case 2:
        title = "Thành viên";
        break;
      case 4:
        title = "Thiết lập bảng";
        break;
    }
    return Drawer(
      child: state != 0
          ? Column(
              children: [
                /// Header
                SizedBox(
                  height: 24,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(244, 245, 247, 1.0),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: Colors.black45,
                        spreadRadius: 1.0,
                        blurRadius: 2.0,
                        offset: Offset(2, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            setState(
                              () {
                                state = 0;
                              },
                            );
                          },
                          icon: Icon(Icons.arrow_back_outlined)),
                      Text(
                        title,
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                ),

                /// Body
                if (state == 1)
                  inforContent(creator, "")
                else if (state == 2)
                  memberContent(board)
                else if (state == 4)
                  settingContent(board)
              ],
            )
          : Column(
              children: [
                SizedBox(
                  height: 24,
                ),
                CustomListTile(Icons.info_outline, "Về bảng này", () {
                  setState(() {
                    state = 1;
                  });
                }),
                CustomListTile(MyFlutterApp.person_outline, "Thành viên", () {
                  setState(() {
                    state = 2;
                  });
                }),
                Divider(),
                CustomListTile(
                  Icons.delete,
                  "Xóa bảng",
                  () {
                    ///TODO: process to delete board
                    Navigator.of(context).pushNamed(MAIN_SCREEN);
                  },
                ),
                CustomListTile(
                  Icons.settings,
                  "Thiết lập bảng",
                  () {
                    setState(
                      () {
                        state = 4;
                      },
                    );
                  },
                ),
              ],
            ),
    );
  }
}
