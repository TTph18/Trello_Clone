import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../route_path.dart';

class CreateWorkspaceScreen extends StatefulWidget {
  @override
  CreateWorkspaceScreenState createState() => CreateWorkspaceScreenState();
}

class CreateWorkspaceScreenState extends State<CreateWorkspaceScreen> {
  final formKey = GlobalKey<FormState>();
  var nameTxtCtrl = TextEditingController();
  var memberTxtCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Tạo không gian làm việc'),
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
                if (formKey.currentState!.validate())
                {
                  Navigator.of(context).pushNamed(MAIN_SCREEN);
                }
              },
            ),
          ]
      ),

      body: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0),
          child: Column(
            children: <Widget>[

              TextFormField(
                controller: nameTxtCtrl,
                decoration: InputDecoration(
                  labelStyle: TextStyle(fontSize: 18.0, decoration: TextDecoration.none),
                  labelText: "Tên không gian làm việc",
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  contentPadding: EdgeInsets.only(bottom: 0.0),
                ),
                style: TextStyle(fontSize: 20.0, decoration: TextDecoration.underline),
                // The validator receives the text that the user has entered.
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Tên không gian làm việc không được để trống';
                  }
                  return null;
                },
              ),

              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: TextFormField(
                  controller: memberTxtCtrl,
                  decoration: InputDecoration(
                    labelStyle: TextStyle(fontSize: 18.0, decoration: TextDecoration.none),
                    labelText: "Thêm thành viên",
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    contentPadding: EdgeInsets.only(bottom: 0.0),
                  ),
                  style: TextStyle(fontSize: 20.0, decoration: TextDecoration.underline),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
  
}