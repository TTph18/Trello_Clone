import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trello_clone/icons/app_icons.dart';

class CardScreen extends StatefulWidget {
  late String cardName;

  CardScreen(this.cardName);

  @override
  CardScreenState createState() => CardScreenState(cardName);
}

class CardScreenState extends State<CardScreen> {
  late String cardName;

  CardScreenState(this.cardName);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(244, 245, 247, 1.0),
      appBar: AppBar(
          backgroundColor: Colors.white,
          leading: Builder(builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.clear),
              color: Colors.black,
              onPressed: () {},
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
                padding:
                const EdgeInsets.only(left: 25.0, top: 15.0, bottom: 20.0),
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
                    top: BorderSide(color: Colors.grey.shade600),
                    bottom: BorderSide(color: Colors.grey.shade600)),
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
                    top: BorderSide(color: Colors.grey.shade600),
                    bottom: BorderSide(color: Colors.grey.shade600)),
              ),
              child: Row(
                children: [
                  Icon(Icons.label),
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
                    top: BorderSide(color: Colors.grey.shade600),
                    bottom: BorderSide(color: Colors.grey.shade600)),
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
                bottom: 20.0,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                    top: BorderSide(color: Colors.grey.shade600),
                    bottom: BorderSide(color: Colors.grey.shade600)),
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
                    bottom: BorderSide(color: Colors.grey.shade600)),
              ),
              child: Row(
                children: [
                  SizedBox(width: 24,),
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
                    top: BorderSide(color: Colors.grey.shade600),
                    bottom: BorderSide(color: Colors.grey.shade600)),
              ),
              child: Row(
                children: [
                  Icon(Icons.label),
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
                    top: BorderSide(color: Colors.grey.shade600),
                    bottom: BorderSide(color: Colors.grey.shade600)),
              ),
              child: Row(
                children: [
                  Icon(Icons.label),
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
          ],
        ),
      )
    );
  }
}
