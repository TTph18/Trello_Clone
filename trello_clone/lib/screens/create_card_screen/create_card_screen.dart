import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:trello_clone/icons/app_icons.dart';
import 'package:trello_clone/models/user.dart';
import '../../route_path.dart';

class CreateCardScreen extends StatefulWidget {
  @override
  CreateCardScreenState createState() => CreateCardScreenState();
}

class BoardItem {
  String name;
  String type;

  BoardItem({required this.name, required this.type});
}

class CreateCardScreenState extends State<CreateCardScreen> {
  final formKey = GlobalKey<FormState>();
  String selectedBoard = "";
  List<String> groupName = ["Tên nhóm 1", "Tên nhóm 2", "Tên nhóm 3"];
  List<BoardItem> boardItems = [
    BoardItem(name: "Tên nhóm 1", type: "sep"),
    BoardItem(name: "Tên bảng 1 nhóm 1", type: "data"),
    BoardItem(name: "Tên bảng 2 nhóm 1", type: "data"),
    BoardItem(name: "Tên nhóm 2", type: "sep"),
    BoardItem(name: "Tên bảng 1 nhóm 2", type: "data"),
    BoardItem(name: "Tên bảng 2 nhóm 2", type: "data"),
    BoardItem(name: "Tên bảng 3 nhóm 2", type: "data"),
    BoardItem(name: "Tên bảng 4 nhóm 2", type: "data"),
    BoardItem(name: "Tên nhóm 3", type: "sep"),
    BoardItem(name: "Tên bảng 1 nhóm 3", type: "data"),
    BoardItem(name: "Tên bảng 2 nhóm 3", type: "data"),
    BoardItem(name: "Tên bảng 3 nhóm 3", type: "data"),
  ];

  List<String> boardList = ["Tên bảng 1", "Tên bảng 2", "Tên bảng 3"];
  String? selectedList = "";
  List<String> listList = [
    "Tên danh sách 1",
    "Tên danh sách 2",
    "Tên danh sách 3"
  ];
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

  List<Users> pickedUsers = [];

