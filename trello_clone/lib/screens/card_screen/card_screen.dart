import 'dart:ui';

import 'package:animated_icon_button/animated_icon_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trello_clone/icons/app_icons.dart';
import 'package:trello_clone/icons/my_flutter_app2_icons.dart';
import 'package:trello_clone/models/boards.dart';
import 'package:trello_clone/models/user.dart';
import 'package:trello_clone/screens/card_screen/move_card_screen.dart';

import 'package:trello_clone/widgets/reuse_widget/avatar.dart';

class CheckList extends StatefulWidget {
  @override
  CheckListState createState() => CheckListState();
}

class CheckListState extends State<CheckList> {
  List<String> tasks = [];
  List<bool> isTaskDone = [];
  String name = "";
  bool isShow = true;

  @override
  void initState() {
    super.initState();
    tasks = List.filled(5, "Task");
    isTaskDone = List.filled(5, false);
    name = "Name";
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ///Header
        Container(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(color: Colors.grey.shade400),
                bottom: BorderSide(color: Colors.grey.shade400),
              )),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                name,
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              Row(
                children: [
                  AnimatedIconButton(
                      size: 25,
                      onPressed: () => {
                            setState(() {
                              isShow = !isShow;
                            })
                          },
                      icons: [
                        AnimatedIconItem(
                          icon: Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.black,
                          ),
                        ),
                        AnimatedIconItem(
                          icon: Icon(
                            Icons.keyboard_arrow_up,
                            color: Colors.black,
                          ),
                        ),
                      ]),
                  PopupMenuButton(
                    iconSize: 30,
                    padding: EdgeInsets.zero,
                    icon: Icon(Icons.more_horiz),
                    onSelected: (value) {},
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 1,
                        child: Text(
                          'Xóa',
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              )
            ],
          ),
        ),
        Container(
          height: 5,
          decoration: BoxDecoration(color: Color.fromRGBO(188, 217, 234, 1)),
          child: Row(),
        ),
        isShow
            ? Column(
                children: List.generate(
                    tasks.length,
                    (index) => Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Transform.scale(
                                    scale: 1.2,
                                    child: Checkbox(
                                      value: isTaskDone[index],
                                      onChanged: (value) {
                                        setState(() {
                                          isTaskDone[index] =
                                              !isTaskDone[index];
                                          ///TODO: Change state of task
                                        });
                                      },
                                    ),
                                  ),
                                  Text(
                                    tasks[index],
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(50, 0, 0, 0),
                                child: Divider(),
                              ),
                            ],
                          ),
                        )),
              )
            : SizedBox(
                height: 0,
              )
      ],
    );
  }
}

class CardScreen extends StatefulWidget {
  late String cardName;

  CardScreen(this.cardName);

  @override
  CardScreenState createState() => CardScreenState(cardName);
}

class CardScreenState extends State<CardScreen> {
  late String cardName;
  late Boards boards;

  CardScreenState(this.cardName);

  var descriptionTxtCtrl = TextEditingController();

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
  List<Users> pickedUsers = [];

  ///TODO: Load users from database to pickedUsers
  List<bool> flagPickedUsers = [];

  ///Use for showing check iconbutton in popup member

  @override
  void initState() {
    for (Users user in users) {
      var foundUser =
          pickedUsers.where((element) => element.userID == user.userID);
      if (foundUser.isNotEmpty)
        flagPickedUsers.add(true);
      else
        flagPickedUsers.add(false);
    }
    super.initState();
  }

  ///StartDate picker
  ///TODO: Load selectedStartDate from database, if = null, assign Datetime now to it
  var startDateTxtCtrl = TextEditingController();
  DateTime selectedStartDate = DateTime.now();

  Future<Null> _selectedStartDate(BuildContext context) async {
    final DateTime picked = (await showDatePicker(
        context: context,
        initialDate: selectedStartDate,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(2015),
        lastDate: DateTime(2101)))!;
    setState(() {
      selectedStartDate = picked;
      if (selectedStartDate.year != DateTime.now().year)
        startDateTxtCtrl.text = selectedStartDate.day.toString() +
            " thg " +
            selectedStartDate.month.toString() +
            ", " +
            selectedStartDate.year.toString();
      else
        startDateTxtCtrl.text = selectedStartDate.day.toString() +
            " thg " +
            selectedStartDate.month.toString();
    });
  }

