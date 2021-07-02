import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chips_input/flutter_chips_input.dart';
import 'package:trello_clone/models/user.dart';

import '../../route_path.dart';

class CreateWorkspaceScreen extends StatefulWidget {
  @override
  CreateWorkspaceScreenState createState() => CreateWorkspaceScreenState();
}

class CreateWorkspaceScreenState extends State<CreateWorkspaceScreen> {
  final formKey = GlobalKey<FormState>();
  var nameTxtCtrl = TextEditingController();
  final _chipKey = GlobalKey<ChipsInputState>();

  List<Users> users = [
    Users(
      userID: "12345",
      userName: "name1",
      profileName: "Name 1",
      email: '123456@gmail.com',
      avatar: 'assets/images/BlueBG.png',
      workspaceList: [],
    ),
    Users(
      userID: "12345",
      userName: "name2",
      profileName: "Name 2",
      email: '123456@gmail.com',
      avatar: 'assets/images/BlueBG.png',
      workspaceList: [],
    ),
    Users(
      userID: "12345",
      userName: "name3",
      profileName: "Name 3",
      email: '123456@gmail.com',
      avatar: 'assets/images/BlueBG.png',
      workspaceList: [],
    ),
    Users(
      userID: "12345",
      userName: "Test4",
      profileName: "Cun cun cute",
      email: '123456@gmail.com',
      avatar: 'assets/images/BlueBG.png',
      workspaceList: [],
    ),
  ];

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
                child: ChipsInput(
                  key: _chipKey,
                  keyboardAppearance: Brightness.dark,
                  textCapitalization: TextCapitalization.words,
                  textStyle: const TextStyle(
                      fontSize: 20.0),
                  decoration: const InputDecoration(
                    labelText: 'Thêm thành viên',
                    labelStyle: TextStyle(fontSize: 18.0),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    contentPadding: EdgeInsets.only(bottom: 0.0),
                  ),
                  findSuggestions: (String query) {
                    print("Query: '$query'");
                    if (query.isNotEmpty) {
                      var lowercaseQuery = query.toLowerCase();
                      return users.where((profile) {
                        return profile.userName
                            .toLowerCase()
                            .contains(query.toLowerCase()) ||
                            profile.email
                                .toLowerCase()
                                .contains(query.toLowerCase());
                      }).toList(growable: false)
                        ..sort((a, b) => a.userName
                            .toLowerCase()
                            .indexOf(lowercaseQuery)
                            .compareTo(b.userName
                            .toLowerCase()
                            .indexOf(lowercaseQuery)));
                    }
                    return users;
                  },
                  onChanged: (data) {
                    // print(data);
                  },
                  chipBuilder: (context, state, dynamic profile) {
                    return InputChip(
                      key: ObjectKey(profile),
                      label: Text(profile.userName),
                      avatar: CircleAvatar(
                        backgroundImage:
                        AssetImage(profile.avatar),
                      ),
                      onDeleted: () => state.deleteChip(profile),
                      materialTapTargetSize:
                      MaterialTapTargetSize.shrinkWrap,
                    );
                  },
                  suggestionBuilder:
                      (context, state, dynamic profile) {
                    return ListTile(
                      key: ObjectKey(profile),
                      leading: CircleAvatar(
                        backgroundImage:
                        AssetImage(profile.avatar),
                      ),
                      title: Text(profile.userName),
                      onTap: () => state.selectSuggestion(profile),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}