import 'package:flutter/material.dart';
import 'package:trello_clone/models/workspaces.dart';
import 'package:trello_clone/services/database.dart';
import '../../route_path.dart';

class CreateBoardScreen extends StatefulWidget {
  @override
  CreateBoardScreenState createState() => CreateBoardScreenState();
}

class CreateBoardScreenState extends State<CreateBoardScreen> {
  final formKey = GlobalKey<FormState>();
  var nameTxtCtrl = TextEditingController();
  Workspaces? selectedGroup;
  List<Workspaces> groupList = [];
  String? selectedPermission = "Không gian làm việc";
  List<String> permissionList = ["Riêng tư", "Không gian làm việc"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Tạo Bảng'),
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
                if (formKey.currentState!.validate()) {
                  DatabaseService.addBoard(
                      nameTxtCtrl.text, selectedGroup!.workspaceID);
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
                      fontSize: 18.0,
                      color: Colors.green,
                      decoration: TextDecoration.none),
                  labelText: "Tên bảng",
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  contentPadding: EdgeInsets.only(bottom: 0.0),
                ),
                style: TextStyle(
                    fontSize: 20.0, decoration: TextDecoration.underline),
                // The validator receives the text that the user has entered.
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Tên bảng không được để trống';
                  }
                  return null;
                },
              ),
              FutureBuilder(
                  future: DatabaseService.getUserWorkspaceList(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (!snapshot.hasData) {
                      return Container(
                          alignment: FractionalOffset.center,
                          child: CircularProgressIndicator());
                    }
                    for (var item in snapshot.data) {
                      Workspaces _wp = Workspaces.fromDocument(item);
                      groupList.add(_wp);
                    }
                    selectedGroup = groupList.first;
                    return DropdownButtonFormField<String>(
                      value: selectedGroup!.workspaceID,
                      decoration: InputDecoration(
                        labelStyle: TextStyle(fontSize: 18.0, height: 0.9),
                        labelText: "Không gian làm việc",
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        contentPadding: EdgeInsets.only(top: 15, bottom: 4),
                      ),
                      onChanged: (newValue) {
                        setState(() {
                          selectedGroup = groupList.where(
                                  (element) => element.workspaceID == newValue)
                              as Workspaces?;
                        });
                      },
                      selectedItemBuilder: (BuildContext context) {
                        return groupList.map<Widget>((Workspaces item) {
                          return Text(
                            item.workspaceName,
                            style: TextStyle(
                              fontSize: 20.0,
                            ),
                          );
                        }).toList();
                      },
                      items: groupList == null
                          ? []
                          : groupList.map((Workspaces item) {
                              return DropdownMenuItem<String>(
                                  value: item.workspaceID,
                                  child: Row(
                                    children: [
                                      Icon(Icons.group),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      Text(item.workspaceName,
                                          style: TextStyle(fontSize: 20.0)),
                                    ],
                                  ));
                            }).toList(),
                    );
                  }),
              DropdownButtonFormField<String>(
                  value: selectedPermission,
                  decoration: InputDecoration(
                    labelStyle: TextStyle(fontSize: 18.0, height: 0.9),
                    labelText: "Quyền xem",
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    contentPadding: EdgeInsets.only(top: 15, bottom: 4),
                  ),
                  onChanged: (value) {
                    setState(() {
                      selectedPermission = permissionList
                          .where((element) => element == value) as String?;
                    });
                  },
                  selectedItemBuilder: (BuildContext context) {
                    return permissionList.map<Widget>((String item) {
                      return Text(
                        item,
                        style: TextStyle(
                          fontSize: 20.0,
                        ),
                      );
                    }).toList();
                  },
                  items: [
                    DropdownMenuItem(
                      value: "Riêng tư",
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Icon(Icons.lock),
                              SizedBox(
                                width: 15,
                              ),
                              Text("Riêng tư",
                                  style: TextStyle(fontSize: 20.0)),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                              "Đây là bảng riêng tư. Chỉ những người được thêm vào bảng mới có thể xem và chỉnh sửa bảng.",
                              style: TextStyle(fontSize: 18.0)),
                          SizedBox(
                            height: 15,
                          ),
                        ],
                      ),
                    ),
                    DropdownMenuItem(
                      value: "Không gian làm việc",
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Icon(Icons.group),
                              SizedBox(
                                width: 15,
                              ),
                              Text("Không gian làm việc",
                                  style: TextStyle(fontSize: 20.0)),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                              "Bảng hiển thị với các thành viên của Không gian làm việc $selectedGroup. Chỉ những người được thêm vào bảng mới có quyền chỉnh sửa.",
                              style: TextStyle(fontSize: 18.0)),
                          SizedBox(
                            height: 15,
                          ),
                        ],
                      ),
                    ),
                  ]),
            ],
          ),
        ),
      ),
    );
  }
}
