import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chips_input/flutter_chips_input.dart';
import 'package:trello_clone/models/user.dart';
import 'package:trello_clone/services/database.dart';

import '../../route_path.dart';

class CreateWorkspaceScreen extends StatefulWidget {
  @override
  CreateWorkspaceScreenState createState() => CreateWorkspaceScreenState();
}

class CreateWorkspaceScreenState extends State<CreateWorkspaceScreen> {
  final formKey = GlobalKey<FormState>();
  var nameTxtCtrl = TextEditingController();
  final _chipKey = GlobalKey<ChipsInputState>();
  late Future<List<Users>> futureUserList;
  late Future<Users> futureCurrentUser;
  List<String> usersIDList = [];
  late Users currentUser;
  late List<Users> selectedUser = [];
  String uid = FirebaseAuth.instance.currentUser!.uid;
  List<Users> users = [];
  Future<List<Users>> getListUser() async {
    var doc = await DatabaseService.getAllUsersData();
    List<Users> temp = [];
    for (var item in doc) {
      Users _user = Users.fromDocument(item);
      temp.add(_user);
    }
    return temp;
  }

  Future<Users> getCurrentUser() async {
    var doc = await DatabaseService.getCurrentUserData();
    Users _user = Users.fromDocument(doc);
    return _user;
  }

  @override
  void initState() {
    super.initState();
    futureUserList = getListUser();
    futureCurrentUser = getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Tạo không gian làm việc'),
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
              onPressed: () {
                for (var item in selectedUser){
                  usersIDList.add(item.userID);
                }
                if (formKey.currentState!.validate()) {
                  DatabaseService.addWorkspace(nameTxtCtrl.text, usersIDList);
                  Navigator.of(context).pushNamed(MAIN_SCREEN);
                }
              },
            ),
          ]),
      body: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0),
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: nameTxtCtrl,
                decoration: InputDecoration(
                  labelStyle: TextStyle(
                      fontSize: 18.0, decoration: TextDecoration.none),
                  labelText: "Tên không gian làm việc",
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  contentPadding: EdgeInsets.only(bottom: 0.0),
                ),
                style: TextStyle(
                    fontSize: 20.0, decoration: TextDecoration.underline),
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
                child: FutureBuilder(
                    future: Future.wait([futureUserList, futureCurrentUser]),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (!snapshot.hasData) {
                        return Container(
                            alignment: FractionalOffset.center,
                            child: CircularProgressIndicator());
                      } else {
                        users.clear();
                        users = snapshot.data[0];
                        currentUser = snapshot.data[1];
                        users.removeWhere((element) => element.userID == currentUser.userID);
                        selectedUser.add(currentUser);
                      }
                      return ChipsInput(
                        key: _chipKey,
                        keyboardAppearance: Brightness.dark,
                        textCapitalization: TextCapitalization.words,
                        textStyle: const TextStyle(fontSize: 20.0),
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
                              return profile.profileName
                                      .toLowerCase()
                                      .contains(query.toLowerCase());
                            }).toList(growable: false)
                              ..sort((a, b) => a.profileName
                                  .toLowerCase()
                                  .indexOf(lowercaseQuery)
                                  .compareTo(b.profileName
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
                            label: Text(profile.profileName),
                            avatar: CircleAvatar(
                              backgroundImage: NetworkImage(profile.avatar),
                            ),
                            onDeleted: () {
                              if(profile.userID != uid) {
                                  state.deleteChip(profile);
                                  selectedUser.remove(profile);
                              }
                            },
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                          );
                        },
                        suggestionBuilder: (context, state, dynamic profile) {
                          return ListTile(
                            key: ObjectKey(profile),
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(profile.avatar),
                            ),
                            title: Text(profile.profileName),
                            onTap: () {
                              state.selectSuggestion(profile);
                              selectedUser.add(profile);
                              },
                          );
                        },
                      );
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }
}
