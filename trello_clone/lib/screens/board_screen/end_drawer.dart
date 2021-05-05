import 'package:flutter/material.dart';
import 'package:trello_clone/icons/app_icons.dart';
import 'package:trello_clone/widgets/reuse_widget/custom_list_tile.dart';

class mainList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 24,
        ),
        CustomListTile(Icons.info_outline, "Về bảng này", () {}),
        CustomListTile(MyFlutterApp.person_outline, "Thành viên", () {}),
        CustomListTile(Icons.list, "Hoạt động", () {}),
        Divider(),
        CustomListTile(Icons.credit_card, "Lưu trữ thẻ", () {}),
        CustomListTile(Icons.view_column, "Lưu trữ danh sách", () {}),
        CustomListTile(Icons.settings, "Cài đặt bảng", () {}),
      ],
    );
  }
}

class mainMenu extends StatefulWidget {
  @override
  mainMenuState createState() => mainMenuState();
}

class mainMenuState extends State<mainMenu> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: mainList()
    );
  }
}

