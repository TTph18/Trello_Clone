import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trello_clone/models/user.dart';
import 'package:flutter_chips_input/flutter_chips_input.dart';
import 'package:trello_clone/models/workspaces.dart';
import 'package:trello_clone/services/database.dart';

class MemberInfo extends StatelessWidget {
  Workspaces workspaces;
  Users user;
  MemberInfo(this.user, this.workspaces);

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
  late Workspaces workspaces;
  MemberList(this.workspaces);
  @override
  MemberListState createState() => MemberListState(this.workspaces);
}

class MemberListState extends State<MemberList> {
  final _chipKey = GlobalKey<ChipsInputState>();
  late Workspaces workspaces;
  List<Users> WorkspaceUsers = [];

  List<Users> users = [];
  MemberListState(this.workspaces);
  @override
  void initState() {}

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: DatabaseService.streamListUser(workspaces.userList),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData)
            return Container(
                alignment: FractionalOffset.center,
                child: CircularProgressIndicator());
          for (var item in snapshot.data) {
            Users _user = Users.fromDocument(item);
            WorkspaceUsers.add(_user);
          }
          return FutureBuilder(
              future: DatabaseService.getAllUsesrData(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (!snapshot.hasData)
                  return Container(
                      alignment: FractionalOffset.center,
                      child: CircularProgressIndicator());
                for (var item in snapshot.data) {
                  Users _user = Users.fromDocument(item);
                  users.add(_user);
                }
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
                                        textCapitalization:
                                            TextCapitalization.words,
                                        // maxChips: 5,
                                        textStyle: const TextStyle(
                                            height: 1.5, fontSize: 20),
                                        decoration: const InputDecoration(
                                          // hintText: formControl.hint,
                                          labelText: 'Tài khoản hoặc email',
                                        ),
                                        findSuggestions: (String query) {
                                          print("Query: '$query'");
                                          if (query.isNotEmpty) {
                                            var lowercaseQuery =
                                                query.toLowerCase();
                                            return users.where((profile) {
                                              return profile.userName
                                                      .toLowerCase()
                                                      .contains(query
                                                          .toLowerCase()) ||
                                                  profile.email
                                                      .toLowerCase()
                                                      .contains(
                                                          query.toLowerCase());
                                            }).toList(growable: false)
                                              ..sort((a, b) => a.userName
                                                  .toLowerCase()
                                                  .indexOf(lowercaseQuery)
                                                  .compareTo(b.userName
                                                      .toLowerCase()
                                                      .indexOf(
                                                          lowercaseQuery)));
                                          }
                                          return users;
                                        },
                                        onChanged: (data) {
                                          // print(data);
                                        },
                                        chipBuilder:
                                            (context, state, dynamic profile) {
                                          return InputChip(
                                            key: ObjectKey(profile),
                                            label: Text(profile.userName),
                                            avatar: CircleAvatar(
                                              backgroundImage:
                                                  AssetImage(profile.avatar),
                                            ),
                                            onDeleted: () =>
                                                state.deleteChip(profile),
                                            materialTapTargetSize:
                                                MaterialTapTargetSize
                                                    .shrinkWrap,
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
                                            onTap: () =>
                                                state.selectSuggestion(profile),
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
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16)),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              TextButton(
                                child: Text(
                                  'THÊM',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
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
                        return MemberInfo(WorkspaceUsers[index], workspaces);
                      },
                    ),
                  ),
                );
              });
        });
  }
}
