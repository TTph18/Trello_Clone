import 'package:flutter/material.dart';
import '../../route_path.dart';

class CreateBoardScreen extends StatefulWidget {
  @override
  CreateBoardScreenState createState() => CreateBoardScreenState();
}

class CreateBoardScreenState extends State<CreateBoardScreen> {

  final _createBoardFormKey = GlobalKey<FormState>();
  var _nameTxtCtrl = TextEditingController();
  String? selectedGroup = "Ngáo";
  List<String> groupList = ["Ngáo", "Shop Ngáo", "Ngáo Ngơ"];
  String? selectedPermission = "Không gian làm việc";
  List<String> permissionList = ["Riêng tư", "Không gian làm việc", "Công khai"];

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
                    labelStyle: TextStyle(fontSize: 18.0, color: Colors.green, decoration: TextDecoration.none),
                    labelText: "Tên bảng",
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    contentPadding: EdgeInsets.only(bottom: 0.0),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: const BorderSide(color: Colors.green),
                    ),
                    enabledBorder:UnderlineInputBorder(
                      borderSide: const BorderSide(color: Colors.green),
                    ),
                  ),
                  style: TextStyle(fontSize: 20.0, decoration: TextDecoration.underline),
                  // The validator receives the text that the user has entered.
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Tên bảng không được để trống';
                    }
                    return null;
                    },
                ),
                DropdownButtonFormField<String>(
                  value: selectedGroup,
                  decoration: InputDecoration(
                    labelStyle: TextStyle(fontSize: 18.0, height: 0.9),
                    labelText: "Không gian làm việc",
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    contentPadding: EdgeInsets.only(top: 15, bottom: 4),
                    focusedBorder:UnderlineInputBorder(
                      borderSide: const BorderSide(color: Colors.green),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      selectedGroup = value;
                    });
                  },

                  selectedItemBuilder: (BuildContext context) {
                    return groupList.map<Widget>((String item) {
                      return Text(item, style: TextStyle(fontSize: 20.0,),);
                    }).toList();
                  },
                  items: groupList.map((String item) {
                    return DropdownMenuItem<String>(
                        value: item,
                        child: Row(
                          children: [
                            Icon(Icons.group),
                            SizedBox(width: 15,),
                            Text(item, style: TextStyle(fontSize: 20.0)),
                          ],
                        )
                    );
                  }).toList(),
                ),
                DropdownButtonFormField<String>(
                  value: selectedPermission,
                  decoration: InputDecoration(
                    labelStyle: TextStyle(fontSize: 18.0, height: 0.9),
                    labelText: "Quyền xem",
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    contentPadding: EdgeInsets.only(top: 15, bottom: 4),
                    focusedBorder:UnderlineInputBorder(
                      borderSide: const BorderSide(color: Colors.green),
                    ),
                  ),

                  onChanged: (value) {
                    setState(() {
                      selectedPermission = value;
                    });
                  },

                  selectedItemBuilder: (BuildContext context) {
                    return permissionList.map<Widget>((String item) {
                      return Text(item, style: TextStyle(fontSize: 20.0,),);
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
                              SizedBox(width: 15,),
                              Text("Riêng tư", style: TextStyle(fontSize: 20.0)),
                            ],
                          ),
                          SizedBox(height: 5,),
                          Text("Đây là bảng riêng tư. Chỉ những người được thêm vào bảng mới có thể xem và chỉnh sửa bảng.", style: TextStyle(fontSize: 18.0)),
                          SizedBox(height: 15,),
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
                              SizedBox(width: 15,),
                              Text("Không gian làm việc", style: TextStyle(fontSize: 20.0)),
                            ],
                          ),
                          SizedBox(height: 5,),
                          Text("Bảng hiển thị với các thành viên của Không gian làm việc $selectedGroup. Chỉ những người được thêm vào bảng mới có quyền chỉnh sửa.", style: TextStyle(fontSize: 18.0)),
                          SizedBox(height: 15,),
                        ],
                      ),
                    ),
                    DropdownMenuItem(
                      value: "Công khai",
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Icon(Icons.public),
                              SizedBox(width: 15,),
                              Text("Công khai", style: TextStyle(fontSize: 20.0)),
                            ],
                          ),
                          SizedBox(height: 5,),
                          Text("Đây là bảng công khai. Bất kỳ ai có liên kết tới bảng này đều có thể xem bảng. Bảng có thể được tìm thấy trên các công cụ tìm kiếm như Google. Chỉ những người được thêm vào bảng mới có quyền chỉnh sửa.", style: TextStyle(fontSize: 18.0)),
                        ],
                      ),
                    ),
                  ]
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
