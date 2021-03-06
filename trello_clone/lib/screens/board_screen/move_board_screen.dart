import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trello_clone/models/boards.dart';
import 'package:trello_clone/models/lists.dart';
import 'package:trello_clone/models/workspaces.dart';
import 'package:trello_clone/screens/card_screen/board_item.dart';
import 'package:trello_clone/services/database.dart';

class MoveBoardScreen extends StatefulWidget {
  Boards board;
  Lists list;
  MoveBoardScreen(this.board, this.list);
  @override
  MoveBoardScreenState createState() => MoveBoardScreenState(board, list);
}

class MoveBoardScreenState extends State<MoveBoardScreen> {
  Boards nullBr = new Boards(
      boardID: "",
      userList: [],
      boardName: "",
      createdBy: "",
      background: "",
      isPersonal: false,
      workspaceID: "",
      listNumber: 0, cardNumber: 0, description: "");

  late Boards selectedBoard;
  late Lists selectedList = new Lists(
      listID: "", listName: "", position: 0, cardList: [], cardNumber: 0);
  late List<Workspaces> group = [];

  ///TODO: get current board to show in dropdownlist
  late Boards currentBoard;
  late Lists currentList = currentList;
  List<BoardItem> boardItems = [];
  int selectedPos = 0;
  List<Lists> listPos = [];
  MoveBoardScreenState(this.currentBoard, this.currentList);
  @override
  void initState() {
    super.initState();
    selectedList = currentList;
    selectedBoard = currentBoard;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.close,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text("Di chuyển danh sách"),
        actions: [
          IconButton(
              onPressed: () {
                if (!(selectedBoard == currentBoard)) {
                  DatabaseService.moveListToABoard(
                      currentBoard.boardID, selectedBoard.boardID, currentList);
                  Navigator.of(context).pop();
                }
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
                child: StreamBuilder(
                    stream: DatabaseService.streamWorkspaces(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (!snapshot.hasData) {
                        return Container(
                            alignment: FractionalOffset.center,
                            child: CircularProgressIndicator());
                      } else {
                        group = snapshot.data;
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
                            currentBoard = boardItems[0].boards;
                            return DropdownButtonFormField<String>(
                              icon: Icon(Icons.keyboard_arrow_down),
                              //value: currentBoard.boardName.toString(),
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
                                            (element) => element.boards.boardID == value)].type ==
                                    "sep") {
                                  return;
                                }
                                  selectedBoard = (boardItems[
                                          boardItems.indexWhere((element) =>
                                              element.boards.boardID == value)]
                                      .boards);
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
              width: MediaQuery.of(context).size.width * 0.9,
              child: FutureBuilder(
                  future: DatabaseService.getlistList(currentBoard.boardID),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (!snapshot.hasData) {
                      return Container(
                          alignment: FractionalOffset.center,
                          child: CircularProgressIndicator());
                    } else {
                      listPos.clear();
                      for(var item in snapshot.data){
                        Lists temp = Lists.fromDocument(item);
                        listPos.add(temp);
                      }
                    }
                    return DropdownButtonFormField(
                      icon: Icon(Icons.keyboard_arrow_down),
                      value: currentList.listID,
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
                        setState(() {
                          selectedList = listPos.where(
                                  (element) => element.listID == value)
                          as Lists;
                        });
                      },
                      selectedItemBuilder: (BuildContext context) {
                        return listPos.map((Lists item) {
                          return Text(
                            item.position.toString(),
                            style: TextStyle(
                              fontSize: 20.0,
                            ),
                          );
                        }).toList();
                      },
                      items: listPos.map((Lists val) {
                        return DropdownMenuItem(
                          value: val.listID,
                          child: selectedList.position == val.position
                              ? Text(
                                  val.position.toString() + " (hiện tại)",
                                )
                              : Text(
                                  val.position.toString(),
                                ),
                        );
                      }).toList(),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
