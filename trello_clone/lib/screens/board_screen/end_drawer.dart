import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trello_clone/icons/app_icons.dart';
import 'package:trello_clone/models/boards.dart';
import 'package:trello_clone/models/user.dart';
import 'package:trello_clone/screens/navigation/Navigation.dart';
import 'package:trello_clone/widgets/reuse_widget/custom_list_tile.dart';

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
    content.add(AccountInfo("Subname1", creator, () {}));
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
      content.add(Padding(
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
          )));

    return Column(
      children: content,
    );
  }
}

class settingContent extends StatefulWidget {
  late Boards board;
  settingContent();
  @override
  settingContentState createState() => settingContentState();
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

class settingContentState extends State<settingContent> {
  late Boards board;
  late String boardName = "Đặc tả hình thức";
  late String grName = "Shop ngáo và những người bạn";
  settingContentState();

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
        enableFeedback: false,
        child: Padding(
            padding: EdgeInsets.fromLTRB(70, 18, 0, 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    boardName,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey,
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
                      color: Colors.grey,
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
      InkWell(
        enableFeedback: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(70, 18, 0, 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  grName,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey,
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
                    color: Colors.grey,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
    content.add(customDivide());

    /// Label inkwell
    content.add(
      InkWell(
        onTap: () {},
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
        onTap: () {},
        child: Padding(
          padding: EdgeInsets.fromLTRB(0, 18, 0, 15),
          child: Row(
            children: [
              Container(
                width: 70,
                decoration: BoxDecoration(
                  image: DecorationImage(image: AssetImage('assets/images/BlueBG.png'),) ,
                  shape: BoxShape.rectangle,
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
        onTap: () {},
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
}

class mainMenu extends StatefulWidget {
  Users creator;
  mainMenu(this.creator);
  @override
  mainMenuState createState() => mainMenuState(creator);
}

class mainMenuState extends State<mainMenu> {
  late int state;
  late String title = "";
  Users creator;

  mainMenuState(this.creator);

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
                              setState(() {
                                state = 0;
                              });
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
                  else if (state == 4)
                    settingContent()
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
                  CustomListTile(Icons.delete, "Xóa bảng", () {}),
                  CustomListTile(Icons.settings, "Thiết lập bảng", () {
                    setState(() {
                      state = 4;
                    });
                  }),
                ],
              ));
  }
}
