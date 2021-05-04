import 'dart:ui';

import 'package:animate_icons/animate_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:trello_clone/drag_and_drop/drag_and_drop_item.dart';
import 'package:trello_clone/drag_and_drop/drag_and_drop_list.dart';
import 'package:trello_clone/drag_and_drop/drag_and_drop_lists.dart';
import 'package:trello_clone/icons/app_icons.dart';

import '../../route_path.dart';

class AddListCard extends StatelessWidget {
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
              width: 250,
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

class _card extends StatelessWidget {
  late String item;

  _card(this.item);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: InkWell(
        customBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
        onTap: () {},
        child: Ink(
          width: 238,
          height: 50,
          child: Column(
            children: [
              SizedBox(
                height: 15,
              ),
              Align(
                alignment: Alignment.center,
                child: Text("Add Card",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.green,
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ListCard {
  final String name;
  List<_card> children;
  bool isLast;

  ListCard({required this.name, required this.children, required this.isLast});
}

Widget PopMenu() {
  return Container(
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
                child: Text('Di chuyển danh sách'),
              ),
              PopupMenuItem(
                value: 2,
                child: Text('Sao chép danh sách'),
              ),
              PopupMenuItem(
                value: 3,
                child: Text('Lưu trữ danh sách'),
              ),
              PopupMenuItem(
                value: 4,
                child: Text('Di chuyển tất cả các thẻ trong danh sách'),
              ),
              PopupMenuItem(
                value: 5,
                child: Text('Lưu trữ tất cả các thẻ'),
              ),
              PopupMenuItem(
                value: 6,
                child: Text('Xem'),
              ),
              PopupMenuItem(
                  value: 7,
                  child: Text('Sắp xếp danh sách'),
              ),
            ]),
  );
}

class BoardScreen extends StatefulWidget {
  late String boardName;

  BoardScreen(this.boardName);

  @override
  BoardScreenState createState() => BoardScreenState(boardName);
}

class BoardScreenState extends State<BoardScreen> {
  late String boardName;

  late List<String> listName;
  late List<_card> cards;
  var controller = AnimateIconController();

  BoardScreenState(this.boardName);

  late List<ListCard> _lists;

  @override
  void initState() {
    super.initState();

    listName = ["To Do", "Completed"];
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
      backgroundColor: const Color.fromRGBO(0, 121, 190, 1.0),
      appBar: AppBar(
          title: Text(boardName),
          backgroundColor: const Color.fromRGBO(0, 64, 126, 1.0),
          leading: Builder(builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pushNamed(MAIN_SCREEN);
              },
            );
          }),
          actions: [
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
              onPressed: () {},
            ),
          ]),
      body: DragAndDropLists(
        children: List.generate(_lists.length, (index) => _buildList(index)),
        onItemReorder: _onItemReorder,
        onListReorder: _onListReorder,
        axis: Axis.horizontal,
        listWidth: 250,
        listDraggingWidth: 238,
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
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                    PopMenu(),
                  ],
                ),
              ),
            ),
          ],
        ),
        footer: TextButton(
          style: TextButton.styleFrom(
            backgroundColor: Color.fromRGBO(244, 245, 247, 1.0),
          ),
          onPressed: () {},
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.add,
                color: Color.fromRGBO(139, 196, 134, 1.0),
              ),
              Text(
                "Thêm thẻ",
                style: TextStyle(color: Color.fromRGBO(129, 184, 120, 1.0)),
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
          innerList.children.length - 1,
          (index) => _buildItem(innerList.children[index]),
        ),
      );
    else {
      return DragAndDropList(
        header: TextButton(
          style: TextButton.styleFrom(
            backgroundColor: Color.fromRGBO(244, 245, 247, 1.0),
          ),
          onPressed: () {},
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
