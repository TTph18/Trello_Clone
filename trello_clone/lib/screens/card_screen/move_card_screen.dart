import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trello_clone/models/boards.dart';
import 'package:trello_clone/models/workspaces.dart';
import 'package:trello_clone/screens/card_screen/board_item.dart';
import 'package:trello_clone/services/database.dart';

class MoveCardScreen extends StatefulWidget {
  @override
  MoveCardScreenState createState() => MoveCardScreenState();
}

class MoveCardScreenState extends State<MoveCardScreen> {
  Boards nullBr = new Boards(
      boardID: "",
      userList: [],
      boardName: "",
      createdBy: "",
      background: "",
      isPersonal: false,
      workspaceID: "");
  late Boards selectedBoard = nullBr;
  late List<Workspaces> group = [];
  List<BoardItem> boardItems = [];
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
            ///Board selection
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: ButtonTheme(
                child: FutureBuilder(
                    future: DatabaseService.getUserWorkspaceList(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (!snapshot.hasData) {
                        return Container(
                            alignment: FractionalOffset.center,
                            child: CircularProgressIndicator());
                      } else {
                        group.clear();
                        for (var item in snapshot.data) {
                          Workspaces _wp = Workspaces.fromDocument(item);
                          group.add(_wp);
                        }
                      }
                      return FutureBuilder(
                          future: DatabaseService.getAllBoards(),
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            if (!snapshot.hasData) {
                              return Container(
                                  alignment: FractionalOffset.center,
                                  child: CircularProgressIndicator());
                            } else {
                              boardItems.clear();
                              for (var _item in group) {
                                boardItems.add(new BoardItem(
                                    wpname: _item.workspaceName,
                                    type: "sep",
                                    boards: nullBr));
                                for (var item in snapshot.data) {
                                  Boards _br = Boards.fromDocument(item);
                                  if (_item.workspaceID == _br.workspaceID) {
                                    boardItems.add(new BoardItem(
                                        wpname: _item.workspaceName,
                                        type: "data",
                                        boards: _br));
                                  }
                                }
                              }
                            }
                            return DropdownButtonFormField<String>(
                                icon: Icon(Icons.keyboard_arrow_down),
                                hint: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Chọn bảng",
                                    style: TextStyle(fontSize: 20.0),
                                  ),
                                ),
                                decoration: InputDecoration(
                                  labelStyle:
                                  TextStyle(fontSize: 18.0, height: 0.9),
                                  labelText: "Bảng",
                                  floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                                  contentPadding: EdgeInsets.only(bottom: 0),
                                ),
                                onChanged: (value) {
                                  if (boardItems[boardItems.indexWhere(
                                          (element) =>
                                      element.boards.boardID ==
                                          value)]
                                      .type ==
                                      "sep") {
                                    return;
                                  }
                                  setState(() {
                                    selectedBoard = (boardItems[
                                    boardItems.indexWhere((element) =>
                                    element.boards.boardID == value)]
                                        .boards);
                                  });
                                },
                                selectedItemBuilder: (BuildContext context) {
                                  return boardItems.map((BoardItem item) {
                                    return Text(
                                      selectedBoard.boardName,
                                      style: TextStyle(
                                        fontSize: 20.0,
                                      ),
                                    );
                                  }).toList();
                                },
                                items: boardItems == null
                                ? []
                                    : boardItems.map((BoardItem item) {
                              return DropdownMenuItem(
                                value: item.boards.boardID,
                                onTap:
                                item.type == "data" ? () {} : null,
                                child: item.type == "data"
                                    ? Container(
                                  padding: EdgeInsets.fromLTRB(
                                      15, 7, 15, 7),
                                  child: Row(
                                    children: [
                                      Container(
                                        padding:
                                        EdgeInsets.fromLTRB(
                                            0, 0, 15, 0),
                                        child: ClipRRect(
                                          borderRadius:
                                          BorderRadius
                                              .circular(3.0),
                                          child: Image(
                                            image: AssetImage(
                                                "assets/images/BlueBG.png"),
                                            width: 50,
                                            height: 50,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        item.boards.boardName,
                                        style: TextStyle(
                                            fontSize: 20),
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
                                          width: 1.0,
                                          color: Colors.black),
                                      bottom: BorderSide(
                                          width: 1.0,
                                          color: Colors.black),
                                    ),
                                  ),
                                  child: Align(
                                    alignment:
                                    Alignment.centerLeft,
                                    child: Text(
                                      item.wpname,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight:
                                        FontWeight.normal,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                            );
                          });
                    }),
              ),
            ),
            SizedBox(
              height: 20,
            ),

            SizedBox(
              height: 20,
            ),

          ],
        ),
      ),
    );
  }
}
