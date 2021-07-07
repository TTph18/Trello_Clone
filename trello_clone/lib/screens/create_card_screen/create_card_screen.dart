import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:trello_clone/icons/app_icons.dart';
import 'package:trello_clone/models/boards.dart';
import 'package:trello_clone/models/lists.dart';
import 'package:trello_clone/models/user.dart';
import 'package:trello_clone/models/workspaces.dart';
import 'package:trello_clone/services/database.dart';
import 'package:trello_clone/screens/card_screen/board_item.dart';
import '../../route_path.dart';

class CreateCardScreen extends StatefulWidget {
  @override
  CreateCardScreenState createState() => CreateCardScreenState();
}



class CreateCardScreenState extends State<CreateCardScreen> {
  final formKey = GlobalKey<FormState>();
  Boards nullBr = new Boards(
      boardID: "",
      userList: [],
      boardName: "",
      createdBy: "",
      background: "",
      isPersonal: false,
      workspaceID: "");
  late Boards selectedBoard = nullBr;
  late List<Workspaces> group = [];
  late Future<List<Users>> futureUserList;
  late List<BoardItem> boardItems = [];

  List<String> boardList = ["Tên bảng 1", "Tên bảng 2", "Tên bảng 3"];
  late Lists selectedList = Lists(listID: "", listName: "", cardList: [], position: 1);
  late List<Lists> listList = [];
  late List<Users> users = [];

  List<Users> pickedUsers = [];
  Future<List<Users>> getListUser() async {
    var doc = await DatabaseService.getListUserData(selectedBoard.userList);
    List<Users> temp = [];
    for (var item in doc) {
      Users _user = Users.fromDocument(item);
      temp.add(_user);
    }
    return temp;
  }

  @override
  void initState() {
    super.initState();
    futureUserList = getListUser();
    selectedList = Lists(listID: "", listName: "", cardList: [], position: 1);
  }

  var cardNameTxtCtrl = TextEditingController();
  var descriptionTxtCtrl = TextEditingController();

  ///Date picker
  int dateTypePicked = 0;