  ///EndDate picker
  ///TODO: Load selectedEndDate from database, if = null, assign Datetime now to it
  var endDateTxtCtrl = TextEditingController();
  DateTime selectedEndDate = DateTime.now();

  Future<Null> _selectedEndDate(BuildContext context) async {
    final DateTime picked = (await showDatePicker(
        context: context,
        initialDate: selectedEndDate,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(2015),
        lastDate: DateTime(2101)))!;
    setState(() {
      selectedEndDate = picked;
      if (selectedEndDate.year != DateTime.now().year)
        endDateTxtCtrl.text = selectedEndDate.day.toString() +
            " thg " +
            selectedEndDate.month.toString() +
            ", " +
            selectedEndDate.year.toString();
      else
        endDateTxtCtrl.text = selectedEndDate.day.toString() +
            " thg " +
            selectedEndDate.month.toString();
    });
  }

  ///StartTime Picker
  ///TODO: Load selectedStartTime from database, if = null, assign TimeOfDay(hour: 9, minute: 0) to it
  TimeOfDay selectedStartTime = TimeOfDay(hour: 9, minute: 0);
  var startTimeTxtCtrl = TextEditingController();

  Future<Null> _selectedStartTime(BuildContext context) async {
    final TimeOfDay picked = (await showTimePicker(
      context: context,
      initialTime: selectedStartTime,
    ))!;
    setState(() {
      selectedStartTime = picked;
      startTimeTxtCtrl.text = selectedStartTime.hour.toString() + ":";
      if (selectedStartTime.minute >= 10)
        startTimeTxtCtrl.text =
            startTimeTxtCtrl.text + selectedStartTime.minute.toString();
      else
        startTimeTxtCtrl.text =
            startTimeTxtCtrl.text + "0" + selectedStartTime.minute.toString();
    });
  }

  ///EndTime Picker
  ///TODO: Load selectedEndTime from database, if = null, assign TimeOfDay(hour: 9, minute: 0) to it
  TimeOfDay selectedEndTime = TimeOfDay(hour: 9, minute: 0);
  var endTimeTxtCtrl = TextEditingController();

