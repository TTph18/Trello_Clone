import 'package:flutter/material.dart';
import '../../route_path.dart';

class CreateBoardScreen extends StatefulWidget {
  @override
  CreateBoardScreenState createState() => CreateBoardScreenState();
}

class CreateBoardScreenState extends State<CreateBoardScreen> {

  final _createBoardFormKey = GlobalKey<FormState>();
  var _nameTxtCtrl = TextEditingController();
  var _groupTxtCtrl = TextEditingController();
  var _permissionTxtCtrl = TextEditingController();
  String? _groupCtrl = "Ngáo";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tạo Bảng'),
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
          onPressed: () {
            if (_createBoardFormKey.currentState!.validate())
              {
                Navigator.of(context).pushNamed(MAIN_SCREEN);
              }
          },
        ),
      ]),
      body: Column(
        children: [Form(
          key: _createBoardFormKey,
          child: Padding(
            padding: const EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0),
            child: Column(
              children: <Widget>[
                TextFormField(
                  controller: _nameTxtCtrl,
                  decoration: InputDecoration(
                    labelStyle: TextStyle(fontSize: 18.0, color: Colors.green),
                    labelText: "Tên bảng",
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    contentPadding: EdgeInsets.only(bottom: 0.0),
                    focusedBorder:UnderlineInputBorder(
                      borderSide: const BorderSide(color: Colors.green),
                    ),
                  ),
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 22.0),
                  // The validator receives the text that the user has entered.
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Tên bảng không được để trống';
                    }
                    return null;
                    },
                ),
                TextFormField(
                  controller: _groupTxtCtrl,
                  decoration: InputDecoration(
                      hintText: "Nhóm"
                  ),
                  // The validator receives the text that the user has entered.
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nhóm không được để trống';
                    }
                    return null;
                    },
                ),
                TextFormField(
                  controller: _permissionTxtCtrl,
                  decoration: InputDecoration(
                      hintText: "Quyền xem"
                  ),
                  // The validator receives the text that the user has entered.
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Quyền xem không được để trống';
                    }
                    return null;
                    },
                ),
                DropdownButtonFormField<String>(
                  value: _groupCtrl,
                  items: ["Ngáo", "Shop Ngáo", "Ngáo Ngơ"].map((group) => DropdownMenuItem(
                    child: Text(group),
                    value: group,
                  )).toList(),
                  decoration: InputDecoration(
                    labelStyle: TextStyle(fontSize: 18.0, color: Colors.green),
                    labelText: "Nhóm",
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                  ),
                  onChanged: (value) {
                    setState(() {
                      _groupCtrl = value;
                    });
                    },
                ),
              ],
            ),
          ),
        ),
        ],
      ),
    );
  }
}
