import 'package:flutter/material.dart';
import 'package:trello_clone/route_path.dart';

class CreateBoardForm extends StatefulWidget {
  @override
  CreateBoardFormState createState() {
    return CreateBoardFormState();
  }
}

class CreateBoardFormState extends State<CreateBoardForm> {
  final _createBoardFormKey = GlobalKey<FormState>();
  var _nameTxtCtrl = TextEditingController();
  var _groupTxtCtrl = TextEditingController();
  var _permissionTxtCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
      key: _createBoardFormKey,
      child: Padding(
        padding: const EdgeInsets.only(left: 50.0, right: 50.0),
        child: Column(
          children: <Widget>[
            TextFormField(
              controller: _nameTxtCtrl,
              decoration: InputDecoration(
                  hintText: "Tên bảng"
              ),
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
            ElevatedButton(
                onPressed: () {
                  if(_createBoardFormKey.currentState.validate()) {
                    Navigator.of(context).pushNamed(MAIN_SCREEN);
                  }
                },
                child: Text("Tạo bảng")
            ),
          ],
        ),
      ),
    );
  }
}