  Future<Null> _selectedEndTime(BuildContext context) async {
    final TimeOfDay picked = (await showTimePicker(
      context: context,
      initialTime: selectedEndTime,
    ))!;
    setState(() {
      selectedEndTime = picked;
      endTimeTxtCtrl.text = selectedEndTime.hour.toString() + ":";
      if (selectedEndTime.minute >= 10)
        endTimeTxtCtrl.text =
            endTimeTxtCtrl.text + selectedEndTime.minute.toString();
      else
        endTimeTxtCtrl.text =
            endTimeTxtCtrl.text + "0" + selectedEndTime.minute.toString();
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

  ///String value to set for startDate, endDate TextButton
  ///TODO: if startDate (timestamp type) from database = null, then string = null
  ///TODO: else startDateStr = "Bắt đầu vào ngày $selectedDay tháng $selectedMonth, năm $selectedYear lúc $selectedTimeStr"
  String startDateStr = "";

  ///TODO: if endDate (timestamp type) from database = null, then string = null
  ///TODO: else endDateStr = "Hết hạn vào ngày $selectedDay tháng $selectedMonth, năm $selectedYear lúc $selectedTimeStr";
  String endDateStr = "";

  bool isHaveTaskList = true;
  List<String> taskListNames = ["Name 1", "Name 2", "Name 3"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Color.fromRGBO(244, 245, 247, 1.0),
      appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(
              Icons.close,
              color: Colors.black,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          elevation: 0.0,
          actions: [
            PopupMenuButton<String>(
                icon: const Icon(
                  Icons.more_vert,
                  color: Colors.black,
                ),
                onSelected: (value) {
                  switch (value) {
                    case "Di chuyển thẻ":
                      Route route = MaterialPageRoute(
                          builder: (context) => MoveCardScreen());
                      Navigator.push(context, route);
                      break;
                    case "Xóa thẻ":
                      showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: const Text(
                            'Xóa thẻ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          content: Container(
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                    "Tất cả các thao tác sẽ bị xóa khỏi thông báo hoạt động. Không thể hoàn tác."),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    TextButton(
                                      child: Text(
                                        'HỦY',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    TextButton(
                                      child: Text(
                                        'XÓA',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          ///TODO: delete card
                                        });
                                        Navigator.of(context).pop();
                                        Navigator.of(context).pop();
                                      },
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                      break;
                  }
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                      const PopupMenuItem<String>(
                        value: "Di chuyển thẻ",
                        child: Text('Di chuyển thẻ'),
                      ),
                      const PopupMenuItem<String>(
                        value: "Xóa thẻ",
                        child: Text('Xóa thẻ'),
                      ),
                    ])
          ]),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ///Card name
            Container(
              width: MediaQuery.of(context).size.width,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.only(left: 25.0, top: 30.0),

                ///TODO: Change Tên thẻ to $cardName when data is loaded
                child: Text("Tên thẻ", style: TextStyle(fontSize: 30)),
              ),
            ),

            ///Card auto-description (user cannot change this description)
            Container(
              width: MediaQuery.of(context).size.width,
              color: Colors.white,
              child: Padding(
                padding:
                    const EdgeInsets.only(left: 25.0, top: 15.0, bottom: 20.0),

                ///TODO: Change Tên danh sách to $cardlistName
                ///TODO: Change Tên bảng to $boardName
                child: Text("Danh sách Tên danh sách trong Tên bảng",
                    style: TextStyle(fontSize: 20)),
              ),
            ),

            ///Card Description (user can change this description)
            Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.only(
                left: 25,
                right: 25,
                top: 5.0,
                bottom: 5.0,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                    top: BorderSide(color: Colors.grey.shade400),
                    bottom: BorderSide(color: Colors.grey.shade400)),
              ),
              child: TextField(
                ///TODO: load data from database to descriptionTxtCtrl.text
                controller: descriptionTxtCtrl,
                style: TextStyle(fontSize: 20),
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: InputDecoration(
                  hintText: "Thêm mô tả thẻ...",
                  hintStyle: TextStyle(fontSize: 20),
                  contentPadding: const EdgeInsets.only(bottom: 0.0),
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),

            ///Label
            InkWell(
              ///TODO: Add Label list to show
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.only(
                  left: 25,
                  right: 25,
                  top: 20.0,
                  bottom: 20.0,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                      top: BorderSide(color: Colors.grey.shade400),
                      bottom: BorderSide(color: Colors.grey.shade400)),
                ),
                child: Row(
                  children: [
                    Icon(MyFlutterApp2.tag),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      "Nhãn...",
                      style: TextStyle(fontSize: 20),
                    )
                  ],
                ),
              ),
              onTap: () {
                ///TODO: Event to open Label list here
              },
            ),

            SizedBox(
              height: 10,
            ),

            ///Member
            InkWell(
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.only(
                  left: 25,
                  right: 25,
                  top: 20.0,
                  bottom: 20.0,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                      top: BorderSide(color: Colors.grey.shade400),
                      bottom: BorderSide(color: Colors.grey.shade400)),
                ),
                child: Row(
                  children: [
                    Icon(MyFlutterApp.person_outline),
                    SizedBox(
                      width: 20,
                    ),
                    pickedUsers.length < 1
                        ? Text(
                            "Thành viên...",
                            style: TextStyle(fontSize: 20),
                          )
                        : Container(
                            height: 50,
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.5,
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  itemCount: pickedUsers.length,
                                  itemBuilder: (context, index) {
                                    return CircleAvatar(
                                      radius: 25,
                                      backgroundImage:
                                          AssetImage(pickedUsers[index].avatar),
                                    );
                                  }),
                            ),
                          ),
                  ],
                ),
              ),
              onTap: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                          title: const Text(
                            'Thành viên của thẻ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          content: Container(
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SingleChildScrollView(
                                  child: Column(
                                    children: List.generate(
                                      users.length,
                                      (int index) {
                                        return Column(
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                setState(() {
                                                  flagPickedUsers[index] == true
                                                      ? flagPickedUsers[index] =
                                                          false
                                                      : flagPickedUsers[index] =
                                                          true;
                                                });
                                              },
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        16.0, 14.0, 0, 14.0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        avatar(
                                                          40,
                                                          40,
                                                          Colors.grey,
                                                          Image.network(
                                                            users[index].avatar,
                                                            width: 40,
                                                            height: 40,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 20,
                                                        ),
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: <Widget>[
                                                            Align(
                                                              alignment: Alignment
                                                                  .centerLeft,
                                                              child: Text(
                                                                  users[index]
                                                                      .profileName,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .left,
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          16,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold)),
                                                            ),
                                                            Align(
                                                              alignment: Alignment
                                                                  .centerLeft,
                                                              child: Text(
                                                                '@' +
                                                                    users[index]
                                                                        .userName,
                                                                textAlign:
                                                                    TextAlign
                                                                        .left,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        16,
                                                                    fontStyle:
                                                                        FontStyle
                                                                            .italic),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                    flagPickedUsers[index] ==
                                                            false
                                                        ? SizedBox(
                                                            width: 24,
                                                          )
                                                        : IconButton(
                                                            onPressed: () {},
                                                            icon: Icon(
                                                              Icons.check,
                                                            ),
                                                          )
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  70, 0, 0, 0),
                                              child: Divider(
                                                height: 1,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Container(
                                      child: TextButton(
                                        onPressed: () {
                                          for (Users user in users) {
                                            var foundUser = pickedUsers.where(
                                                (element) =>
                                                    element.userID ==
                                                    user.userID);
                                            if (foundUser.isNotEmpty)
                                              flagPickedUsers.add(true);
                                            else
                                              flagPickedUsers.add(false);
                                          }
                                          Navigator.of(context,
                                                  rootNavigator: true)
                                              .pop('dialog');
                                        },
                                        child: Text("HỦY"),
                                      ),
                                    ),
                                    Container(
                                      child: TextButton(
                                        onPressed: () {
                                          setState(() {
                                            pickedUsers = [];

                                            ///Save new picked users
                                            for (int index = 0;
                                                index < flagPickedUsers.length;
                                                index++) {
                                              if (flagPickedUsers[index])
                                                pickedUsers.add(users[index]);
                                            }
                                          });
                                          Navigator.of(context,
                                                  rootNavigator: true)
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
                        ));
              },
            ),

            SizedBox(
              height: 10,
            ),

            ///DateStart
            InkWell(
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.only(
                  left: 25,
                  right: 25,
                  top: 20.0,
                  bottom: 13.0,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    top: BorderSide(color: Colors.grey.shade400),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(MyFlutterApp.clock),
                    SizedBox(
                      width: 20,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width - 94,
                      child: Text(
                        startDateStr == ""
                            ? "Ngày bắt đầu..."
                            : "$startDateStr",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ],
                ),
              ),
              onTap: () {
                startDateTxtCtrl.text = selectedStartDate.day.toString() +
                    " thg " +
                    selectedStartDate.month.toString();
                startTimeTxtCtrl.text = selectedStartTime.hour.toString() + ":";
                if (selectedStartTime.minute >= 10)
                  startTimeTxtCtrl.text = startTimeTxtCtrl.text +
                      selectedStartTime.minute.toString();
                else
                  startTimeTxtCtrl.text = startTimeTxtCtrl.text +
                      "0" +
                      selectedStartTime.minute.toString();
                showDialog(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: const Text(
                      'Ngày bắt đầu',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    content: Container(
                      height: 120,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width / 3.7,
                                child: TextField(
                                  controller: startDateTxtCtrl,
                                  readOnly: true,
                                  showCursor: true,
                                  onTap: () {
                                    _selectedStartDate(context);
                                  },
                                  decoration: InputDecoration(
                                    hintText: "Chọn ngày",
                                    contentPadding:
                                        const EdgeInsets.only(bottom: 0),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width / 3.7,
                                child: TextField(
                                  controller: startTimeTxtCtrl,
                                  readOnly: true,
                                  showCursor: true,
                                  onTap: () {
                                    _selectedStartTime(context);
                                  },
                                  decoration: InputDecoration(
                                    hintText: "Chọn thời gian",
                                    contentPadding:
                                        const EdgeInsets.only(bottom: 0),
                                  ),
                                ),
                              ),
                              Container(
                                child: IconButton(
                                  icon: Icon(Icons.close),
                                  onPressed: () {
                                    startDateTxtCtrl.text = "";
                                    startTimeTxtCtrl.text = "";
                                  },
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                child: TextButton(
                                  onPressed: () {
                                    ///Reset start date, if from database not null, reset it by the data
                                    ///else reset it by DateTime.now()
                                    selectedStartDate = DateTime.now();

                                    ///Reset start time, if from database not null, reset it by the data
                                    ///else reset it by TimeOfDay(hour: 9, minute: 0)
                                    selectedStartTime =
                                        TimeOfDay(hour: 9, minute: 0);
                                    Navigator.of(context, rootNavigator: true)
                                        .pop('dialog');
                                  },
                                  child: Text("HỦY"),
                                ),
                              ),
                              Container(
                                child: TextButton(
                                  onPressed: () {
                                    if (startDateTxtCtrl.text == "" &&
                                        startTimeTxtCtrl.text == "") {
                                      setState(() {
                                        startDateStr = "";
                                      });

                                      ///Save null to database
                                    } else {
                                      setState(() {
                                        String selectedDay =
                                            selectedStartDate.day.toString();
                                        String selectedMonth =
                                            selectedStartDate.month.toString();
                                        String selectedYear =
                                            selectedStartDate.year.toString();
                                        String selectedTimeStr =
                                            selectedStartTime.hour.toString() +
                                                (selectedStartTime.minute >= 10
                                                    ? ":0" +
                                                        selectedStartTime.minute
                                                            .toString()
                                                    : ":0" +
                                                        selectedStartTime.minute
                                                            .toString());
                                        startDateStr =
                                            "Bắt đầu vào ngày $selectedDay tháng $selectedMonth, năm $selectedYear lúc $selectedTimeStr";
                                      });

                                      ///save selected Date and selected time to database. This condition means:
                                      ///date null, time not null => save date now + time value
                                      ///date not null, time null => save date value + time default at 9:00
                                      ///date, time not null => save normally
                                    }
                                    Navigator.of(context, rootNavigator: true)
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

            Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(70, 0, 0, 0),
              child: Divider(color: Colors.grey.shade400),
            ),

            ///DateEnd
            InkWell(
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.only(
                  left: 25,
                  right: 25,
                  top: 13.0,
                  bottom: 20.0,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border:
                      Border(bottom: BorderSide(color: Colors.grey.shade400)),
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: 44,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width - 94,
                      child: Text(
                        endDateStr == "" ? "Ngày hết hạn..." : "$endDateStr",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ],
                ),
              ),
              onTap: () {
                endDateTxtCtrl.text = selectedEndDate.day.toString() +
                    " thg " +
                    selectedEndDate.month.toString();
                endTimeTxtCtrl.text = selectedEndTime.hour.toString() + ":";
                if (selectedEndTime.minute >= 10)
                  endTimeTxtCtrl.text =
                      endTimeTxtCtrl.text + selectedEndTime.minute.toString();
                else
                  endTimeTxtCtrl.text = endTimeTxtCtrl.text +
                      "0" +
                      selectedEndTime.minute.toString();
                showDialog(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: const Text(
                      'Ngày hết hạn',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    content: Container(
                      height: 285,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width / 3.7,
                                child: TextField(
                                  controller: endDateTxtCtrl,
                                  readOnly: true,
                                  showCursor: true,
                                  onTap: () {
                                    _selectedEndDate(context);
                                  },
                                  decoration: InputDecoration(
                                    hintText: "Chọn ngày",
                                    contentPadding:
                                        const EdgeInsets.only(bottom: 0),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width / 3.7,
                                child: TextField(
                                  controller: endTimeTxtCtrl,
                                  readOnly: true,
                                  showCursor: true,
                                  onTap: () {
                                    _selectedEndTime(context);
                                  },
                                  decoration: InputDecoration(
                                    hintText: "Chọn thời gian",
                                    contentPadding:
                                        const EdgeInsets.only(bottom: 0),
                                  ),
                                ),
                              ),
                              Container(
                                child: IconButton(
                                  icon: Icon(Icons.close),
                                  onPressed: () {
                                    endDateTxtCtrl.text = "";
                                    endTimeTxtCtrl.text = "";
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
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            child: DropdownButtonFormField<String>(
                              value: selectedNotiTime,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.only(bottom: 0),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  selectedNotiTime = value;
                                });
                              },
                              items: notificationTimeList.map((String item) {
                                return DropdownMenuItem<String>(
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
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                child: TextButton(
                                  onPressed: () {
                                    ///Reset end date, if from database not null, reset it by the data
                                    ///else reset it by DateTime.now()
                                    selectedEndDate = DateTime.now();

                                    ///Reset end time, if from database not null, reset it by the data
                                    ///else reset it by TimeOfDay(hour: 9, minute: 0)
                                    selectedEndTime =
                                        TimeOfDay(hour: 9, minute: 0);
                                    Navigator.of(context, rootNavigator: true)
                                        .pop('dialog');
                                  },
                                  child: Text("HỦY"),
                                ),
                              ),
                              Container(
                                child: TextButton(
                                  onPressed: () {
                                    if (endDateTxtCtrl.text == "" &&
                                        endDateTxtCtrl.text == "") {
                                      setState(() {
                                        endDateStr = "";
                                      });

                                      ///Save null to database
                                    } else {
                                      setState(() {
                                        String selectedDay =
                                            selectedEndDate.day.toString();
                                        String selectedMonth =
                                            selectedEndDate.month.toString();
                                        String selectedYear =
                                            selectedEndDate.year.toString();
                                        String selectedTimeStr =
                                            selectedEndTime.hour.toString() +
                                                (selectedEndTime.minute >= 10
                                                    ? ":0" +
                                                        selectedEndTime.minute
                                                            .toString()
                                                    : ":0" +
                                                        selectedEndTime.minute
                                                            .toString());
                                        endDateStr =
                                            "Hết hạn vào ngày $selectedDay tháng $selectedMonth, năm $selectedYear lúc $selectedTimeStr";
                                      });

                                      ///save selected Date and selected time to database. This condition means:
                                      ///date null, time not null => save date now + time value
                                      ///date not null, time null => save date value + time default at 9:00
                                      ///date, time not null => save normally
                                    }
                                    Navigator.of(context, rootNavigator: true)
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

            SizedBox(
              height: 10,
            ),

            ///Checklist
            Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.only(
                left: 25,
                right: 25,
                top: 20.0,
                bottom: 20.0,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                    top: BorderSide(color: Colors.grey.shade400),
                    bottom: BorderSide(color: Colors.grey.shade400)),
              ),
              child: Row(
                children: [
                  Icon(MyFlutterApp2.check),
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    "Danh sách công việc...",
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
            ),

            SizedBox(
              height: 10,
            ),

            isHaveTaskList
                ? Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(MyFlutterApp2.check),
                                SizedBox(
                                  width: 20,
                                ),
                                Text(
                                  "DANH SÁCH CÔNG VIỆC",
                                  style: TextStyle(fontSize: 20),
                                ),
                              ],
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: Icon(Icons.add),
                              color: Colors.blue,
                              iconSize: 30,
                            ),
                          ],
                        ),
                      ),
                      Column(
                        children: List.generate(taskListNames.length, (index) => CheckList()),
                      ),
                    ],
                  )
                : SizedBox(
                    height: 0,
                  ),

            ///for bottom sheet not cover last element
            SizedBox(
              height: 69,
            )

            ///Comment display here
          ],
        ),
      ),

      ///comment
      bottomSheet: BottomAppBar(
        child: Container(
          padding: const EdgeInsets.all(5.0),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 3,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: Row(
            children: [
              avatar(
                  50, 50, Colors.grey, Image.asset('assets/images/BlueBG.png')),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Enter a message',
                    suffixIcon: IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.send,
                        size: 30,
                      ),
                    ),
                    border: new OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(30.0),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
