import 'package:flutter/material.dart';
import 'package:trello_clone/icons/app_icons.dart';
import 'package:trello_clone/models/user.dart';
import 'package:trello_clone/screens/navigation/Navigation.dart';
import 'package:trello_clone/widgets/reuse_widget/custom_list_tile.dart';

class inforContent extends StatelessWidget{
  late Users creater;
  late String description;
  inforContent(this.creater, this.description);
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
    content.add(AccountInfo("Subname1",creater, () {}));
    content.add(Padding(
        padding: EdgeInsets.fromLTRB(10, 20, 0, 5),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "Mô tả",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        )));
    if (description == "")
      content.add(Padding(
          padding: EdgeInsets.fromLTRB(10, 5, 0, 5),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Đã đến lúc bảng của bạn tỏa sáng! Hãy để mọi người biết rằng bảng này được sử dụng để làm gì và họ có thể kì vọng được thấy những gì.",
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          )));
    else
      content.add(Padding(
          padding: EdgeInsets.fromLTRB(10, 5, 0, 5),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              description,
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
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