  /// 0 = no date is picked, 1 = start date is picked, 2 = end date is picked
  DateTime selectedDate = DateTime.now();
  var startDateTxtCtrl = TextEditingController();
  var endDateTxtCtrl = TextEditingController();

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = (await showDatePicker(
        context: context,
        initialDate: selectedDate,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(2015),
        lastDate: DateTime(2101)))!;
    setState(() {
      selectedDate = picked;
      switch (dateTypePicked) {
        case 1:
          startDate = selectedDate.toString();
          if (selectedDate.year != DateTime.now().year)
            startDateTxtCtrl.text = selectedDate.day.toString() +
                " thg " +
                selectedDate.month.toString() +
                ", " +
                selectedDate.year.toString();
          else
            startDateTxtCtrl.text = selectedDate.day.toString() +
                " thg " +
                selectedDate.month.toString();
          break;
        case 2:
          endDate = selectedDate.toString();
          if (selectedDate.year != DateTime.now().year)
            endDateTxtCtrl.text = selectedDate.day.toString() +
                " thg " +
                selectedDate.month.toString() +
                ", " +
                selectedDate.year.toString();
          else
            endDateTxtCtrl.text = selectedDate.day.toString() +
                " thg " +
                selectedDate.month.toString();
          break;
        default:
          startDate = "";
          endDate ="";
          startDateTxtCtrl.text = "";
          endDateTxtCtrl.text = "";
      }
    });
  }

  ///Time picker
  int timeTypePicked = 0;

  /// 0 = no time is picked, 1 = start time is picked, 2 = end time is picked
  TimeOfDay selectedTime = TimeOfDay(hour: 9, minute: 0);
  var startTimeTxtCtrl = TextEditingController();
  var endTimeTxtCtrl = TextEditingController();
  String startDate = "";
  String startTime = "";
  String endDate = "";
  String endTime = "";

  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay picked = (await showTimePicker(
      context: context,
      initialTime: selectedTime,
    ))!;
    setState(() {
      selectedTime = picked;
      switch (timeTypePicked) {
        case 1:
          startTimeTxtCtrl.text = selectedTime.hour.toString() + ":";
          startTime = selectedTime.format(context);
          if (selectedTime.minute >= 10)
            startTimeTxtCtrl.text =
                startTimeTxtCtrl.text + selectedTime.minute.toString();
          else
            startTimeTxtCtrl.text =
                startTimeTxtCtrl.text + "0" + selectedTime.minute.toString();
          break;
        case 2:
          endTimeTxtCtrl.text = selectedTime.hour.toString() + ":";
          endTime = selectedTime.format(context);
          if (selectedTime.minute >= 10)
            endTimeTxtCtrl.text =
                endTimeTxtCtrl.text + selectedTime.minute.toString();
          else
            endTimeTxtCtrl.text =
                endTimeTxtCtrl.text + "0" + selectedTime.minute.toString();
          break;
        default:
          startTime = "";
          endTime ="";
          startTimeTxtCtrl.text = "";
          endTimeTxtCtrl.text = "";
      }
    });
  }

  String? selectedNotiTime = "Không nhắc nhở";
  List<String> notificationTimeList = [
    "Không nhắc nhở",
    "Vào ngày hết hạn",
    "5 phút trước",
    "10 phút trước",
    "15 phút trước",
    "1 giờ trước",
    "2 giờ trước",
    "1 ngày trước",
    "2 ngày trước"
  ];
  String uid = FirebaseAuth.instance.currentUser!.uid;
  ///String value to set for startDate, endDate TextButton
  String startDateStr = "";
  String endDateStr = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
          title: Text('Thêm thẻ'),
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
                List<String> userListID = [];

                for (var item in pickedUsers){
                  userListID.add(item.userID);
                }
                DatabaseService.addCard(selectedBoard.boardID, selectedList.listID, cardNameTxtCtrl.text, descriptionTxtCtrl.text, uid, userListID, startDate, endDate, startTime, endTime);
                Navigator.of(context).pushNamed(MAIN_SCREEN);
              },
            ),
          ]),
      body: Form(
        key: formKey,
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 20,
            ),

            ///Board selection
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: ButtonTheme(
                child: FutureBuilder(
                    future: DatabaseService.getUserWorkspaceList(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (!snapshot.hasData) {
                        return Container(
                            alignment: FractionalOffset.center,
                            child: CircularProgressIndicator());
                      } else {
                        group.clear();
                        for (var item in snapshot.data) {
                          Workspaces _wp = Workspaces.fromDocument(item);
                          group.add(_wp);
                        }
                      }
                      return FutureBuilder(
                          future: DatabaseService.getAllBoards(),
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            if (!snapshot.hasData) {
                              return Container(
                                  alignment: FractionalOffset.center,
                                  child: CircularProgressIndicator());
                            } else {
                              boardItems.clear();
                              for (var _item in group) {
                                boardItems.add(new BoardItem(
                                    wpname: _item.workspaceName,
                                    type: "sep",
                                    boards: nullBr));
                                for (var item in snapshot.data) {
                                  Boards _br = Boards.fromDocument(item);
                                  if (_item.workspaceID == _br.workspaceID) {
                                    boardItems.add(new BoardItem(
                                        wpname: _item.workspaceName,
                                        type: "data",
                                        boards: _br));
                                  }
                                }
                              }
                            }
                            return DropdownButtonFormField<String>(
                              icon: Icon(Icons.keyboard_arrow_down),
                              hint: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Chọn bảng",
                                  style: TextStyle(fontSize: 20.0),
                                ),
                              ),
                              decoration: InputDecoration(
                                labelStyle:
                                    TextStyle(fontSize: 18.0, height: 0.9),
                                labelText: "Bảng",
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                contentPadding: EdgeInsets.only(bottom: 0),
                              ),
                              onChanged: (value) {
                                if (boardItems[boardItems.indexWhere(
                                            (element) =>
                                                element.boards.boardID ==
                                                value)]
                                        .type ==
                                    "sep") {
                                  return;
                                }
                                setState(() {
                                  selectedBoard = (boardItems[
                                          boardItems.indexWhere((element) =>
                                              element.boards.boardID == value)]
                                      .boards);
                                });
                              },
                              selectedItemBuilder: (BuildContext context) {
                                return boardItems.map((BoardItem item) {
                                  return Text(
                                    selectedBoard.boardName,
                                    style: TextStyle(
                                      fontSize: 20.0,
                                    ),
                                  );
                                }).toList();
                              },
                              items: boardItems == null
                                  ? []
                                  : boardItems.map((BoardItem item) {
                                      return DropdownMenuItem(
                                        value: item.boards.boardID,
                                        onTap:
                                            item.type == "data" ? () {} : null,
                                        child: item.type == "data"
                                            ? Container(
                                                padding: EdgeInsets.fromLTRB(
                                                    15, 7, 15, 7),
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      padding:
                                                          EdgeInsets.fromLTRB(
                                                              0, 0, 15, 0),
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(3.0),
                                                        child: Image(
                                                          image: AssetImage(
                                                              "assets/images/BlueBG.png"),
                                                          width: 50,
                                                          height: 50,
                                                        ),
                                                      ),
                                                    ),
                                                    Text(
                                                      item.boards.boardName,
                                                      style: TextStyle(
                                                          fontSize: 20),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            : Container(
                                                height: 50,
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  border: Border(
                                                    top: BorderSide(
                                                        width: 1.0,
                                                        color: Colors.black),
                                                    bottom: BorderSide(
                                                        width: 1.0,
                                                        color: Colors.black),
                                                  ),
                                                ),
                                                child: Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                    item.wpname,
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                      );
                                    }).toList(),
                            );
                          });
                    }),
              ),
            ),

            ///Card list selection
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
              child: FutureBuilder(
                  future: DatabaseService.getlistList(selectedBoard.boardID),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (!snapshot.hasData) {
                      return DropdownButtonFormField(
                        icon: Icon(Icons.keyboard_arrow_down),
                        hint: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Chọn danh sách",
                            style: TextStyle(fontSize: 20.0),
                          ),
                        ),
                        decoration: InputDecoration(
                          labelStyle: TextStyle(fontSize: 18.0, height: 0.9),
                          labelText: "Danh sách",
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          contentPadding: EdgeInsets.only(bottom: 0),
                        ),
                        items: [],
                      );
                    } else {
                      listList.clear();
                      for (var item in snapshot.data) {
                        Lists _list = Lists.fromDocument(item);
                        listList.add(_list);
                      }
                    }
                    return DropdownButtonFormField(
                      icon: Icon(Icons.keyboard_arrow_down),
                      hint: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Chọn danh sách",
                          style: TextStyle(fontSize: 20.0),
                        ),
                      ),
                      decoration: InputDecoration(
                        labelStyle: TextStyle(fontSize: 18.0, height: 0.9),
                        labelText: "Danh sách",
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        contentPadding: EdgeInsets.only(bottom: 0),
                      ),
                      onChanged: (value) {
                        setState(() {
                          selectedList = listList[listList.indexWhere(
                                  (element) => element.listID == value)];
                        });
                      },
                      selectedItemBuilder: (BuildContext context) {
                        return listList.map<Widget>((Lists item) {
                          return Text(
                            item.listName,
                            style: TextStyle(
                              fontSize: 20.0,
                            ),
                          );
                        }).toList();
                      },
                      items: listList.map((Lists item) {
                        return DropdownMenuItem<String>(
                            value: item.listID,
                            child: Row(
                              children: [
                                Text(item.listName,
                                    style: TextStyle(fontSize: 20.0)),
                              ],
                            ));
                      }).toList(),
                    );
                  }),
            ),

            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/BlueBG.png"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  color: Colors.white,
                  child: Column(
                    children: [
                      ///Card name
                      TextFormField(
                        controller: cardNameTxtCtrl,
                        decoration: InputDecoration(
                          alignLabelWithHint: true,
                          labelStyle: TextStyle(
                            fontSize: 22.0,
                            height: 0.9,
                          ),
                          labelText: "Tên thẻ",
                          contentPadding: EdgeInsets.only(bottom: 5),
                        ),
                        style: TextStyle(fontSize: 22.0),

                        // The validator receives the text that the user has entered.
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Tên thẻ không được để trống';
                          }
                          return null;
                        },
                      ),

                      ///Description
                      TextFormField(
                        controller: descriptionTxtCtrl,
                        decoration: InputDecoration(
                          alignLabelWithHint: true,
                          labelStyle: TextStyle(
                            fontSize: 22.0,
                            height: 0.9,
                          ),
                          labelText: "Mô tả",
                          contentPadding: EdgeInsets.only(top: 20, bottom: 5),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: const BorderSide(color: Colors.black),
                          ),
                        ),
                        style: TextStyle(fontSize: 22.0),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: Column(
                          children: [
                            selectedBoard == nullBr
                                ? SizedBox()
                                : FutureBuilder(
                                    future: DatabaseService.getListUserData(selectedBoard.userList),
                                    builder: (BuildContext context,
                                        AsyncSnapshot snapshot) {
                                      if (!snapshot.hasData) {
                                        return Container(
                                            alignment: FractionalOffset.center,
                                            child: CircularProgressIndicator());
                                      } else {
                                        users.clear();
                                        for (var item in snapshot.data){
                                          Users temp = Users.fromDocument(item);
                                          users.add(temp);
                                        }
                                      }
                                      return Row(
                                        children: [
                                          IconButton(
                                            icon: Icon(
                                                MyFlutterApp.person_outline),
                                            alignment: Alignment.centerLeft,
                                            onPressed: () {},
                                          ),
                                          Container(
                                            alignment: Alignment.centerLeft,
                                            child: CircleAvatar(
                                                radius: 25,
                                                backgroundColor: Colors.green,
                                                child: PopupMenuButton<Users>(
                                                  itemBuilder: (context) =>
                                                      List.generate(
                                                    users.length,
                                                    (index) =>
                                                        PopupMenuItem<Users>(
                                                      value: users[index],
                                                      child: ListTile(
                                                        leading: CircleAvatar(
                                                          radius: 25,
                                                          backgroundImage:
                                                              AssetImage(
                                                                  users[index]
                                                                      .avatar),
                                                        ),
                                                        title: Text(
                                                            '${users[index].userName}'),
                                                      ),
                                                    ),
                                                  ),
                                                  onSelected: (value) {
                                                    setState(() {
                                                      bool isSelected = false;
                                                      for (var item in pickedUsers){
                                                        if(value.userID == item.userID) isSelected = true;
                                                      }
                                                      if(!isSelected) pickedUsers.add(value);
                                                    });
                                                  },
                                                  icon: Icon(
                                                    Icons.add,
                                                    color: Colors.white,
                                                    size: 18,
                                                  ),
                                                )),
                                          ),
                                          pickedUsers.length < 1
                                              ? SizedBox()
                                              : Container(
                                                  height: 50,
                                                  child: SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.5,
                                                    child: ListView.builder(
                                                        shrinkWrap: true,
                                                        scrollDirection:
                                                            Axis.horizontal,
                                                        itemCount:
                                                            pickedUsers.length,
                                                        itemBuilder:
                                                            (context, index) {
                                                          return CircleAvatar(
                                                            radius: 25,
                                                            backgroundImage:
                                                                AssetImage(
                                                                    pickedUsers[
                                                                            index]
                                                                        .avatar),
                                                          );
                                                        }),
                                                  ),
                                                ),
                                        ],
                                      );
                                    }),

                            ///DateStart
                            Row(
                              children: [
                                ///DateStart IconButton
                                IconButton(
                                  icon: Icon(MyFlutterApp.clock),
                                  alignment: Alignment.centerLeft,
                                  onPressed: () {
                                    startDateTxtCtrl.text =
                                        selectedDate.day.toString() +
                                            " thg " +
                                            selectedDate.month.toString();
                                    startTimeTxtCtrl.text =
                                        selectedTime.hour.toString() + ":";
                                    if (selectedTime.minute >= 10)
                                      startTimeTxtCtrl.text =
                                          startTimeTxtCtrl.text +
                                              selectedTime.minute.toString();
                                    else
                                      startTimeTxtCtrl.text =
                                          startTimeTxtCtrl.text +
                                              "0" +
                                              selectedTime.minute.toString();
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          AlertDialog(
                                        title: const Text(
                                          'Ngày bắt đầu',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        content: Container(
                                          height: 120,
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            3.7,
                                                    child: TextField(
                                                      controller:
                                                          startDateTxtCtrl,
                                                      readOnly: true,
                                                      showCursor: true,
                                                      onTap: () {
                                                        dateTypePicked = 1;
                                                        _selectDate(context);
                                                      },
                                                      decoration:
                                                          InputDecoration(
                                                        hintText: "Chọn ngày",
                                                        contentPadding:
                                                            const EdgeInsets
                                                                    .only(
                                                                bottom: 0),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            3.7,
                                                    child: TextField(
                                                      controller:
                                                          startTimeTxtCtrl,
                                                      readOnly: true,
                                                      showCursor: true,
                                                      onTap: () {
                                                        timeTypePicked = 1;
                                                        _selectTime(context);
                                                      },
                                                      decoration:
                                                          InputDecoration(
                                                        hintText:
                                                            "Chọn thời gian",
                                                        contentPadding:
                                                            const EdgeInsets
                                                                    .only(
                                                                bottom: 0),
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    child: IconButton(
                                                      icon: Icon(Icons.close),
                                                      onPressed: () {},
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 20,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  Container(
                                                    child: TextButton(
                                                      onPressed: () {
                                                        selectedDate =
                                                            DateTime.now();
                                                        selectedTime =
                                                            TimeOfDay(
                                                                hour: 9,
                                                                minute: 0);
                                                        Navigator.of(context,
                                                                rootNavigator:
                                                                    true)
                                                            .pop('dialog');
                                                      },
                                                      child: Text("HỦY"),
                                                    ),
                                                  ),
                                                  Container(
                                                    child: TextButton(
                                                      onPressed: () {
                                                        if (startDateTxtCtrl
                                                                    .text ==
                                                                "" &&
                                                            startTimeTxtCtrl
                                                                    .text ==
                                                                "") {
                                                          setState(() {
                                                            startDateStr = "";
                                                          });

                                                          ///Save null to database
                                                        } else {
                                                          setState(() {
                                                            String selectedDay =
                                                                selectedDate.day
                                                                    .toString();
                                                            String
                                                                selectedMonth =
                                                                selectedDate
                                                                    .month
                                                                    .toString();
                                                            String
                                                                selectedYear =
                                                                selectedDate
                                                                    .year
                                                                    .toString();
                                                            String selectedTimeStr = selectedTime
                                                                    .hour
                                                                    .toString() +
                                                                (selectedTime
                                                                            .minute >=
                                                                        10
                                                                    ? selectedTime
                                                                        .minute
                                                                        .toString()
                                                                    : "0" +
                                                                        selectedTime
                                                                            .minute
                                                                            .toString());
                                                            startDateStr =
                                                                "Bắt đầu vào ngày $selectedDay tháng $selectedMonth, năm $selectedYear lúc $selectedTimeStr";
                                                          });

                                                          ///save selected Date and selected time to database. This condition means:
                                                          ///date null, time not null => save date now + time value
                                                          ///date not null, time null => save date value + time default at 9:00
                                                          ///date, time not null => save normally
                                                        }
                                                        Navigator.of(context,
                                                                rootNavigator:
                                                                    true)
                                                            .pop('dialog');
                                                      },
                                                      child: Text("HOÀN TẤT"),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),

                                ///DateStart TextButton
                                TextButton(
                                  child: Container(
                                    width: 265,
                                    child: Text(
                                        startDateStr == ""
                                            ? "Ngày bắt đầu..."
                                            : "$startDateStr",
                                        style: TextStyle(
                                            fontSize: 18.0,
                                            color: Colors.black87)),
                                  ),
                                  style: ButtonStyle(
                                    alignment: Alignment.bottomLeft,
                                    overlayColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.white),
                                  ),
                                  onPressed: () {
                                    startDateTxtCtrl.text =
                                        selectedDate.day.toString() +
                                            " thg " +
                                            selectedDate.month.toString();
                                    startTimeTxtCtrl.text =
                                        selectedTime.hour.toString() + ":";
                                    if (selectedTime.minute >= 10)
                                      startTimeTxtCtrl.text =
                                          startTimeTxtCtrl.text +
                                              selectedTime.minute.toString();
                                    else
                                      startTimeTxtCtrl.text =
                                          startTimeTxtCtrl.text +
                                              "0" +
                                              selectedTime.minute.toString();
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          AlertDialog(
                                        title: const Text(
                                          'Ngày bắt đầu',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        content: Container(
                                          height: 120,
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            3.7,
                                                    child: TextField(
                                                      controller:
                                                          startDateTxtCtrl,
                                                      readOnly: true,
                                                      showCursor: true,
                                                      onTap: () {
                                                        dateTypePicked = 1;
                                                        _selectDate(context);
                                                      },
                                                      decoration:
                                                          InputDecoration(
                                                        hintText: "Chọn ngày",
                                                        contentPadding:
                                                            const EdgeInsets
                                                                    .only(
                                                                bottom: 0),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            3.7,
                                                    child: TextField(
                                                      controller:
                                                          startTimeTxtCtrl,
                                                      readOnly: true,
                                                      showCursor: true,
                                                      onTap: () {
                                                        timeTypePicked = 1;
                                                        _selectTime(context);
                                                      },
                                                      decoration:
                                                          InputDecoration(
                                                        hintText:
                                                            "Chọn thời gian",
                                                        contentPadding:
                                                            const EdgeInsets
                                                                    .only(
                                                                bottom: 0),
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    child: IconButton(
                                                      icon: Icon(Icons.close),
                                                      onPressed: () {
                                                        startDateTxtCtrl.text =
                                                            "";
                                                        startTimeTxtCtrl.text =
                                                            "";
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 20,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  Container(
                                                    child: TextButton(
                                                      onPressed: () {
                                                        selectedDate =
                                                            DateTime.now();
                                                        selectedTime =
                                                            TimeOfDay(
                                                                hour: 9,
                                                                minute: 0);
                                                        Navigator.of(context,
                                                                rootNavigator:
                                                                    true)
                                                            .pop('dialog');
                                                      },
                                                      child: Text("HỦY"),
                                                    ),
                                                  ),
                                                  Container(
                                                    child: TextButton(
                                                      onPressed: () {
                                                        if (startDateTxtCtrl
                                                                    .text ==
                                                                "" &&
                                                            startTimeTxtCtrl
                                                                    .text ==
                                                                "") {
                                                          setState(() {
                                                            startDateStr = "";
                                                            startDate = "";
                                                            startTime = "";
                                                          });

                                                          ///Save null to database
                                                        } else {
                                                          setState(() {
                                                            startDate = selectedDate.toString();
                                                            startTime = selectedTime.format(context);
                                                            String selectedDay =
                                                                selectedDate.day
                                                                    .toString();
                                                            String
                                                                selectedMonth =
                                                                selectedDate
                                                                    .month
                                                                    .toString();
                                                            String
                                                                selectedYear =
                                                                selectedDate
                                                                    .year
                                                                    .toString();
                                                            String selectedTimeStr = selectedTime
                                                                    .hour
                                                                    .toString() +
                                                                (selectedTime
                                                                            .minute >=
                                                                        10
                                                                    ? ":0" +
                                                                        selectedTime
                                                                            .minute
                                                                            .toString()
                                                                    : ":0" +
                                                                        selectedTime
                                                                            .minute
                                                                            .toString());
                                                            startDateStr =
                                                                "Bắt đầu vào ngày $selectedDay tháng $selectedMonth, năm $selectedYear lúc $selectedTimeStr";
                                                          });

                                                          ///save selected Date and selected time to database. This condition means:
                                                          ///date null, time not null => save date now + time value
                                                          ///date not null, time null => save date value + time default at 9:00
                                                          ///date, time not null => save normally
                                                        }
                                                        Navigator.of(context,
                                                                rootNavigator:
                                                                    true)
                                                            .pop('dialog');
                                                      },
                                                      child: Text("HOÀN TẤT"),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),

                            ///DateEnd
                            Row(
                              children: [
                                SizedBox(
                                  width: 48,
                                ),
                                TextButton(
                                  child: Container(
                                    width: 265,
                                    child: Text(
                                        endDateStr == ""
                                            ? "Ngày hết hạn..."
                                            : "$endDateStr",
                                        style: TextStyle(
                                            fontSize: 18.0,
                                            color: Colors.black87)),
                                  ),
                                  style: ButtonStyle(
                                    alignment: Alignment.centerLeft,
                                    overlayColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.white),
                                  ),
                                  onPressed: () {
                                    endDate = selectedDate.toString();
                                    endTime = selectedTime.format(context);
                                    endDateTxtCtrl.text =
                                        selectedDate.day.toString() +
                                            " thg " +
                                            selectedDate.month.toString();
                                    endTimeTxtCtrl.text =
                                        selectedTime.hour.toString() + ":";
                                    if (selectedTime.minute >= 10)
                                      endTimeTxtCtrl.text =
                                          endTimeTxtCtrl.text +
                                              selectedTime.minute.toString();
                                    else
                                      endTimeTxtCtrl.text =
                                          endTimeTxtCtrl.text +
                                              "0" +
                                              selectedTime.minute.toString();
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          AlertDialog(
                                        title: const Text(
                                          'Ngày hết hạn',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        content: Container(
                                          height: 285,
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            3.7,
                                                    child: TextField(
                                                      controller:
                                                          endDateTxtCtrl,
                                                      readOnly: true,
                                                      showCursor: true,
                                                      onTap: () {
                                                        dateTypePicked = 2;
                                                        _selectDate(context);
                                                      },
                                                      decoration:
                                                          InputDecoration(
                                                        hintText: "Chọn ngày",
                                                        contentPadding:
                                                            const EdgeInsets
                                                                    .only(
                                                                bottom: 0),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            3.7,
                                                    child: TextField(
                                                      controller:
                                                          endTimeTxtCtrl,
                                                      readOnly: true,
                                                      showCursor: true,
                                                      onTap: () {
                                                        timeTypePicked = 2;
                                                        _selectTime(context);
                                                      },
                                                      decoration:
                                                          InputDecoration(
                                                        hintText:
                                                            "Chọn thời gian",
                                                        contentPadding:
                                                            const EdgeInsets
                                                                    .only(
                                                                bottom: 0),
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    child: IconButton(
                                                      icon: Icon(Icons.close),
                                                      onPressed: () {
                                                        endDateTxtCtrl.text =
                                                            "";
                                                        endTimeTxtCtrl.text =
                                                            "";
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 20,
                                              ),
                                              Container(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  "Thiết lập nhắc nhở",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 20,
                                              ),
                                              Container(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                child: DropdownButtonFormField<
                                                    String>(
                                                  value: selectedNotiTime,
                                                  decoration: InputDecoration(
                                                    contentPadding:
                                                        EdgeInsets.only(
                                                            bottom: 0),
                                                  ),
                                                  onChanged: (value) {
                                                    setState(() {
                                                      selectedNotiTime = value;
                                                    });
                                                  },
                                                  items: notificationTimeList
                                                      .map((String item) {
                                                    return DropdownMenuItem<
                                                            String>(
                                                        value: item,
                                                        child: Row(
                                                          children: [
                                                            Text(
                                                              item,
                                                            ),
                                                          ],
                                                        ));
                                                  }).toList(),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 20,
                                              ),
                                              Container(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                    "Nhắc nhở chỉ được gửi đến các thành viên và người theo dõi thẻ."),
                                              ),
                                              SizedBox(
                                                height: 20,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  Container(
                                                    child: TextButton(
                                                      onPressed: () {
                                                        selectedDate =
                                                            DateTime.now();
                                                        selectedTime =
                                                            TimeOfDay(
                                                                hour: 9,
                                                                minute: 0);
                                                        Navigator.of(context,
                                                                rootNavigator:
                                                                    true)
                                                            .pop('dialog');
                                                      },
                                                      child: Text("HỦY"),
                                                    ),
                                                  ),
                                                  Container(
                                                    child: TextButton(
                                                      onPressed: () {
                                                        if (endDateTxtCtrl
                                                                    .text ==
                                                                "" &&
                                                            endDateTxtCtrl
                                                                    .text ==
                                                                "") {
                                                          setState(() {
                                                            endDateStr = "";
                                                          });

                                                          ///Save null to database
                                                        } else {
                                                          setState(() {

                                                            String selectedDay =
                                                                selectedDate.day
                                                                    .toString();
                                                            String
                                                                selectedMonth =
                                                                selectedDate
                                                                    .month
                                                                    .toString();
                                                            String
                                                                selectedYear =
                                                                selectedDate
                                                                    .year
                                                                    .toString();
                                                            String selectedTimeStr = selectedTime
                                                                    .hour
                                                                    .toString() +
                                                                (selectedTime
                                                                            .minute >=
                                                                        10
                                                                    ? ":0" +
                                                                        selectedTime
                                                                            .minute
                                                                            .toString()
                                                                    : ":0" +
                                                                        selectedTime
                                                                            .minute
                                                                            .toString());
                                                            endDateStr =
                                                                "Hết hạn vào ngày $selectedDay tháng $selectedMonth, năm $selectedYear lúc $selectedTimeStr";
                                                          });

                                                          ///save selected Date and selected time to database. This condition means:
                                                          ///date null, time not null => save date now + time value
                                                          ///date not null, time null => save date value + time default at 9:00
                                                          ///date, time not null => save normally
                                                        }
                                                        Navigator.of(context,
                                                                rootNavigator:
                                                                    true)
                                                            .pop('dialog');
                                                      },
                                                      child: Text("HOÀN TẤT"),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
