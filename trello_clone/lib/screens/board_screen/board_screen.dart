import 'dart:async';
import 'dart:ui';

import 'package:animate_icons/animate_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:trello_clone/drag_and_drop/drag_and_drop_item.dart';
import 'package:trello_clone/drag_and_drop/drag_and_drop_list.dart';
import 'package:trello_clone/drag_and_drop/drag_and_drop_lists.dart';
import 'package:trello_clone/icons/app_icons.dart';
import 'package:trello_clone/models/user.dart';
import 'package:trello_clone/screens/board_screen/end_drawer.dart';
import 'package:trello_clone/widgets/reuse_widget/avatar.dart';

import '../../route_path.dart';

class AddListCard extends StatefulWidget {
  @override
  AddListCardState createState() => AddListCardState();
}

class AddListCardState extends State<AddListCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0),
      child: Container(
        child: Card(
          color: Color.fromRGBO(244, 245, 247, 1),
          child: InkWell(
            onTap: () {},
            child: Ink(
              width: 320,
              child: Column(
                children: [
                  SizedBox(
                    height: 15,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Text("Thêm danh sách",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.green,
                        )),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class tag extends StatelessWidget {
  final Color tagColor;

  tag(this.tagColor);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 8, 8),
      child: Container(
        width: 35,
        height: 20,
        decoration: BoxDecoration(
          color: tagColor,
          borderRadius: BorderRadius.all(Radius.circular(2)),
        ),
      ),
    );
  }
}

class tagList extends StatelessWidget {
  final List<tag> _list;

  tagList(this._list);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [for (var i = 0; i < _list.length; i++) _list[i]],
    );
  }
}

class _card extends StatefulWidget {
  final String name;

  _card(this.name);

  @override
  _cardState createState() => _cardState(name);
}

class _cardState extends State<_card> {
  late String name;
  List<tag> tags = [];
  bool iconSeen = false;
  DateTime dateStart = DateTime.utc(2001, 11, 9);

  ///Set year 2000 if user didn't chose time
  DateTime dateEnd = DateTime.utc(2021, 6, 12, 10, 11, 12);

  ///Set year 2000 if user didn't chose time
  late bool isFinish = false;
  bool iconDetail = false;
  bool iconChecklist = false;
  int numCom = 0;
  int numFile = 0;
  int numFinish = 4;
  int numTotal = 4;
  List<AssetImage> avas = [];

  _cardState(this.name);

  @override
  void initState() {
    super.initState();

    tags = [
      tag(Color(int.parse("0xff61bd4f"))),
      tag(Color(int.parse("0xfff2d600"))),
      tag(Color(int.parse("0xffffab4a"))),
    ];
    iconSeen = true;

    iconDetail = true;
    numCom = 2;
    numFile = 3;
    avas = [
      AssetImage('assets/images/BlueBG.png'),
      AssetImage('assets/images/BlueBG.png'),
    ];
  }

  @override
  Widget build(BuildContext context) {
    var contents = <Widget>[];

    /// Tag line
    var contentItem = <Widget>[];
    if (tags.length != 0)
      for (var i = 0; i < tags.length; i++) contentItem.add(tags[i]);
    contents.add(Align(
      alignment: Alignment.centerLeft,
      child: Wrap(
        children: contentItem,
      ),
    ));

    /// Title line
    contents.add(
      Align(
        alignment: Alignment.centerLeft,
        child: Text(name,
            style: TextStyle(
              fontSize: 18,
              color: Colors.black,
            )),
      ),
    );

    /// Icons line
    contentItem = <Widget>[];
    if (iconSeen)
      contentItem.add(
        Icon(
          Icons.remove_red_eye_outlined,
          size: 20,
        ),
      );
    if (dateStart.year > 2000 || dateEnd.year > 2000)
      contentItem.add(CreateDateString(dateStart, dateEnd, isFinish));
    if (iconDetail)
      contentItem.add(
        Icon(
          Icons.subject,
          size: 20,
        ),
      );
    if (numCom > 0) {
      contentItem.add(Wrap(
        spacing: 2,
        children: [
          Icon(
            MyFlutterApp.comment_empty,
            size: 17,
          ),
          Text(
            numCom.toString(),
          ),
        ],
      ));
    }
    if (numFile > 0) {
      contentItem.add(Wrap(spacing: 2, children: [
        Icon(
          Icons.attach_file,
          size: 17,
        ),
        Text(
          numFile.toString(),
        ),
      ]));
    }
    if (numTotal > 0) contentItem.add(CreateChecklistItem(numFinish, numTotal));
    contents.add(Padding(
        padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
        child: Wrap(spacing: 4, runSpacing: 4, children: contentItem)));

    /// Avatar line
    contentItem = <Widget>[];
    if (avas.length != 0)
      for (var i = 0; i < avas.length; i++)
        contentItem.add(Padding(
          padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
          child: avatar(40, 40, Color.fromRGBO(255, 255, 255, 0), avas[i]),
        ));
    contents.add(Padding(
        padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: contentItem,
        )));

    return Card(
      color: Colors.white,
      child: InkWell(
        customBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
        onTap: () {},
        child: Ink(
          width: 308,
          child: Container(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: contents,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class NewCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: TextField(),
    );
  }
}

class ListCard {
  final String name;
  List<_card> children;
  bool isLast;

  ListCard({required this.name, required this.children, required this.isLast});
}


Widget CreateDateString(DateTime dateStart, DateTime dateEnd, bool isFinish) {
  var contents = <Widget>[];
  var color = const Color(0xffFFFFFF);
  if (dateEnd.year > 2000) if (isFinish)
    color = const Color(0xff00AF00);
  else if (dateEnd.isBefore(DateTime.now()))
    color = const Color(0xffFF0000);
  else if (dateEnd.isBefore(DateTime.now().add(Duration(days: 1))))
    color = const Color(0xffFFFF00);

  /// Icons
  contents.add(
    Icon(
      Icons.access_time,
      size: 17,
    ),
  );

  /// Text
  String datestr;
  if (dateStart.year > 2000) {
    datestr = "Ngày " +
        dateStart.day.toString() +
        " tháng " +
        dateStart.month.toString();
    if (dateEnd.year > 2000)
      datestr = datestr +
          " - " +
          "Ngày " +
          dateEnd.day.toString() +
          " tháng " +
          dateEnd.month.toString();
  } else {
    datestr =
        "Ngày " + dateEnd.day.toString() + " tháng " + dateEnd.month.toString();
  }
  contents.add(Text(datestr));

  /// Design
  return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: Container(
        decoration: BoxDecoration(
          color: color,
        ),
        child: Wrap(children: contents),
      ));
}

Widget CreateChecklistItem(int finish, int total) {
  var contents = <Widget>[];
  var color = const Color(0xffFFFFFF);
  if (finish == total) color = const Color(0xff00AF00);

  /// Icons
  contents.add(
    Icon(
      Icons.check_box_outlined,
      size: 17,
    ),
  );

  /// Text
  String contentstr = finish.toString() + "/" + total.toString();
  contents.add(Text(contentstr));

  /// Design
  return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: Container(
        decoration: BoxDecoration(
          color: color,
        ),
        child: Wrap(children: contents),
      ));
}

class BoardScreen extends StatefulWidget {
  final String boardName;
  final bool isShowDrawer;
  BoardScreen(this.boardName, this.isShowDrawer);

  @override
  BoardScreenState createState() => BoardScreenState(boardName, isShowDrawer);
}

class BoardScreenState extends State<BoardScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  late String boardName;
  late bool isShowDrawer;
  late List<String> listName;
  late List<_card> cards;
  var controller = AnimateIconController();
  AssetImage bg = AssetImage("assets/images/BlueBG.png");

  BoardScreenState(this.boardName, this.isShowDrawer);

  late List<ListCard> _lists;
  late List<bool> isTapNewCard = List.filled(listName.length, false);
  TextEditingController newCardController = TextEditingController();
  late bool isTapNewList = false;
  TextEditingController newListController = TextEditingController();

  late List<ScrollController> controllers;
  @override
  void initState() {
    super.initState();

    listName = ["To Do", "Completed"];
    controllers = List.filled(listName.length + 1, new ScrollController());
    print(listName.length + 1);
    isTapNewCard = List.filled(listName.length, false);
    isTapNewList = false;
    cards = [
      _card("Thẻ 1"),
      _card("Thẻ 2"),
      _card("Thẻ 3"),
      _card("Thẻ 4"),
      _card("Thẻ 5"),
    ];
    _lists = List.generate(listName.length + 1, (outerIndex) {
      if (outerIndex < listName.length)
        return ListCard(
          name: listName[outerIndex],
          children:
              List.generate(cards.length, (innerIndex) => cards[innerIndex]),
          isLast: false,
        );
      else
        return ListCard(
          name: "Add List",
          children: [],
          isLast: true,
        );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color.fromRGBO(0, 121, 190, 1.0),
      appBar: AppBar(
          title: isTapNewList ? Text("Thêm danh sách") : Text(boardName),
          backgroundColor: const Color.fromRGBO(0, 64, 126, 1.0),
          leading: isTapNewList
              ? IconButton(
                  onPressed: () {
                    setState(
                      () {
                        isTapNewList = false;
                        newListController.text = "";
                      },
                    );
                  },
                  icon: Icon(Icons.close))
              : Builder(
                  builder: (BuildContext context) {
                    return IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () {
                        Navigator.of(context).pushNamed(MAIN_SCREEN);
                      },
                    );
                  },
                ),
          actions: isTapNewList
              ? [
                  IconButton(
                    icon: const Icon(Icons.check),
                    onPressed: () {
                      if (newListController.text != "") {
                        ///TODO: Add new list to board
                        setState(
                          () {
                            ///TODO: Reload list of lists in board
                            isTapNewList = false;
                            newListController.text = "";
                          },
                        );
                      }
                      ;
                    },
                  ),
                ]
              : [
                  IconButton(
                    icon: const Icon(Icons.filter_list),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(MyFlutterApp.bell),
                    onPressed: () {},
                  ),
                  IconButton(
                      icon: const Icon(Icons.more_horiz),
                      onPressed: () {
                        _scaffoldKey.currentState!.openEndDrawer();
                      }),
                ]),
      endDrawer: mainMenu(Users(
          userID: "12345",
          userName: "name1",
          profileName: "Name 1",
          email: '123456@gmail.com',
          avatar: 'assets/images/BlueBG.png',
          workspaceList: [])),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: bg,
            fit: BoxFit.cover,
          ),
        ),
        child: DragAndDropLists(
          children: List.generate(_lists.length, (index) => _buildList(index)),
          onItemReorder: _onItemReorder,
          onListReorder: _onListReorder,
          axis: Axis.horizontal,
          listWidth: 320,
          listDraggingWidth: 288,
          listDecoration: BoxDecoration(
            color: Color.fromRGBO(244, 245, 247, 1.0),
            borderRadius: BorderRadius.all(Radius.circular(7.0)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.black45,
                spreadRadius: 3.0,
                blurRadius: 6.0,
                offset: Offset(2, 3),
              ),
            ],
          ),
          listPadding: EdgeInsets.fromLTRB(16, 8, 16, 8),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: AnimateIcons(
          startIcon: Icons.zoom_in,
          endIcon: Icons.zoom_out,
          controller: controller = AnimateIconController(),
          onStartIconPress: () {
            return true;
          },
          onEndIconPress: () {
            return true;
          },
          duration: Duration(milliseconds: 100),
          startIconColor: Colors.white,
          endIconColor: Colors.white,
          clockwise: true,
        ),
        backgroundColor: Colors.green,
      ),
    );
  }

  _buildList(int outerIndex) {
    var innerList = _lists[outerIndex];
    if (!innerList.isLast)
      return DragAndDropList(
        controller: controllers[outerIndex],
        header: Row(
          children: <Widget>[
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(7.0)),
                  color: Color.fromRGBO(244, 245, 247, 1.0),
                ),
                padding: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${innerList.name}',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    Container(
                      height: 18,
                      width: 20,
                      child: PopupMenuButton(
                        iconSize: 25,
                        padding: EdgeInsets.zero,
                        icon: Icon(Icons.more_vert),
                        onSelected: (value) {},
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            value: 1,
                            child: Text('Thêm thẻ'),
                          ),
                          PopupMenuItem(
                            value: 2,
                            child: Text('Di chuyển danh sách'),
                          ),
                          PopupMenuItem(
                            value: 3,
                            child: Text('Xóa danh sách'),
                          ),
                        ],
                          ),
                        ),
                ],
                      ),
                    ),),
                  ],
                ),
        footer: isTapNewCard[outerIndex]
            ? Card(
                color: Colors.white,
                child: InkWell(
                  customBorder: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Ink(
                    width: 308,
                    child: Container(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Focus(
                          onFocusChange: (hasFocus) {
                            if (!hasFocus) {
                              setState(() {
                                isTapNewCard[outerIndex] = false;
                                newCardController.text = "";
                              });
                            }
                          },
                          child: TextField(
                            autofocus: true,
                            controller: newCardController,
                            decoration: InputDecoration(
                              hintText: "Tên thẻ",
                              hintStyle: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            : TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Color.fromRGBO(244, 245, 247, 1.0),
                ),
                onPressed: () {
                  setState(() {
                    //print("INFORMATION: begin");
                    isTapNewCard[outerIndex] = true;
                    //controllers[outerIndex].jumpTo(controllers[outerIndex].position.maxScrollExtent);
                    //print("INFORMATION: end");
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.add,
                      color: Color.fromRGBO(139, 196, 134, 1.0),
                    ),
                    Text(
                      "Thêm thẻ",
                      style:
                          TextStyle(color: Color.fromRGBO(129, 184, 120, 1.0)),
                    ),
                  ],
                ),
              ),
        leftSide: VerticalDivider(
          color: Color.fromRGBO(244, 245, 247, 1.0),
          width: 6,
          thickness: 6,
        ),
        rightSide: VerticalDivider(
          color: Color.fromRGBO(244, 245, 247, 1.0),
          width: 6,
          thickness: 6,
        ),
        maxheight: MediaQuery.of(context).size.height,
        children: List.generate(
          innerList.children.length,
          (index) => _buildItem(innerList.children[index]),
        ),
      );
    else {
      if (isTapNewList) {
        return DragAndDropList(
          controller: controllers[outerIndex],
          maxheight: MediaQuery.of(context).size.height * 0.7,
          header: Card(
            color: Colors.white,
            child: InkWell(
              customBorder: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
              child: Ink(
                width: 308,
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Focus(
                      onFocusChange: (hasFocus) {
                        if (!hasFocus) {
                          setState(() {
                            isTapNewList = false;
                            newListController.text = "";
                          });
                        }
                      },
                      child: TextField(
                        autofocus: true,
                        controller: newListController,
                        decoration: InputDecoration(
                          hintText: "Tên danh sách",
                          hintStyle: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          backgroundColor: Color.fromRGBO(244, 245, 247, 0),
          canDrag: false,
          children: [],
        );
      } else {
        return DragAndDropList(
          controller: controllers[outerIndex],
          maxheight: MediaQuery.of(context).size.height * 0.7,
          header: TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Color.fromRGBO(244, 245, 247, 1.0),
            ),
            onPressed: () {
              setState(() {
                isTapNewList = true;
              });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Thêm danh sách",
                  style: TextStyle(color: Color.fromRGBO(129, 184, 120, 1.0)),
                ),
              ],
            ),
          ),
          backgroundColor: Color.fromRGBO(244, 245, 247, 0),
          canDrag: false,
          children: [],
        );
      }
    }
  }

  @override
  void dispose() {
    for (int i = 0; i < controllers.length; i++)
      {
        controllers[i].dispose();
      }
    super.dispose();
  }

  _buildItem(_card item) {
    return DragAndDropItem(
      child: item,
    );
  }

  _onItemReorder(
      int oldItemIndex, int oldListIndex, int newItemIndex, int newListIndex) {
    setState(() {
      var movedItem = _lists[oldListIndex].children.removeAt(oldItemIndex);
      _lists[newListIndex].children.insert(newItemIndex, movedItem);
    });
  }

  _onListReorder(int oldListIndex, int newListIndex) {
    setState(() {
      var movedList = _lists.removeAt(oldListIndex);
      _lists.insert(newListIndex, movedList);
    });
  }
}
