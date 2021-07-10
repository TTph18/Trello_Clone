import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trello_clone/models/user.dart';
import 'package:flutter_chips_input/flutter_chips_input.dart';
import 'package:trello_clone/models/workspaces.dart';
import 'package:trello_clone/services/database.dart';
import 'package:trello_clone/widgets/reuse_widget/avatar.dart';

class MemberInfo extends StatelessWidget {
  Workspaces workspaces;
  Users user;
  MemberInfo(this.user, this.workspaces);
  String uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10.0, 8.0, 0, 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: [
              avatar(40, 40, Colors.grey, Image.network(user.avatar)),
              SizedBox(
                width: 20,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  user.userName,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              IconButton(
                  onPressed: () {
                    DatabaseService.deleteUserInWorkspace(user.userID, workspaces.workspaceID);
                  },
                  icon: Icon(Icons.close, color: (uid != workspaces.createdBy || user.userID != workspaces.createdBy) ? Colors.transparent : Colors.black)),
            ],
          ),
        ],
      ),
    );
  }
}

class MemberList extends StatefulWidget {
  late Workspaces workspaces;
  MemberList(this.workspaces);
  @override
  MemberListState createState() => MemberListState(this.workspaces);
}

class MemberListState extends State<MemberList> {
  final _chipKey = GlobalKey<ChipsInputState>();
  late Workspaces workspaces;
  List<Users> WorkspaceUsers = [];
  List<Users> selectedUsers = [];
  late Future<List<Users>> futureUserList;
  String uid = FirebaseAuth.instance.currentUser!.uid;

  List<Users> users = [];

  MemberListState(this.workspaces);

  Future<List<Users>> getListUser() async {
    var doc = await DatabaseService.getAllUsersData();
    List<Users> temp = [];
    for (var item in doc) {
      Users _user = Users.fromDocument(item);
      temp.add(_user);
    }
    return temp;
  }

  @override
  void initState() {
    futureUserList = getListUser();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: DatabaseService.streamListUser(workspaces.userList),
        builder: (BuildContext context1, AsyncSnapshot snapshot1) {
          if (!snapshot1.hasData) return Container(alignment: FractionalOffset.center, child: CircularProgressIndicator());
          WorkspaceUsers = [];
          for (var item in snapshot1.data) {
            Users _user = Users.fromDocument(item);
            WorkspaceUsers.add(_user);
          }
          return FutureBuilder(
              future: futureUserList,
              builder: (BuildContext context2, AsyncSnapshot snapshot) {
                if (!snapshot.hasData) return Container(alignment: FractionalOffset.center, child: CircularProgressIndicator());
                users = [];
                for (var item in snapshot.data) {
                  if (!WorkspaceUsers.contains(users)) users.add(item);
                }
                print("NUM USERRRR1: " + users.length.toString());
                users.removeWhere((element) => element.userID == uid);

                print("NUM USERRRR2: " + users.length.toString());
                return Scaffold(
                  appBar: AppBar(
                    title: Text("Thành viên"),
                    actions: [
                      IconButton(
                        onPressed: () => showDialog<String>(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text(
                                  'Thêm thành viên',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SingleChildScrollView(
                                      child: Column(
                                        children: <Widget>[
                                          ChipsInput(
                                            key: _chipKey,
                                            keyboardAppearance: Brightness.dark,
                                            textCapitalization: TextCapitalization.words,
                                            // maxChips: 5,
                                            textStyle: const TextStyle(height: 1.5, fontSize: 20),
                                            decoration: const InputDecoration(
                                              // hintText: formControl.hint,
                                              labelText: 'Tài khoản hoặc email',
                                            ),
                                            findSuggestions: (String query) {
                                              if (query.isNotEmpty) {
                                                var lowercaseQuery = query.toLowerCase();
                                                return users.where((profile) {
                                                  return profile.userName.toLowerCase().contains(query.toLowerCase()) ||
                                                      profile.email.toLowerCase().contains(query.toLowerCase());
                                                }).toList(growable: false)
                                                  ..sort((a, b) => a.userName
                                                      .toLowerCase()
                                                      .indexOf(lowercaseQuery)
                                                      .compareTo(b.userName.toLowerCase().indexOf(lowercaseQuery)));
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
                                                  backgroundImage: NetworkImage(profile.avatar),
                                                ),
                                                onDeleted: () {
                                                  state.deleteChip(profile);
                                                  selectedUsers.remove(profile);
                                                },
                                                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                              );
                                            },
                                            suggestionBuilder: (context, state, dynamic profile) {
                                              return ListTile(
                                                key: ObjectKey(profile),
                                                leading: CircleAvatar(
                                                  backgroundImage: NetworkImage(profile.avatar),
                                                ),
                                                title: Text(profile.userName),
                                                onTap: () {
                                                  if (checkUserAvailable(profile.userID)) {
                                                    state.selectSuggestion(profile);
                                                    selectedUsers.add(profile);
                                                    setState(() {
                                                      users.remove(profile);
                                                    });
                                                  } else {
                                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                      content: const Text('Thành viên đã có trong không gian làm việc'),
                                                      duration: const Duration(seconds: 1),
                                                    ));
                                                  }
                                                  ;
                                                },
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                    child: Text('HỦY', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                    onPressed: () {
                                      selectedUsers.clear();
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  TextButton(
                                    child: Text(
                                      'THÊM',
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                    ),
                                    onPressed: () {
                                      print("ACCESSSSSSS");
                                      print("SELECTEDUSER: " + selectedUsers[0].userName);
                                      DatabaseService.addUserToWorkspace(workspaces.workspaceID, selectedUsers);
                                      print("GO OUTTTT");
                                      selectedUsers.clear();
                                      refresh();
                                      Navigator.of(context).pop();
                                    },
                                  )
                                ],
                              );
                            }),
                        icon: Icon(
                          Icons.group_add,
                        ),
                      ),
                    ],
                  ),
                  body: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ListView.builder(
                      itemCount: WorkspaceUsers.length,
                      itemBuilder: (context, index) {
                        return MemberInfo(WorkspaceUsers[index], workspaces);
                      },
                    ),
                  ),
                );
              });
        });
  }

  bool checkUserAvailable(String userID) {
    for (var item in users) {
      if (userID == item.userID) return true;
    }
    return false;
  }

  void refresh()
  {
    setState(() {

    });
  }

  showAlertDialog(BuildContext context, String alertdialog) {
    // set up the buttons
    Widget cancelButton = ElevatedButton(
      child: Text("Đóng"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      content: Text(alertdialog),
      actions: [
        cancelButton,
      ],
    );



    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
