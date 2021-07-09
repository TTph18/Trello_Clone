import 'dart:ui';

import 'package:animate_icons/animate_icons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:trello_clone/drag_and_drop/drag_and_drop_item.dart';
import 'package:trello_clone/drag_and_drop/drag_and_drop_list.dart';
import 'package:trello_clone/drag_and_drop/drag_and_drop_lists.dart';
import 'package:trello_clone/icons/app_icons.dart';
import 'package:trello_clone/models/boards.dart';
import 'package:trello_clone/models/cards.dart';
import 'package:trello_clone/models/lists.dart';
import 'package:trello_clone/models/user.dart';
import 'package:trello_clone/screens/board_screen/end_drawer.dart';
import 'package:trello_clone/screens/board_screen/move_board_screen.dart';
import 'package:trello_clone/screens/card_screen/card_screen.dart';
import 'package:trello_clone/services/database.dart';
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
  final Cards card;
  final bool isNull;

  _card(this.card, this.isNull);

  @override
  _cardState createState() => _cardState(card);
}

class _cardState extends State<_card> {
  late Cards card;
  late String name;
  List<tag> tags = [];
  late bool iconSeen = false;
  late DateTime dateStart;
  late TimeOfDay timeStart;
  late TimeOfDay timeEnd;
  late List<String> assignedUsers;
  late List<Users> cardUsers;

  ///Set year 2000 if user didn't chose time
  late DateTime dateEnd;

  ///Set year 2000 if user didn't chose time
  late bool isFinish = false;
  late bool iconDetail = false;
  late bool iconChecklist = false;
  late int numCom = 0;
  late int numFile = 0;
  late int numFinish = 4;
  late int numTotal = 4;
  List<Image> avas = [];
  String uid = FirebaseAuth.instance.currentUser!.uid;

  _cardState(this.card);

  @override
  void initState() {
    super.initState();
    name = card.cardName;
    assignedUsers = card.assignedUser;
    isFinish = card.status;
    dateStart = card.startDate != ""
        ? DateFormat("yyyy-MM-dd").parse(card.startDate)
        : DateTime.utc(1111, 11, 1);
    dateEnd = card.dueDate != ""
        ? DateFormat("yyyy-MM-dd").parse(card.dueDate)
        : DateTime.utc(1111, 11, 1);
    isFinish = card.status;
    tags = [
      tag(Color(int.parse("0xff61bd4f"))),
      tag(Color(int.parse("0xfff2d600"))),
      tag(Color(int.parse("0xffffab4a"))),
    ];
    card.assignedUser.contains(uid) ? iconSeen = true : iconSeen = false;
    card.description =="" ? iconDetail= false : iconDetail = true;
    numCom = 2;
    numFile = 0;

    for(int i = 0; i< card.assignedUser.length; i++){}

    avas = [
      Image.asset('assets/images/BlueBG.png'),
      Image.asset('assets/images/BlueBG.png'),
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
        child: Text(card.cardName,
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
        onTap: () {
          ///TODO: Link to card detail screen
          Route route = MaterialPageRoute(
              builder: (context) => CardScreen(card.cardName, card));
          Navigator.push(context, route);
        },
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
  final Lists list;
  final String name;
  List<_card> children;
  bool isLast;

  ListCard(
      {required this.list,
      required this.name,
      required this.children,
      required this.isLast});
}

Widget CreateDateString(DateTime dateStart, DateTime dateEnd, bool isFinish) {
  var contents = <Widget>[];
  var color = const Color(0xffFFFFFF);
  if (dateEnd.year > 2000) if (isFinish)
    color = const Color(0xff61bd4f);
  else if (dateEnd.isBefore(DateTime.now()))
    color = const Color(0xffeb5a46);
  else if (dateEnd.isBefore(DateTime.now().add(Duration(days: 1))))
    color = const Color(0xffcdcd08);

  /// Icons
  contents.add(
    Icon(
      Icons.access_time,
      color: Colors.white,
      size: 17,
    ),
  );

  /// Text
  String datestr;
  if (dateStart.year > 2000) {
    datestr = "Ngày " + dateStart.day.toString();
    if (dateEnd.year > 2000) {
      if (dateStart.month != dateEnd.month)
        datestr = datestr + " tháng " + dateStart.month.toString();
      datestr = datestr +
          " - " +
          "Ngày " +
          dateEnd.day.toString() +
          " tháng " +
          dateEnd.month.toString();
    } else
      datestr = datestr + " tháng " + dateStart.month.toString();
  } else
    datestr =
        "Ngày " + dateEnd.day.toString() + " tháng " + dateEnd.month.toString();
  contents.add(Text(
    dateStart.year == 1111 ? "" : datestr,
    style: TextStyle(color: Colors.white),
  ));

  /// Design
  return Padding(
    padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(2)),
        color: color,
      ),
      child: Wrap(children: contents),
    ),
  );
}

