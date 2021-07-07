import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trello_clone/screens/card_screen/board_item.dart';

class MoveCardScreen extends StatefulWidget {
  @override
  MoveCardScreenState createState() => MoveCardScreenState();
}

class MoveCardScreenState extends State<MoveCardScreen> {
  String selectedBoard = "";
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close,),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text("Di chuyển thẻ"),
        actions: [
          IconButton(
              onPressed: () {
                ///TODO: Move card
              },
              icon: Icon(Icons.check)),
        ],
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 20,
            ),
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
            SizedBox(
              height: 20,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: ButtonTheme(
                child: DropdownButtonFormField<String>(
                  icon: Icon(Icons.keyboard_arrow_down),
                  hint: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Danh sách",
                      style: TextStyle(fontSize: 20.0),
                    ),
                  ),
                  decoration: InputDecoration(
                    labelStyle: TextStyle(fontSize: 18.0, height: 0.9),
                    labelText: "Danh sách",
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
            SizedBox(
              height: 20,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: ButtonTheme(
                child: DropdownButtonFormField<String>(
                  icon: Icon(Icons.keyboard_arrow_down),
                  hint: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Vị trí",
                      style: TextStyle(fontSize: 20.0),
                    ),
                  ),
                  decoration: InputDecoration(
                    labelStyle: TextStyle(fontSize: 18.0, height: 0.9),
                    labelText: "Vị trí",
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
          ],
        ),
      ),
    );
  }
}
