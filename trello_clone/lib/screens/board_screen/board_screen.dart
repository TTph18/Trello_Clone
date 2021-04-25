import 'dart:ui';

import 'package:animate_icons/animate_icons.dart';
import 'package:flutter/material.dart';

import '../../route_path.dart';

class AddListCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(9, 8, 9, 0),
      child: Container(
        child: Stack(
          children: [
            Card(
              color: Color.fromRGBO(244, 245, 247, 1),
              child: InkWell(
                customBorder: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                onTap: () {},
                child: Ink(
                  width: 250,
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
            ),
          ],
        ),
      ),
    );
  }
}

class ListCard extends StatelessWidget {
  late String listName;
  List<String> cardNames = ["Thẻ 1", "Thẻ 2"];

  ListCard(this.listName);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(9, 4, 9, 0),
        child: Container(
          child: Stack(
            children: [
              Card(
                color: Color.fromRGBO(244, 245, 247, 1),
                child: Container(
                  width: 250.0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              listName, //cardNames[index],
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                                height: 17,
                                width: 17,
                                child: IconButton(
                                  padding: new EdgeInsets.all(0.0),
                                  onPressed: () {},
                                  icon: Icon(
                                    Icons.more_vert,
                                    color: Colors.black,
                                    size: 18,
                                  ),
                                ))
                          ],
                        ),
                      ),
                      SingleChildScrollView(
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.7,
                          child: Column(
                            children: [],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              //Positioned.fill(
              //  child: DragTarget<dynamic>(
              //    onWillAccept: (data) {
              //      print(data);
              //      return true;
              //    },
              //    onLeave: (data) {},
              //    onAccept: (data) {
              //      if (data['from'] == index) {
              //        return;
              //      }
              //      childres[data['from']].remove(data['string']);
              //      childres[index].add(data['string']);
              //      print(data);
              //      setState(() {});
              //    },
              //    builder: (context, accept, reject) {
              //      print("--- > $accept");
              //      print(reject);
              //      return Container();
              //    },
              //  ),
              //),
            ],
          ),
        ));
  }
}

class BoardScreen extends StatefulWidget {
  late String boardName;

  BoardScreen(this.boardName);

  @override
  BoardScreenState createState() => BoardScreenState(boardName);
}

class BoardScreenState extends State<BoardScreen> {
  late String boardName;

  List<String> listName = ["ToDo", "Completed"];
  var controller = AnimateIconController();
  BoardScreenState(this.boardName);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(0, 121, 190, 1.0),
      appBar: AppBar(
          title: Text(boardName),
          backgroundColor: const Color.fromRGBO(0, 64, 126, 1.0),
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
      body: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: listName.length + 1,
        itemBuilder: (context, index) {
          if (index == listName.length)
            return AddListCard();
          else
            return ListCard(listName[index]);
        },
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
}
