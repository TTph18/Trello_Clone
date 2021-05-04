import 'package:flutter/material.dart';
import 'package:trello_clone/icons/app_icons.dart';
import 'package:trello_clone/screens/main_screen/main_screen.dart';
import '../../route_path.dart';

class CreateCardScreen extends StatefulWidget {
  @override
  CreateCardScreenState createState() => CreateCardScreenState();
}

class CreateCardScreenState extends State<CreateCardScreen> {
  final formKey = GlobalKey<FormState>();
  String? selectedBoard = "";
  List<String> boardList = ["Tên bảng 1", "Tên bảng 2", "Tên bảng 3"];
  String? selectedList = "";
  List<String> listList = [
    "Tên danh sách 1",
    "Tên danh sách 2",
    "Tên danh sách 3"
  ];
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
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
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
                  setState(() {
                    selectedBoard = value;
                  });
                },
                selectedItemBuilder: (BuildContext context) {
                  return boardList.map<Widget>((String item) {
                    return Text(
                      item,
                      style: TextStyle(
                        fontSize: 20.0,
                      ),
                    );
                  }).toList();
                },
                items: boardList.map((String item) {
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
                        child: Table(
                          columnWidths: const <int, TableColumnWidth>{
                            0: IntrinsicColumnWidth(),
                            1: FlexColumnWidth(),
                          },
                          children: [
                            selectedBoard == ""
                                ? TableRow(
                                    children: [
                                      SizedBox(),
                                      SizedBox(),
                                    ],
                                  )
                                : TableRow(
                                    children: [
                                      IconButton(
                                        icon: Icon(MyFlutterApp.clock),
                                        alignment: Alignment.centerLeft,
                                        onPressed: () {},
                                      ),
                                      CircleAvatar(
                                        radius: 25,
                                        backgroundColor: Colors.green,
                                        child: IconButton(
                                          icon: Icon(
                                            Icons.add,
                                            color: Colors.white,
                                            size: 18,
                                          ),
                                          onPressed: () {},
                                        ),
                                      ),
                                    ],
                                  ),
                            TableRow(
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
                            TableRow(
                              children: [
                                SizedBox(),
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
