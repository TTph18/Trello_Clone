import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trello_clone/icons/app_icons.dart';
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
    content.add(Padding(
        padding: EdgeInsets.fromLTRB(10, 20, 0, 5),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "Mô tả",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        )));
    if (!isTypingDescription) if (description == "")
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
                  "Đã đến lúc bảng của bạn tỏa sáng! Hãy để mọi người biết rằng bảng này được sử dụng để làm gì và họ có thể kì vọng được thấy những gì.",
                  style: TextStyle(fontSize: 18, color: Colors.grey),
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
                  if (state == 1) inforContent(creator, "")
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
                  CustomListTile(Icons.settings, "Cài đặt bảng", () {}),
                ],
              ));
  }
}