  var cardNameTxtCtrl = TextEditingController();
  var descriptionTxtCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
          title: Text('Thêm thẻ'),
          leading: Builder(builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                Navigator.of(context).pushNamed(MAIN_SCREEN);
              },
            );
          }),
          actions: [
            IconButton(
              icon: const Icon(Icons.check),
              onPressed: () {},
            ),
          ]),
      body: Form(
        key: formKey,
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 20,
            ),

            ///Board selection
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: ButtonTheme(
                child: DropdownButtonFormField<String>(
                  icon: Icon(Icons.keyboard_arrow_down),
                  hint: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Chọn bảng",
                      style: TextStyle(fontSize: 20.0),
                    ),
                  ),
                  decoration: InputDecoration(
                    labelStyle: TextStyle(fontSize: 18.0, height: 0.9),
                    labelText: "Bảng",
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    contentPadding: EdgeInsets.only(bottom: 0),
                  ),
                  onChanged: (value) {
                    if (value != null)
                      print("VALUE: " + value);
                    else
                      print("NOT VALUE");
                    if (boardItems[boardItems
                                .indexWhere((element) => element.name == value)]
                            .type ==
                        "sep") {
                      return;
                    }
                    setState(() {
                      if (value != null) selectedBoard = value;
                    });
                  },
                  selectedItemBuilder: (BuildContext context) {
                    return boardItems.map((BoardItem item) {
                      return Text(
                        selectedBoard,
                        style: TextStyle(
                          fontSize: 20.0,
                        ),
                      );
                    }).toList();
                  },
                  items: boardItems.map((BoardItem item) {
                    return DropdownMenuItem(
                      value: item.name,
                      onTap: item.type == "data" ? () {} : null,
                      child: item.type == "data"
                          ? Container(
                              padding: EdgeInsets.fromLTRB(15, 7, 15, 7),
                              child: Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.fromLTRB(0, 0, 15, 0),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(3.0),
                                      child: Image(
                                        image: AssetImage(
                                            "assets/images/BlueBG.png"),
                                        width: 50,
                                        height: 50,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    item.name,
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ],
                              ),
                            )
                          : Container(
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border(
                                  top: BorderSide(
                                      width: 1.0, color: Colors.black),
                                  bottom: BorderSide(
                                      width: 1.0, color: Colors.black),
                                ),
                              ),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  item.name,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                    );
                  }).toList(),
                ),
              ),
            ),

            ///Card list selection
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
              child: DropdownButtonFormField<String>(
                icon: Icon(Icons.keyboard_arrow_down),
                hint: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Chọn danh sách",
                    style: TextStyle(fontSize: 20.0),
                  ),
                ),
                decoration: InputDecoration(
                  labelStyle: TextStyle(fontSize: 18.0, height: 0.9),
                  labelText: "Danh sách",
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  contentPadding: EdgeInsets.only(bottom: 0),
                ),
                onChanged: selectedBoard == ""
                    ? null
                    : (value) {
                        setState(() {
                          selectedList = value;
                        });
                      },
                selectedItemBuilder: (BuildContext context) {
                  return listList.map<Widget>((String item) {
                    return Text(
                      item,
                      style: TextStyle(
                        fontSize: 20.0,
                      ),
                    );
                  }).toList();
                },
                items: listList.map((String item) {
                  return DropdownMenuItem<String>(
                      value: item,
                      child: Row(
                        children: [
                          Text(item, style: TextStyle(fontSize: 20.0)),
                        ],
                      ));
                }).toList(),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/BlueBG.png"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  color: Colors.white,
                  child: Column(
                    children: [
                      ///Card name
                      TextFormField(
                        controller: cardNameTxtCtrl,
                        decoration: InputDecoration(
                          alignLabelWithHint: true,
                          labelStyle: TextStyle(
                            fontSize: 22.0,
                            height: 0.9,
                          ),
                          labelText: "Tên thẻ",
                          contentPadding: EdgeInsets.only(bottom: 5),
                        ),
                        style: TextStyle(fontSize: 22.0),

                        // The validator receives the text that the user has entered.
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Tên thẻ không được để trống';
                          }
                          return null;
                        },
                      ),

                      ///Description
                      TextFormField(
                        controller: descriptionTxtCtrl,
                        decoration: InputDecoration(
                          alignLabelWithHint: true,
                          labelStyle: TextStyle(
                            fontSize: 22.0,
                            height: 0.9,
                          ),
                          labelText: "Mô tả",
                          contentPadding: EdgeInsets.only(top: 20, bottom: 5),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: const BorderSide(color: Colors.black),
                          ),
                        ),
                        style: TextStyle(fontSize: 22.0),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: Column(
                          children: [
                            ///Members here
                            selectedBoard == ""
                                ? SizedBox()
                                : Row(
                                    children: [
                                      IconButton(
                                        icon: Icon(MyFlutterApp.person_outline),
                                        alignment: Alignment.centerLeft,
                                        onPressed: () {},
                                      ),
                                      Container(
                                        alignment: Alignment.centerLeft,
                                        child: CircleAvatar(
                                            radius: 25,
                                            backgroundColor: Colors.green,
                                            child: PopupMenuButton<Users>(
                                              itemBuilder: (context) =>
                                                  List.generate(
                                                users.length,
                                                (index) => PopupMenuItem<Users>(
                                                  value: users[index],
                                                  child: ListTile(
                                                    leading: CircleAvatar(
                                                      radius: 25,
                                                      backgroundImage:
                                                          AssetImage(
                                                              users[index]
                                                                  .avatar),
                                                    ),
                                                    title: Text(
                                                        '${users[index].userName}'),
                                                  ),
                                                ),
                                              ),
                                              onSelected: (value) {
                                                setState(() {
                                                  pickedUsers.add(value);
                                                  print("Length = " +
                                                      pickedUsers.length
                                                          .toString());
                                                });
                                              },
                                              icon: Icon(
                                                Icons.add,
                                                color: Colors.white,
                                                size: 18,
                                              ),
                                            )),
                                      ),
                                      pickedUsers.length < 1
                                          ? SizedBox()
                                          : Container(
                                              height: 50,
                                              child: SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.5,
                                                child: ListView.builder(
                                                    shrinkWrap: true,
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    itemCount:
                                                        pickedUsers.length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      return CircleAvatar(
                                                        radius: 25,
                                                        backgroundImage:
                                                            AssetImage(
                                                                pickedUsers[
                                                                        index]
                                                                    .avatar),
                                                      );
                                                    }),
                                              ),
                                            ),
                                    ],
                                  ),

                            ///DateStart
                            Row(
                              children: [
                                IconButton(
                                  icon: Icon(MyFlutterApp.clock),
                                  alignment: Alignment.centerLeft,
                                  onPressed: () {},
                                ),
                                TextButton(
                                  onPressed: () {},
                                  child: Text("Ngày bắt đầu...",
                                      style: TextStyle(
                                          fontSize: 18.0,
                                          color: Colors.black87)),
                                  style: ButtonStyle(
                                    alignment: Alignment.bottomLeft,
                                    overlayColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.white),
                                  ),
                                ),
                              ],
                            ),

                            ///DateEnd
                            Row(
                              children: [
                                SizedBox(
                                  width: 48,
                                ),
                                TextButton(
                                  onPressed: () {},
                                  child: Text("Ngày hết hạn...",
                                      style: TextStyle(
                                          fontSize: 18.0,
                                          color: Colors.black87)),
                                  style: ButtonStyle(
                                    alignment: Alignment.centerLeft,
                                    overlayColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
