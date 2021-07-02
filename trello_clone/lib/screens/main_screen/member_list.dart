import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trello_clone/models/user.dart';
import 'package:flutter_chips_input/flutter_chips_input.dart';

class MemberInfo extends StatelessWidget {
  Users user;
  MemberInfo(this.user);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10.0, 8.0, 0, 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: new BoxDecoration(
                  shape: BoxShape.circle,
                  image: new DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage(user.avatar),
                  ),
                ),
              ),
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
                    ///TODO: Delete member from workspace
                  },
                  icon: Icon(Icons.close)),
            ],
          ),
        ],
      ),
    );
  }
}

class MemberList extends StatefulWidget {
  @override
  MemberListState createState() => MemberListState();
}

class MemberListState extends State<MemberList> {
  final _chipKey = GlobalKey<ChipsInputState>();
  List<Users> WorkspaceUsers = [
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
  ];

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
  void initState() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Thành viên"),
        actions: [
          IconButton(
            onPressed: () => showDialog<String>(
              context: context,
              builder: (BuildContext context) => AlertDialog(
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
                            textStyle:
                                const TextStyle(height: 1.5, fontSize: 20),
                            decoration: const InputDecoration(
                              // hintText: formControl.hint,
                              labelText: 'Tài khoản hoặc email',
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
                                  backgroundImage: AssetImage(profile.avatar),
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
                                  backgroundImage: AssetImage(profile.avatar),
                                ),
                                title: Text(profile.userName),
                                onTap: () => state.selectSuggestion(profile),
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
                    child: Text('HỦY',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: Text(
                      'Thêm',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    onPressed: () {
                      ///TODO: Add user in chip to workspace
                    },
                  )
                ],
              ),
            ),
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
            return MemberInfo(WorkspaceUsers[index]);
          },
        ),
      ),
    );
  }
}
