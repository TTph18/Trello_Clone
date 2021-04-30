import 'package:flutter/material.dart';
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
  List<String> listList = ["Tên danh sách 1", "Tên danh sách 2", "Tên danh sách 3"];
  AssetImage img = AssetImage("assets/images/BlueBG.png");
  var cardNameTxtCtrl = TextEditingController();
  var descriptionTxtCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Thêm thẻ'),
          leading: Builder(
              builder: (BuildContext context) {
                return IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    Navigator.of(context).pushNamed(MAIN_SCREEN);
                  },
                );
              }
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.check),
              onPressed: () {},
            ),
          ]),
      body: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0),
          child: Column(
            children: <Widget>[

              DropdownButtonFormField<String>(
                hint: Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Chọn bảng", style: TextStyle(color: Colors.black),),
                ),
                decoration: InputDecoration(
                  labelStyle: TextStyle(fontSize: 18.0, height: 0.9),
                  labelText: "Bảng",
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  contentPadding: EdgeInsets.only(top: 15, bottom: 4),
                  focusedBorder:UnderlineInputBorder(
                    borderSide: const BorderSide(color: Colors.green),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    selectedBoard = value;
                  });
                },
                selectedItemBuilder: (BuildContext context) {
                  return boardList.map<Widget>((String item) {
                    return Text(item, style: TextStyle(fontSize: 20.0,),);
                  }).toList();
                },
                items: boardList.map((String item) {
                  return DropdownMenuItem<String>(
                      value: item,
                      child: Row(
                        children: [
                          Text(item, style: TextStyle(fontSize: 20.0)),
                        ],
                      )
                  );
                }).toList(),
              ),

              DropdownButtonFormField<String>(
                hint: Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Chọn danh sách", style: TextStyle(color: Colors.black),),
                ),
                decoration: InputDecoration(
                  labelStyle: TextStyle(fontSize: 18.0, height: 0.9),
                  labelText: "Danh sách",
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  contentPadding: EdgeInsets.only(top: 15, bottom: 4),
                  focusedBorder:UnderlineInputBorder(
                    borderSide: const BorderSide(color: Colors.green),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    selectedList = value;
                  });
                },
                selectedItemBuilder: (BuildContext context) {
                  return listList.map<Widget>((String item) {
                    return Text(item, style: TextStyle(fontSize: 20.0,),);
                  }).toList();
                },
                items: listList.map((String item) {
                  return DropdownMenuItem<String>(
                      value: item,
                      child: Row(
                        children: [
                          Text(item, style: TextStyle(fontSize: 20.0)),
                        ],
                      )
                  );
                }).toList(),
              ),

              Stack(
                alignment: Alignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Image(
                      image: img,
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.fill,
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Container(
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 40),
                        child: Column(
                          children: [
                            TextFormField(
                              controller: cardNameTxtCtrl,
                              decoration: InputDecoration(
                                hintText: "Tên thẻ",
                                hintStyle: TextStyle(fontSize: 18.0),
                                contentPadding: EdgeInsets.only(top: 30, bottom: 0),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: const BorderSide(color: Colors.black),
                                ),
                                enabledBorder:UnderlineInputBorder(
                                  borderSide: const BorderSide(color: Colors.black),
                                ),
                              ),
                              style: TextStyle(fontSize: 20.0),

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
                                hintText: "Mô tả",
                                hintStyle: TextStyle(fontSize: 18.0),
                                contentPadding: EdgeInsets.only(top: 30, bottom: 0),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: const BorderSide(color: Colors.black),
                                ),
                                enabledBorder:UnderlineInputBorder(
                                  borderSide: const BorderSide(color: Colors.black),
                                ),
                              ),
                              style: TextStyle(fontSize: 20.0),
                            ),

                            Column(
                              children: [
                                Row(
                                  children: [
                                    
                                  ],
                                ),

                                Row(
                                  children: [

                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                  ),
                ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
    
  }
}