Widget CreateChecklistItem(int finish, int total) {
  var contents = <Widget>[];
  var color = const Color(0xffFFFFFF);
  if (finish == total) color = const Color(0xff61bd4f);

  /// Icons
  contents.add(
    Icon(
      Icons.check_box_outlined,
      size: 17,
      color: Colors.white,
    ),
  );

  /// Text
  String contentstr = finish.toString() + "/" + total.toString();
  contents.add(Text(contentstr, style: TextStyle(color: Colors.white)));

  /// Design
  return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(2)),
          color: color,
        ),
        child: Wrap(children: contents),
      ));
}

class BoardScreen extends StatefulWidget {
  final Boards boards;
  final bool isShowDrawer;

  BoardScreen(this.boards, this.isShowDrawer);

  @override
  BoardScreenState createState() => BoardScreenState(boards, isShowDrawer);
}

class BoardScreenState extends State<BoardScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  late Future<Boards> futureBoards;
  late Future<Users> futureUsers;
  late Future<List<Lists>> futureLists;

  late List<Lists> listList = [];
  late List<Cards> listCard = [];
  late Boards boards;
  late bool isShowDrawer;
  late List<String> listName = [];
  late List<Cards> cardList = [];
  late List<_card> cards = [];
  var controller = AnimateIconController();
  AssetImage bg = AssetImage("assets/images/BlueBG.png");

  BoardScreenState(this.boards, this.isShowDrawer);
  Cards nullCard = new Cards(
      cardID: "",
      cardName: "",
      createdBy: "",
      description: "",
      startDate: "",
      startTime: "",
      dueDate: "",
      dueTime: "",
      assignedUser: [],
      status: false,
      listID: "",
      boardID: "");
  late List<ListCard> _lists;
  late List<bool> isTapNewCard = List.filled(_lists.length, false);
  TextEditingController newCardController = TextEditingController();
  late List<bool> isTapChangeListName = List.filled(_lists.length + 1, false);
  TextEditingController changeListNameController = TextEditingController();
  late bool isTapNewList = false;
  TextEditingController newListController = TextEditingController();
  String uid = FirebaseAuth.instance.currentUser!.uid;

  late List<ScrollController> controllers = [];

  Future<Boards> getBoards() async {
    var doc = await DatabaseService.getBoardData(boards.boardID);
    Boards temp = Boards.fromDocument(doc);
    return temp;
  }

  Future<Users> getBoardUser() async {
    var doc = await DatabaseService.getUserData(boards.createdBy);
    Users temp = Users.fromDocument(doc);
    return temp;
  }

  Future<List<Lists>> getLists() async {
    List<Lists> list = [];
    var doc = await DatabaseService.getlistList(boards.boardID);
    for (var item in doc) {
      Lists temp = Lists.fromDocument(item);
      list.add(temp);
    }
    return list;
  }

  Future<List<Cards>> getCards() async {
    List<Cards> list = [];
    var doc = await DatabaseService.getListCard(boards.boardID);
    for (var item in doc) {
      Cards temp = Cards.fromDocument(item);
      list.add(temp);
    }
    return list;
  }

  @override
  void initState() {
    super.initState();
    futureBoards = getBoards();
    futureUsers = getBoardUser();
    futureLists = getLists();

    for (int i = 0; i < boards.listNumber; i++) {
      listName.add("");
      listList.add(new Lists(
          listID: "", listName: "", position: 0, cardList: [], cardNumber: 0));
    }
    for (int i = 0; i < boards.cardNumber; i++) {
      cards.add(_card(nullCard, true));
    }
    for (int i = 0; i < listName.length + 1; i++)
      controllers.add(new ScrollController());

    isTapNewCard = List.filled(listName.length + 1, false);
    isTapNewList = false;

    _lists = List.generate(listName.length + 1, (outerIndex) {
      if (outerIndex < listName.length)
        return ListCard(
          list: listList[outerIndex],
          name: listName[outerIndex],
          children: [],
          isLast: false,
        );
      else
        return ListCard(
          list: new Lists(
              listID: "",
              listName: "",
              position: 0,
              cardList: [],
              cardNumber: 0),
          name: "Add List",
          children: [],
          isLast: true,
        );
    });
    if (isShowDrawer) _scaffoldKey.currentState?.openEndDrawer();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Future.wait([futureBoards, futureUsers]),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          Users boardOwner;
          if (snapshot.hasData) {
            boards = snapshot.data[0];
            boardOwner = snapshot.data[1];
          } else
            return Scaffold(
              key: _scaffoldKey,
              backgroundColor: const Color.fromRGBO(0, 121, 190, 1.0),
              appBar: AppBar(
                title: isTapNewList
                    ? Text("Thêm danh sách")
                    : isTapNewCard.contains(true)
                    ? Text("Thêm thẻ")
                    : isTapChangeListName.contains(true)
                    ? Text("Chỉnh sửa tên danh sách")
                    : Text(boards.boardName),
                backgroundColor: const Color.fromRGBO(0, 64, 126, 1.0),
                leading: (isTapNewList ||
                    isTapNewCard.contains(true) ||
                    isTapChangeListName.contains(true))
                    ? IconButton(
                    onPressed: () {
                      setState(
                            () {
                          if (isTapNewList) {
                            isTapNewList = false;
                            newListController.text = "";
                          }
                          int index = isTapNewCard
                              .indexWhere((element) => element == true);
                          if (index != -1) {
                            isTapNewCard[index] = false;
                            newCardController.text = "";
                          }
                          index = isTapChangeListName
                              .indexWhere((element) => element == true);
                          if (index != -1) {
                            isTapChangeListName[index] = false;
                            changeListNameController.text = "";
                          }
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
                )));
          return Scaffold(
            key: _scaffoldKey,
            backgroundColor: const Color.fromRGBO(0, 121, 190, 1.0),
            appBar: AppBar(
              title: isTapNewList
                  ? Text("Thêm danh sách")
                  : isTapNewCard.contains(true)
                      ? Text("Thêm thẻ")
                      : isTapChangeListName.contains(true)
                          ? Text("Chỉnh sửa tên danh sách")
                          : Text(boards.boardName),
              backgroundColor: const Color.fromRGBO(0, 64, 126, 1.0),
              leading: (isTapNewList ||
                      isTapNewCard.contains(true) ||
                      isTapChangeListName.contains(true))
                  ? IconButton(
                      onPressed: () {
                        setState(
                          () {
                            if (isTapNewList) {
                              isTapNewList = false;
                              newListController.text = "";
                            }
                            int index = isTapNewCard
                                .indexWhere((element) => element == true);
                            if (index != -1) {
                              isTapNewCard[index] = false;
                              newCardController.text = "";
                            }
                            index = isTapChangeListName
                                .indexWhere((element) => element == true);
                            if (index != -1) {
                              isTapChangeListName[index] = false;
                              changeListNameController.text = "";
                            }
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
              actions: (isTapNewList ||
                      isTapNewCard.contains(true) ||
                      isTapChangeListName.contains(true))
                  ? [
                      IconButton(
                        icon: const Icon(Icons.check),
                        onPressed: () {
                          if (isTapNewList) {
                            if (newListController.text != "") {
                              setState(
                                () {
                                  futureLists = getLists();
                                  isTapNewList = false;
                                },
                              );
                              DatabaseService.addList(
                                  boards.boardID, newListController.text);
                              setState(() {
                                for (int i = 0; i < boards.listNumber; i++) {
                                  listName.add("");
                                  listList.add(new Lists(
                                      listID: "", listName: "", position: 0, cardList: [], cardNumber: 0));
                                }
                                newListController.text = "";
                              });
                            }
                          }
                          int index = isTapNewCard
                              .indexWhere((element) => element == true);
                          if (index != -1) {
                            if (newCardController.text != "") {
                              DatabaseService.addCard(
                                  boards.boardID,
                                  listList[index].listID,
                                  newCardController.text, "", uid, [], "", "", "", "");
                              setState(
                                () {
                                  isTapNewCard[index] = false;
                                  newListController.text = "";
                                },
                              );
                            }
                          }
                          index = isTapChangeListName
                              .indexWhere((element) => element == true);
                          if (index != -1) {
                            if (changeListNameController.text != "") {
                              DatabaseService.renameList(
                                  boards.boardID,
                                  listList[index].listID,
                                  changeListNameController.text);
                              setState(
                                () {
                                  isTapChangeListName[index] = false;
                                },
                              );
                            }
                          }
                        },
                      ),
                    ]
                  : [
                      IconButton(
                        icon: const Icon(MyFlutterApp.bell),
                        onPressed: () {
                          Navigator.of(context).pushNamed(NOTIFICATION_SCREEN);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.more_horiz),
                        onPressed: () {
                          _scaffoldKey.currentState!.openEndDrawer();
                        },
                      ),
                    ],
            ),
            endDrawer: mainMenu(
                Users(
                  userID: boardOwner.userID,
                  userName: boardOwner.userName,
                  profileName: boardOwner.profileName,
                  email: boardOwner.email,
                  avatar: boardOwner.avatar,
                ),
                boards),
            body: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: bg,
                    fit: BoxFit.cover,
                  ),
                ),
                child: StreamBuilder(
                    stream: DatabaseService.streamLists(boards.boardID),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (!snapshot.hasData) {
                        return Container(
                            alignment: FractionalOffset.center,
                            child: CircularProgressIndicator());
                      } else {
                        listName.clear();
                        listList.clear();
                        controllers.clear();
                        _lists.clear();
                        for (var item in snapshot.data.docs) {
                          Lists _list = Lists.fromDocument(item);
                          listList.add(_list);
                          listName.add(_list.listName);
                        }
                      }
                      return StreamBuilder(
                          stream: DatabaseService.streamCards(boards.boardID),
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            if (!snapshot.hasData) {
                              return Container(
                                  alignment: FractionalOffset.center,
                                  child: CircularProgressIndicator());
                            } else {
                              cardList = snapshot.data;
                              for (int i = 0; i < cardList.length; i++) {
                                cards.insert(i, new _card(cardList[i], false));
                              }
                            }
                            for (int i = 0; i < listName.length + 1; i++)
                              controllers.add(new ScrollController());
                            _lists = List.generate(
                              listName.length + 1,
                              (outerIndex) {
                                if (outerIndex < listName.length) {
                                  var item = listList[outerIndex].cardNumber;
                                  var list = getCardList(
                                      listList[outerIndex], cardList);
                                  for (int i = 0; i < list.length; i++) {
                                    cards.insert(i, new _card(list[i], false));
                                  }
                                  return ListCard(
                                    list: listList[outerIndex],
                                    name: listName[outerIndex],
                                    children:
                                        listList[outerIndex].cardNumber == 0
                                            ? []
                                            : List.generate(item, (innerIndex) {
                                                return cards[innerIndex];
                                              }),
                                    isLast: false,
                                  );
                                } else
                                  return ListCard(
                                    list: new Lists(
                                        listID: "",
                                        listName: "",
                                        position: 0,
                                        cardList: [],
                                        cardNumber: 0),
                                    name: "Add List",
                                    children: [],
                                    isLast: true,
                                  );
                              },
                            );
                            return DragAndDropLists(
                              children: List.generate(
                                  _lists.length, (index) => _buildList(index)),
                              onItemReorder: _onItemReorder,
                              onListReorder: _onListReorder,
                              axis: Axis.horizontal,
                              listWidth: 320,
                              listDraggingWidth: 288,
                              listDecoration: BoxDecoration(
                                color: Color.fromRGBO(244, 245, 247, 1.0),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(7.0)),
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
                            );
                          });
                    })),
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
        });
  }

  _buildList(int outerIndex) {
    var innerList = _lists[outerIndex];
    if (!innerList.isLast) {
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
                    isTapChangeListName[outerIndex]
                        ? Container(
                            width: 200,
                            child: TextField(
                              autofocus: true,
                              controller: changeListNameController,
                            ),
                          )
                        : InkWell(
                            onTap: () {
                              changeListNameController.text = '';
                              setState(() {
                                isTapChangeListName[outerIndex] = true;
                              });
                            },
                            child: Text(
                              '${innerList.name}',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                    Container(
                      height: 18,
                      width: 20,
                      child: PopupMenuButton(
                        iconSize: 25,
                        padding: EdgeInsets.zero,
                        icon: Icon(Icons.more_vert),
                        onSelected: (value) {
                          if (value == 1) {
                            setState(() {
                              isTapNewCard[outerIndex] = true;
                            });
                            controllers[outerIndex].animateTo(
                              controllers[outerIndex].position.maxScrollExtent -
                                  5,
                              curve: Curves.easeOut,
                              duration: const Duration(milliseconds: 300),
                            );
                          } else if (value == 2) {
                            setState(() {
                              futureLists = getLists();
                              Route route = MaterialPageRoute(
                                  builder: (context) =>
                                      MoveBoardScreen(boards, innerList.list));
                              Navigator.push(context, route);
                            });
                          } else {
                            showDialog<String>(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                title: const Text(
                                  'Xóa danh sách',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                content: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                          "Tất cả các thao tác sẽ bị xóa khỏi thông báo hoạt động. Không thể hoàn tác."),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          TextButton(
                                            child: Text(
                                              'HỦY',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                          TextButton(
                                            child: Text(
                                              'XÓA',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            onPressed: () {
                                              DatabaseService.deleteList(
                                                  boards.boardID,
                                                  innerList.list.listID);
                                              setState(() {});
                                              Navigator.of(context).pop();
                                            },
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }
                        },
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
              ),
            ),
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
              )
            : TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Color.fromRGBO(244, 245, 247, 1.0),
                ),
                onPressed: () {
                  setState(() {
                    isTapNewCard[outerIndex] = true;
                  });
                  controllers[outerIndex].animateTo(
                    controllers[outerIndex].position.maxScrollExtent - 5,
                    curve: Curves.easeOut,
                    duration: const Duration(milliseconds: 300),
                  );
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
        maxheight: MediaQuery.of(context).size.height -
            MediaQuery.of(context).viewInsets.bottom,
        children: List.generate(
          innerList.children.length,
          (index) => _buildItem(innerList.children[index]),
        ),
      );
    } else {
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
    for (int i = 0; i < controllers.length; i++) {
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

TimeOfDay timeConvert(String normTime) {
  int hour;
  int minute;
  String ampm = normTime.substring(normTime.length - 2);
  String result = normTime.substring(0, normTime.indexOf(' '));
  if (ampm == 'AM' && int.parse(result.split(":")[1]) != 12) {
    hour = int.parse(result.split(':')[0]);
    if (hour == 12) hour = 0;
    minute = int.parse(result.split(":")[1]);
  } else {
    hour = int.parse(result.split(':')[0]) - 12;
    if (hour <= 0) {
      hour = 24 + hour;
    }
    minute = int.parse(result.split(":")[1]);
  }
  return TimeOfDay(hour: hour, minute: minute);
}

List<Cards> getCardList(Lists list, List<Cards> listcard) {
  List<Cards> temp = [];
  for (int i = 0; i < listcard.length; i++) {
    if (list.listID == listcard[i].listID) {
      temp.add(listcard[i]);
      continue;
    } else
      continue;
  }
  return temp;
}
