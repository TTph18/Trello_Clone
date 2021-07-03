import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trello_clone/icons/app_icons.dart';
import 'package:trello_clone/icons/my_flutter_app2_icons.dart';
import 'package:trello_clone/models/boards.dart';
import 'package:trello_clone/screens/board_screen/board_screen.dart';
import 'dart:math' as math;

import 'package:trello_clone/widgets/reuse_widget/avatar.dart';

class CardScreen extends StatefulWidget {
  late String cardName;

  CardScreen(this.cardName);

  @override
  CardScreenState createState() => CardScreenState(cardName);
}

class CardScreenState extends State<CardScreen> {
  late String cardName;
  late Boards boards;
  CardScreenState(this.cardName);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Color.fromRGBO(244, 245, 247, 1.0),
      appBar: AppBar(
          backgroundColor: Colors.white,
          leading: Builder(builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.clear),
              color: Colors.black,
              onPressed: () {
                ///TODO: Uncomment after init boards
                //Route route =
                //MaterialPageRoute(builder: (context) => BoardScreen(boards, false));
                //Navigator.push(context, route);
              },
            );
          }),
          elevation: 0.0,
          actions: [
            PopupMenuButton<String>(
                icon: const Icon(
                  Icons.more_vert,
                  color: Colors.black,
                ),
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                      const PopupMenuItem<String>(
                        value: "Di chuyển thẻ",
                        child: Text('Di chuyển thẻ'),
                      ),
                      const PopupMenuItem<String>(
                        value: "Xóa thẻ",
                        child: Text('Xóa thẻ'),
                      ),
                    ])
          ]),
      body: SingleChildScrollView(
            child: Column(
              children: [
                ///Card name
                Container(
                  width: MediaQuery.of(context).size.width,
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 25.0, top: 30.0),
                    child: Text("Tên thẻ", style: TextStyle(fontSize: 30)),
                  ),
                ),

                ///
                Container(
                  width: MediaQuery.of(context).size.width,
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 25.0, top: 15.0, bottom: 20.0),
                    child: Text("Danh sách Tên danh sách trong Tên bảng",
                        style: TextStyle(fontSize: 20)),
                  ),
                ),

                ///Card Description
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.only(
                    left: 25,
                    right: 25,
                    top: 5.0,
                    bottom: 5.0,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                        top: BorderSide(color: Colors.grey.shade400),
                        bottom: BorderSide(color: Colors.grey.shade400)),
                  ),
                  child: TextField(
                    style: TextStyle(fontSize: 20),
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: InputDecoration(
                      hintText: "Thêm mô tả thẻ...",
                      hintStyle: TextStyle(fontSize: 20),
                      contentPadding: const EdgeInsets.only(bottom: 0.0),
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),

                ///Label
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.only(
                    left: 25,
                    right: 25,
                    top: 20.0,
                    bottom: 20.0,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                        top: BorderSide(color: Colors.grey.shade400),
                        bottom: BorderSide(color: Colors.grey.shade400)),
                  ),
                  child: Row(
                    children: [
                      Icon(MyFlutterApp2.tag),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        "Nhãn...",
                        style: TextStyle(fontSize: 20),
                      )
                    ],
                  ),
                ),

                SizedBox(
                  height: 10,
                ),

                ///Member
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.only(
                    left: 25,
                    right: 25,
                    top: 20.0,
                    bottom: 20.0,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                        top: BorderSide(color: Colors.grey.shade400),
                        bottom: BorderSide(color: Colors.grey.shade400)),
                  ),
                  child: Row(
                    children: [
                      Icon(MyFlutterApp.person_outline),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        "Thành viên...",
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),

                ///DateStart + DateEnd
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.only(
                    left: 25,
                    right: 25,
                    top: 20.0,
                    bottom: 13.0,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                        top: BorderSide(color: Colors.grey.shade400),),
                  ),
                  child: Row(
                    children: [
                      Icon(MyFlutterApp.clock),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        "Ngày bắt đầu...",
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                ),
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.fromLTRB(70, 0, 0, 0),
                  child: Divider(color: Colors.grey.shade400),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.only(
                    left: 25,
                    right: 25,
                    top: 13.0,
                    bottom: 20.0,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border:
                        Border(bottom: BorderSide(color: Colors.grey.shade400)),
                  ),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 24,
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        "Ngày kết thúc...",
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                ),

                SizedBox(
                  height: 10,
                ),

                ///Checklist
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.only(
                    left: 25,
                    right: 25,
                    top: 20.0,
                    bottom: 20.0,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                        top: BorderSide(color: Colors.grey.shade400),
                        bottom: BorderSide(color: Colors.grey.shade400)),
                  ),
                  child: Row(
                    children: [
                      Icon(MyFlutterApp2.check),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        "Danh sách công việc...",
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                ),

                SizedBox(
                  height: 10,
                ),

                ///Attachment
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.only(
                    left: 25,
                    right: 25,
                    top: 20.0,
                    bottom: 20.0,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                        top: BorderSide(color: Colors.grey.shade400),
                        bottom: BorderSide(color: Colors.grey.shade400)),
                  ),
                  child: Row(
                    children: [
                      Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.rotationY(math.pi),
                        child: Icon(MyFlutterApp2.attach),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        "Tệp đính kèm...",
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                ),
                ///for bottom sheet not cover last element
                SizedBox(height: 69,)
              ],
            ),
          ),
      bottomSheet: BottomAppBar(
        child: Container(
          padding: const EdgeInsets.all(5.0),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 3,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: Row(
            children: [
              avatar(50, 50, Colors.grey,
                  AssetImage('assets/images/BlueBG.png')),
              SizedBox(width: 10,),
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Enter a message',
                    suffixIcon: IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.send, size: 30,),
                    ),
                    border: new OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(30.0),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10,),
              IconButton(
                  onPressed: () {}, icon: Icon(MyFlutterApp2.attach)),
            ],
          ),
        ),
      ),
    );
  }
}
