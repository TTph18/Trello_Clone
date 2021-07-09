import 'dart:ui';

import 'package:animated_icon_button/animated_icon_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trello_clone/icons/app_icons.dart';
import 'package:trello_clone/icons/my_flutter_app2_icons.dart';
import 'package:trello_clone/models/boards.dart';
import 'package:trello_clone/models/cards.dart';
import 'package:trello_clone/models/lists.dart';
import 'package:trello_clone/models/user.dart';
import 'package:trello_clone/screens/board_screen/board_screen.dart';
import 'package:trello_clone/screens/card_screen/move_card_screen.dart';
import 'package:trello_clone/services/database.dart';
import 'package:trello_clone/widgets/reuse_widget/avatar.dart';
import 'package:intl/intl.dart';

class CardScreen extends StatefulWidget {
  late Cards card;
  late String cardName;

  CardScreen(this.cardName, this.card);

  @override
  CardScreenState createState() => CardScreenState(cardName, card);
}

class CardScreenState extends State<CardScreen> {
  late Cards card;
  late Future futureCard;
  late String cardName;

  late Boards boards = Boards(
      boardID: "",
      userList: [],
      boardName: "",
      createdBy: "",
      background: "",
      isPersonal: false,
      workspaceID: "",
      listNumber: 0,
      cardNumber: 0,
      description: "");
  late Future futureBoards;
  late Lists lists;
  late Future futureLists;

  CardScreenState(this.cardName, this.card);

  var descriptionTxtCtrl = TextEditingController();

  List<Users> users = [
    Users(
      userID: "12345",
      userName: "name1",
      profileName: "Name 1",
      email: '123456@gmail.com',
      avatar: 'assets/images/BlueBG.png',
    ),
    Users(
      userID: "12345",
      userName: "name2",
      profileName: "Name 2",
      email: '123456@gmail.com',
      avatar: 'assets/images/BlueBG.png',
    ),
    Users(
      userID: "12345",
      userName: "name3",
      profileName: "Name 3",
      email: '123456@gmail.com',
      avatar: 'assets/images/BlueBG.png',
    ),
    Users(
      userID: "12345",
      userName: "Test4",
      profileName: "Cun cun cute",
      email: '123456@gmail.com',
      avatar: 'assets/images/BlueBG.png',
    ),
  ];
  List<Users> pickedUsers = [];

  ///TODO: Load users from database to pickedUsers
  List<bool> flagPickedUsers = [];

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
  String boardName = "";
  String cardlistName = "";
  bool? status = false;

  ///TODO: Load status from database

  bool isHaveTaskList = true;
  List<String> taskListNames = [
    "Name 1",
    "Name 2",
    "Name 3",
  ];
  bool isAddTask = false;
  bool isChangeTaskListName = false;
  bool isChangeListName = false;
  int xChangeTaskListName = -1;
  int yChangeTaskListName = -1;
  List<List<String>> tasks = [
    [
      "Name 11",
      "Name 12",
      "Name 13",
    ],
    [
      "Name 21",
      "Name 22",
    ],
    [
      "Name 31",
      "Name 32",
      "Name 33",
    ],
  ];
  List<List<bool>> isTaskDone = [
    [
      true,
      true,
      true,
    ],
    [
      true,
      true,
    ],
    [
      true,
      false,
      true,
    ],
  ];
  List<bool> isShow = [
    true,
    true,
    true,
  ];
  List<List<TextEditingController>> controllers = [];
  List<TextEditingController> controllersList = [];

  ///For comment
  var commentEnterTxtCtrl = TextEditingController();

  ///TODO: Load currentUser data
  ///Users currentUser = ...;
  ///TODO: Delete this when load current data
  String currentUserID = "12345";
  String currentUserName = "Test4";
  String currentUserAvatar = "assets/images/BlueBG.png";

  ///TODO: Load comment list
  List<Comments> commentList = [];

  ///TODO: Delete these when comment list is loaded
  ///TODO: in UI, change the commentUserIDList to commentList and match suitable values
  List<String> commentUserIDList = ["12345", "1234", "1234"];
  List<String> commentUserNameList = ["Test4", "name1", "name1"];
  List<String> commentUserAvatarList = [
    "assets/images/BlueBG.png",
    "assets/images/BlueBG.png",
    "assets/images/BlueBG.png"
  ];
  List<String> commentContentList = [
    "Test comment for Test4",
    "Test comment for name1",
    "Test test test test test comment 2 for name1"
  ];
  List<DateTime> commentDateList = [
    DateTime(2021, 7, 7, 8, 30),
    DateTime(2021, 7, 4, 9, 30),
    DateTime(2021, 6, 30, 10, 30)
  ];

  List<TextEditingController> commentContentTxtCtrlList = [];

  Future getCurrentCard() async {
    var doc = await DatabaseService.getCardData(card.cardID);
    Cards _card = Cards.fromDocument(doc);
    return _card;
  }

  Future getCurrentBoard(String boardID) async {
    var doc = await DatabaseService.getBoardData(boardID);
    Boards _board = Boards.fromDocument(doc);
    return _board;
  }

  Future getCurrentList(String boardID, String listID) async {
    var doc = await DatabaseService.getListData(boardID, listID);
    Lists _list = Lists.fromDocument(doc);
    return _list;
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree.
    // This also removes the _printLatestValue listener.
    descriptionTxtCtrl.dispose();
    super.dispose();
  }

  _updateDescription() {
    FirebaseFirestore.instance
        .collection('cards')
        .doc(card.cardID)
        .update({"description": descriptionTxtCtrl.text});
  }

  _updateDateStart() {
    FirebaseFirestore.instance
        .collection('cards')
        .doc(card.cardID)
        .update({"startDate": selectedStartDate.toString()});
  }

  _updateTimeStart() {
    FirebaseFirestore.instance
        .collection('cards')
        .doc(card.cardID)
        .update({"startTime": selectedStartTime.format(context)});
  }

  _updateDateEnd() {
    FirebaseFirestore.instance
        .collection('cards')
        .doc(card.cardID)
        .update({"dueDate": selectedEndDate.toString()});
  }

  _updateTimeEnd() {
    FirebaseFirestore.instance
        .collection('cards')
        .doc(card.cardID)
        .update({"dueTime": selectedEndTime.format(context)});
  }

  @override
  void initState() {
    super.initState();
    descriptionTxtCtrl.value = TextEditingValue(text: card.description);
    descriptionTxtCtrl.addListener(() {
      _updateDescription();
    });
    startDateTxtCtrl.addListener(() {
      _updateDateStart();
    });
    endDateTxtCtrl.addListener(() {
      _updateDateEnd();
    });
    startTimeTxtCtrl.addListener(() {
      _updateTimeStart();
    });
    endTimeTxtCtrl.addListener(() {
      _updateTimeEnd();
    });
    futureBoards = getCurrentBoard(card.boardID);
    futureLists = getCurrentList(card.boardID, card.listID);
    futureCard = getCurrentCard();

    for (Users user in users) {
      var foundUser =
          pickedUsers.where((element) => element.userID == user.userID);
      if (foundUser.isNotEmpty)
        flagPickedUsers.add(true);
      else
        flagPickedUsers.add(false);
    }

    for (int index = 0; index < commentUserIDList.length; index++) {
      commentContentTxtCtrlList.add(TextEditingController());
      commentContentTxtCtrlList[index].text = commentContentList[index];
    }

    if (card.startDate != "") {
      selectedStartDate = DateFormat("yyyy-MM-dd").parse(card.startDate);
      selectedStartTime =
          TimeOfDay.fromDateTime(DateFormat("hh:mm a").parse(card.startTime));
      var selectedDay = selectedStartDate.day;
      var selectedMonth = selectedStartDate.month;
      var selectedYear = selectedStartDate.year;
      String selectedTimeStr = selectedStartTime.hour.toString() +
          (selectedStartTime.minute >= 10
              ? ":0" + selectedStartTime.minute.toString()
              : ":0" + selectedStartTime.minute.toString());
      startDateStr =
          "Bắt đầu vào ngày $selectedDay tháng $selectedMonth, năm $selectedYear lúc $selectedTimeStr";
    }

    if (card.dueDate != "") {
      selectedEndDate = DateFormat("yyyy-MM-dd").parse(card.dueDate);
      selectedEndTime =
          TimeOfDay.fromDateTime(DateFormat("hh:mm a").parse(card.dueTime));
      var selectedDay = selectedEndDate.day;
      var selectedMonth = selectedEndDate.month;
      var selectedYear = selectedEndDate.year;
      String selectedTimeStr = selectedEndTime.hour.toString() +
          (selectedEndTime.minute >= 10
              ? ":0" + selectedEndTime.minute.toString()
              : ":0" + selectedEndTime.minute.toString());
      endDateStr =
          "Hết hạn vào ngày $selectedDay tháng $selectedMonth, năm $selectedYear lúc $selectedTimeStr";
    }

    tasks = [
      [
        "Name 11",
        "Name 12",
        "Name 13",
      ],
      [
        "Name 21",
        "Name 22",
      ],
      [
        "Name 31",
        "Name 32",
        "Name 33",
      ],
    ];

    controllers = [];
    for (int i = 0; i < tasks.length; i++) {
      controllersList.add(TextEditingController.fromValue(
          TextEditingValue(text: taskListNames[i])));
      controllers.add([]);
      for (int j = 0; j < tasks[i].length; j++) {
        controllers[i].add(new TextEditingController.fromValue(
            TextEditingValue(text: tasks[i][j])));
      }
    }
  }

  void addPickedMember(Users pickedUser) {
    setState(() {
      pickedUsers.add(pickedUser);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Future.wait([futureCard, futureBoards]),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return Container(
                alignment: FractionalOffset.center,
                child: CircularProgressIndicator());
          } else {
            boards = snapshot.data[1];
            boardName = boards.boardName;
          }
          return FutureBuilder(
              future: futureLists,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (!snapshot.hasData) {
                  return Container(
                      alignment: FractionalOffset.center,
                      child: CircularProgressIndicator());
                } else {
                  lists = snapshot.data;
                  cardlistName = lists.listName;
                }
                return Scaffold(
                  resizeToAvoidBottomInset: true,
                  backgroundColor: Color.fromRGBO(244, 245, 247, 1.0),
                  appBar: AppBar(
                      backgroundColor: Colors.white,
                      title: Text(
                        isAddTask
                            ? "Mục mới"
                            : isChangeTaskListName
                                ? "Chỉnh sửa mục"
                                : isChangeListName
                                    ? "Chỉnh sửa danh sách công việc"
                                    : "",
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                      leading: IconButton(
                        icon: Icon(
                          Icons.close,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          if (isAddTask) {
                            isAddTask = false;
                            FocusScope.of(context).unfocus();
                          } else if (isChangeTaskListName) {
                            isChangeTaskListName = false;
                            xChangeTaskListName = -1;
                            yChangeTaskListName = -1;
                            FocusScope.of(context).unfocus();
                          } else if (isChangeListName) {
                            isChangeListName = false;
                            xChangeTaskListName = -1;
                            FocusScope.of(context).unfocus();
                          } else {
                            Route route = MaterialPageRoute(
                                builder: (context) =>
                                    BoardScreen(boards, false));
                            Navigator.push(context, route);
                          }
                        },
                      ),
                      elevation: 0.0,
                      actions: [
                        isAddTask || isChangeTaskListName || isChangeListName
                            ? IconButton(
                                icon: Icon(
                                  Icons.check,
                                  color: Colors.black,
                                ),
                                onPressed: () {
                                  if (isAddTask) {
                                    ///TODO: Add new task
                                    isAddTask = false;
                                    FocusScope.of(context).unfocus();
                                  } else if (isChangeTaskListName) {
                                    ///TODO: Change value at [xChangeTaskListName][yChangeTaskListName]
                                    isChangeTaskListName = false;
                                    xChangeTaskListName = -1;
                                    yChangeTaskListName = -1;
                                    FocusScope.of(context).unfocus();
                                  } else if (isChangeListName) {
                                    ///TODO: Change name at [xChangeTaskListName]
                                    isChangeListName = false;
                                    xChangeTaskListName = -1;
                                    FocusScope.of(context).unfocus();
                                  }
                                },
                              )
                            : PopupMenuButton<String>(
                                icon: const Icon(
                                  Icons.more_vert,
                                  color: Colors.black,
                                ),
                                onSelected: (value) {
                                  switch (value) {
                                    case "Di chuyển thẻ":
                                      Route route = MaterialPageRoute(
                                          builder: (context) =>
                                              MoveCardScreen());
                                      Navigator.push(context, route);
                                      break;
                                    case "Xóa thẻ":
                                      showDialog<String>(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            AlertDialog(
                                          title: const Text(
                                            'Xóa thẻ',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          content: Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.8,
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                    "Tất cả các thao tác sẽ bị xóa khỏi thông báo hoạt động. Không thể hoàn tác."),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    TextButton(
                                                      child: Text(
                                                        'HỦY',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                    ),
                                                    TextButton(
                                                      child: Text(
                                                        'XÓA',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      onPressed: () {
                                                        setState(() async {
                                                          DatabaseService
                                                              .reduceCardNumberInBoard(
                                                                  card.cardID);
                                                          await DatabaseService
                                                              .deleteCard(
                                                                  card.cardID);
                                                        });
                                                        Navigator.of(context)
                                                            .pop();
                                                        Navigator.of(context)
                                                            .pop();
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
                                itemBuilder: (BuildContext context) =>
                                    <PopupMenuEntry<String>>[
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
                            padding:
                                const EdgeInsets.only(left: 25.0, top: 30.0),

                            ///TODO: Change Tên thẻ to $cardName when data is loaded
                            child: Text(card.cardName,
                                style: TextStyle(fontSize: 30)),
                          ),
                        ),

                        ///Card auto-description (user cannot change this description)
                        Container(
                          width: MediaQuery.of(context).size.width,
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 25.0, top: 15.0, bottom: 20.0),

                            ///TODO: Change Tên danh sách to $cardlistName
                            ///TODO: Change Tên bảng to $boardName
                            child: Text(
                                "Danh sách $cardlistName trong $boardName",
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
                                bottom:
                                    BorderSide(color: Colors.grey.shade400)),
                          ),
                          child: TextField(
                            ///TODO: load data from database to descriptionTxtCtrl.text
                            controller: descriptionTxtCtrl,
                            style: TextStyle(fontSize: 20),
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            onChanged: (text) {
                              _updateDescription();
                            },
                            decoration: InputDecoration(
                              hintText: "Thêm mô tả thẻ...",
                              hintStyle: TextStyle(fontSize: 20),
                              contentPadding:
                                  const EdgeInsets.only(bottom: 0.0),
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
                                  bottom:
                                      BorderSide(color: Colors.grey.shade400)),
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
                        StreamBuilder(
                            stream: DatabaseService.streamListUser(
                                card.assignedUser),
                            builder:
                                (BuildContext context, AsyncSnapshot snapshot) {
                              if (!snapshot.hasData) {
                                return Container(
                                    alignment: FractionalOffset.center,
                                    child: CircularProgressIndicator());
                              } else {
                                users.clear();
                                for (var item in snapshot.data) {
                                  Users temp = Users.fromDocument(item);
                                  users.add(temp);
                                }
                              }
                              return InkWell(
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
                                        top: BorderSide(
                                            color: Colors.grey.shade400),
                                        bottom: BorderSide(
                                            color: Colors.grey.shade400)),
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
                                                width: MediaQuery.of(context)
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
                                                            NetworkImage(
                                                                pickedUsers[
                                                                        index]
                                                                    .avatar),
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
                                      builder:
                                          (BuildContext context) =>
                                              StatefulBuilder(
                                                  builder: (context, setState) {
                                                return AlertDialog(
                                                  title: const Text(
                                                    'Thành viên của thẻ',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  content: Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        SingleChildScrollView(
                                                          child: Column(
                                                            children:
                                                                List.generate(
                                                              users.length,
                                                              (int index) {
                                                                return Column(
                                                                  children: [
                                                                    InkWell(
                                                                      child:
                                                                          Padding(
                                                                        padding: const EdgeInsets.fromLTRB(
                                                                            16.0,
                                                                            14.0,
                                                                            0,
                                                                            14.0),
                                                                        child:
                                                                            Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceBetween,
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
                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                  children: <Widget>[
                                                                                    Align(
                                                                                      alignment: Alignment.centerLeft,
                                                                                      child: Text(users[index].profileName, textAlign: TextAlign.left, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                                                                    ),
                                                                                    Align(
                                                                                      alignment: Alignment.centerLeft,
                                                                                      child: Text(
                                                                                        '@' + users[index].userName,
                                                                                        textAlign: TextAlign.left,
                                                                                        style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ],
                                                                            ),
                                                                            flagPickedUsers[index] == false
                                                                                ? SizedBox(
                                                                                    width: 24,
                                                                                  )
                                                                                : Icon(Icons.check),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      onTap:
                                                                          () {
                                                                        setState(
                                                                            () {
                                                                          if (flagPickedUsers[index] ==
                                                                              true)
                                                                            flagPickedUsers[index] =
                                                                                false;
                                                                          else
                                                                            flagPickedUsers[index] =
                                                                                true;
                                                                        });
                                                                      },
                                                                    ),
                                                                    Padding(
                                                                      padding: EdgeInsets
                                                                          .fromLTRB(
                                                                              70,
                                                                              0,
                                                                              0,
                                                                              0),
                                                                      child:
                                                                          Divider(
                                                                        height:
                                                                            1,
                                                                        color: Colors
                                                                            .black,
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
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          children: [
                                                            Container(
                                                              child: TextButton(
                                                                onPressed: () {
                                                                  for (int index =
                                                                          0;
                                                                      index <
                                                                          users
                                                                              .length;
                                                                      index++) {
                                                                    var foundUser = pickedUsers.where((element) =>
                                                                        element
                                                                            .userID ==
                                                                        users[index]
                                                                            .userID);
                                                                    if (foundUser
                                                                        .isNotEmpty)
                                                                      flagPickedUsers[
                                                                              index] =
                                                                          true;
                                                                    else
                                                                      flagPickedUsers[
                                                                              index] =
                                                                          false;
                                                                  }
                                                                  Navigator.of(
                                                                          context,
                                                                          rootNavigator:
                                                                              true)
                                                                      .pop(
                                                                          'dialog');
                                                                },
                                                                child: Text(
                                                                    "HỦY"),
                                                              ),
                                                            ),
                                                            Container(
                                                              child: TextButton(
                                                                onPressed: () {
                                                                  setState(() {
                                                                    pickedUsers =
                                                                        [];

                                                                    ///Save new picked users
                                                                    for (int index =
                                                                            0;
                                                                        index <
                                                                            flagPickedUsers.length;
                                                                        index++) {
                                                                      if (flagPickedUsers[
                                                                          index])
                                                                        addPickedMember(
                                                                            users[index]);
                                                                    }
                                                                  });
                                                                  Navigator.of(
                                                                          context,
                                                                          rootNavigator:
                                                                              true)
                                                                      .pop(
                                                                          'dialog');
                                                                },
                                                                child: Text(
                                                                    "HOÀN TẤT"),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              }));
                                },
                              );
                            }),

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
                                Icon(MyFlutterApp.clock,
                                    color: endDateStr == ""
                                        ? Colors.black
                                        : (DateTime.now().isBefore(DateTime(
                                                selectedEndDate.year,
                                                selectedEndDate.month,
                                                selectedEndDate.day,
                                                selectedEndTime.hour,
                                                selectedEndTime.minute)))
                                            ? status == true
                                                ? Colors.blue
                                                : Colors.black
                                            : status == true
                                                ? Colors.blue
                                                : Colors.red),
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
                            startDateTxtCtrl.text =
                                selectedStartDate.day.toString() +
                                    " thg " +
                                    selectedStartDate.month.toString();
                            startTimeTxtCtrl.text =
                                selectedStartTime.hour.toString() + ":";
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
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                3.7,
                                            child: TextField(
                                              onChanged: (text) {
                                                _updateDateStart();
                                              },
                                              controller: startDateTxtCtrl,
                                              readOnly: true,
                                              showCursor: true,
                                              onTap: () {
                                                _selectedStartDate(context);
                                              },
                                              decoration: InputDecoration(
                                                hintText: "Chọn ngày",
                                                contentPadding:
                                                    const EdgeInsets.only(
                                                        bottom: 0),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                3.7,
                                            child: TextField(
                                              onChanged: (text) {
                                                _updateTimeStart();
                                              },
                                              controller: startTimeTxtCtrl,
                                              readOnly: true,
                                              showCursor: true,
                                              onTap: () {
                                                _selectedStartTime(context);
                                              },
                                              decoration: InputDecoration(
                                                hintText: "Chọn thời gian",
                                                contentPadding:
                                                    const EdgeInsets.only(
                                                        bottom: 0),
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Container(
                                            child: TextButton(
                                              onPressed: () {
                                                ///Reset start date, if from database not null, reset it by the data
                                                ///else reset it by DateTime.now()
                                                selectedStartDate =
                                                    DateTime.now();

                                                ///Reset start time, if from database not null, reset it by the data
                                                ///else reset it by TimeOfDay(hour: 9, minute: 0)
                                                selectedStartTime = TimeOfDay(
                                                    hour: 9, minute: 0);
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
                                                if (startDateTxtCtrl.text ==
                                                        "" &&
                                                    startTimeTxtCtrl.text ==
                                                        "") {
                                                  setState(() {
                                                    startDateStr = "";
                                                  });

                                                  ///Save null to database
                                                } else {
                                                  setState(() {
                                                    String selectedDay =
                                                        selectedStartDate.day
                                                            .toString();
                                                    String selectedMonth =
                                                        selectedStartDate.month
                                                            .toString();
                                                    String selectedYear =
                                                        selectedStartDate.year
                                                            .toString();
                                                    String selectedTimeStr = selectedStartTime
                                                            .hour
                                                            .toString() +
                                                        (selectedStartTime
                                                                    .minute >=
                                                                10
                                                            ? ":0" +
                                                                selectedStartTime
                                                                    .minute
                                                                    .toString()
                                                            : ":0" +
                                                                selectedStartTime
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
                              border: Border(
                                  bottom:
                                      BorderSide(color: Colors.grey.shade400)),
                            ),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 44,
                                ),
                                endDateStr == ""
                                    ? Text(
                                        "Ngày hết hạn...",
                                        style: TextStyle(fontSize: 20),
                                      )
                                    : Container(
                                        width:
                                            MediaQuery.of(context).size.width -
                                                94,
                                        child: Row(
                                          children: [
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  142,
                                              child: Text(
                                                endDateStr,
                                                style: TextStyle(fontSize: 20),
                                              ),
                                            ),
                                            Checkbox(
                                                value: status,
                                                onChanged: (value) {
                                                  setState(() {
                                                    status = value;
                                                  });
                                                }),
                                          ],
                                        ),
                                      ),
                              ],
                            ),
                          ),
                          onTap: () {
                            endDateTxtCtrl.text =
                                selectedEndDate.day.toString() +
                                    " thg " +
                                    selectedEndDate.month.toString();
                            endTimeTxtCtrl.text =
                                selectedEndTime.hour.toString() + ":";
                            if (selectedEndTime.minute >= 10)
                              endTimeTxtCtrl.text = endTimeTxtCtrl.text +
                                  selectedEndTime.minute.toString();
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
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                3.7,
                                            child: TextField(
                                              onChanged: (text) {
                                                _updateDateEnd();
                                              },
                                              controller: endDateTxtCtrl,
                                              readOnly: true,
                                              showCursor: true,
                                              onTap: () {
                                                _selectedEndDate(context);
                                              },
                                              decoration: InputDecoration(
                                                hintText: "Chọn ngày",
                                                contentPadding:
                                                    const EdgeInsets.only(
                                                        bottom: 0),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                3.7,
                                            child: TextField(
                                              onChanged: (text) {
                                                _updateTimeEnd();
                                              },
                                              controller: endTimeTxtCtrl,
                                              readOnly: true,
                                              showCursor: true,
                                              onTap: () {
                                                _selectedEndTime(context);
                                              },
                                              decoration: InputDecoration(
                                                hintText: "Chọn thời gian",
                                                contentPadding:
                                                    const EdgeInsets.only(
                                                        bottom: 0),
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
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: DropdownButtonFormField<String>(
                                          value: selectedNotiTime,
                                          decoration: InputDecoration(
                                            contentPadding:
                                                EdgeInsets.only(bottom: 0),
                                          ),
                                          onChanged: (value) {
                                            setState(() {
                                              selectedNotiTime = value;
                                            });
                                          },
                                          items: notificationTimeList
                                              .map((String item) {
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Container(
                                            child: TextButton(
                                              onPressed: () {
                                                ///Reset end date, if from database not null, reset it by the data
                                                ///else reset it by DateTime.now()
                                                selectedEndDate =
                                                    DateTime.now();

                                                ///Reset end time, if from database not null, reset it by the data
                                                ///else reset it by TimeOfDay(hour: 9, minute: 0)
                                                selectedEndTime = TimeOfDay(
                                                    hour: 9, minute: 0);
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
                                                if (endDateTxtCtrl.text == "" &&
                                                    endDateTxtCtrl.text == "") {
                                                  setState(() {
                                                    endDateStr = "";
                                                  });

                                                  ///Save null to database
                                                } else {
                                                  setState(() {
                                                    String selectedDay =
                                                        selectedEndDate.day
                                                            .toString();
                                                    String selectedMonth =
                                                        selectedEndDate.month
                                                            .toString();
                                                    String selectedYear =
                                                        selectedEndDate.year
                                                            .toString();
                                                    String selectedTimeStr = selectedEndTime
                                                            .hour
                                                            .toString() +
                                                        (selectedEndTime
                                                                    .minute >=
                                                                10
                                                            ? ":0" +
                                                                selectedEndTime
                                                                    .minute
                                                                    .toString()
                                                            : ":0" +
                                                                selectedEndTime
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
                              ),
                            );
                          },
                        ),

                        SizedBox(
                          height: 10,
                        ),

                        ///Checklist
                        InkWell(
                          onTap: () {
                            ///TODO: Add new task list
                          },
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
                                  bottom:
                                      BorderSide(color: Colors.grey.shade400)),
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
                        ),

                        SizedBox(
                          height: 10,
                        ),

                        isHaveTaskList
                            ? Column(
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(20, 8, 20, 8),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
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
                                          onPressed: () {
                                            ///TODO: Add new task list
                                          },
                                          icon: Icon(Icons.add),
                                          color: Colors.blue,
                                          iconSize: 30,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Column(
                                    children: List.generate(
                                        taskListNames.length,
                                        (index) => Column(
                                              children: [
                                                ///Header
                                                InkWell(
                                                  onTap: () {
                                                    setState(() {});
                                                  },
                                                  child: Container(
                                                    padding: const EdgeInsets
                                                        .fromLTRB(20, 8, 20, 8),
                                                    decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        border: Border(
                                                          top: BorderSide(
                                                              color: Colors.grey
                                                                  .shade400),
                                                          bottom: BorderSide(
                                                              color: Colors.grey
                                                                  .shade400),
                                                        )),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        //Text(
                                                        //  taskListNames[index],
                                                        //  style: TextStyle(
                                                        //    fontSize: 20,
                                                        //  ),
                                                        //),
                                                        Container(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width -
                                                              140,
                                                          child: Focus(
                                                            child: TextField(
                                                              controller:
                                                                  controllersList[
                                                                      index],
                                                              style: TextStyle(
                                                                  fontSize: 20),
                                                              decoration:
                                                                  InputDecoration(
                                                                border:
                                                                    InputBorder
                                                                        .none,
                                                                focusedBorder:
                                                                    InputBorder
                                                                        .none,
                                                                enabledBorder:
                                                                    InputBorder
                                                                        .none,
                                                                errorBorder:
                                                                    InputBorder
                                                                        .none,
                                                                disabledBorder:
                                                                    InputBorder
                                                                        .none,
                                                                hintStyle:
                                                                    TextStyle(
                                                                        fontSize:
                                                                            20),
                                                              ),
                                                            ),
                                                            onFocusChange:
                                                                (hasFocus) {
                                                              if (hasFocus) {
                                                                setState(() {
                                                                  isChangeListName =
                                                                      true;
                                                                  xChangeTaskListName =
                                                                      index;
                                                                });
                                                              } else {
                                                                setState(() {
                                                                  isChangeListName =
                                                                      false;
                                                                  xChangeTaskListName =
                                                                      -1;
                                                                });
                                                              }
                                                            },
                                                          ),
                                                        ),
                                                        Row(
                                                          children: [
                                                            AnimatedIconButton(
                                                                size: 25,
                                                                onPressed: () =>
                                                                    {
                                                                      setState(
                                                                          () {
                                                                        isShow[index] =
                                                                            !isShow[index];
                                                                      })
                                                                    },
                                                                icons: [
                                                                  AnimatedIconItem(
                                                                    icon: Icon(
                                                                      Icons
                                                                          .keyboard_arrow_down,
                                                                      color: Colors
                                                                          .black,
                                                                    ),
                                                                  ),
                                                                  AnimatedIconItem(
                                                                    icon: Icon(
                                                                      Icons
                                                                          .keyboard_arrow_up,
                                                                      color: Colors
                                                                          .black,
                                                                    ),
                                                                  ),
                                                                ]),
                                                            PopupMenuButton(
                                                              iconSize: 30,
                                                              padding:
                                                                  EdgeInsets
                                                                      .zero,
                                                              icon: Icon(Icons
                                                                  .more_horiz),
                                                              onSelected:
                                                                  (value) {
                                                                ///TODO: Delete task list
                                                              },
                                                              itemBuilder:
                                                                  (context) => [
                                                                PopupMenuItem(
                                                                  value: 1,
                                                                  child: Text(
                                                                    'Xóa',
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          20,
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
                                                ),
                                                Container(
                                                  height: 5,
                                                  decoration: BoxDecoration(
                                                      color: Color.fromRGBO(
                                                          188, 217, 234, 1)),
                                                  child: Row(),
                                                ),
                                                isShow[index]
                                                    ? Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.white,
                                                        ),
                                                        child: Column(
                                                          children: [
                                                            Column(
                                                              children:
                                                                  List.generate(
                                                                tasks[index]
                                                                    .length,
                                                                (innerIndex) =>
                                                                    Column(
                                                                  children: [
                                                                    Row(
                                                                      children: [
                                                                        Transform
                                                                            .scale(
                                                                          scale:
                                                                              1.2,
                                                                          child:
                                                                              Checkbox(
                                                                            value:
                                                                                isTaskDone[index][innerIndex],
                                                                            onChanged:
                                                                                (value) {
                                                                              setState(() {
                                                                                isTaskDone[index][innerIndex] = !isTaskDone[index][innerIndex];

                                                                                ///TODO: Change state of task
                                                                              });
                                                                            },
                                                                          ),
                                                                        ),
                                                                        Container(
                                                                          width:
                                                                              MediaQuery.of(context).size.width - 100,
                                                                          child:
                                                                              Focus(
                                                                            child:
                                                                                TextField(
                                                                              controller: controllers[index][innerIndex],
                                                                              style: TextStyle(fontSize: 20),
                                                                              decoration: InputDecoration(
                                                                                border: InputBorder.none,
                                                                                focusedBorder: InputBorder.none,
                                                                                enabledBorder: InputBorder.none,
                                                                                errorBorder: InputBorder.none,
                                                                                disabledBorder: InputBorder.none,
                                                                                hintStyle: TextStyle(fontSize: 20),
                                                                              ),
                                                                            ),
                                                                            onFocusChange:
                                                                                (hasFocus) {
                                                                              if (hasFocus) {
                                                                                setState(() {
                                                                                  isChangeTaskListName = true;
                                                                                  xChangeTaskListName = index;
                                                                                  yChangeTaskListName = innerIndex;
                                                                                });
                                                                              } else {
                                                                                setState(() {
                                                                                  isChangeTaskListName = false;
                                                                                  xChangeTaskListName = -1;
                                                                                  yChangeTaskListName = -1;
                                                                                });
                                                                              }
                                                                            },
                                                                          ),
                                                                        ),
                                                                        isChangeTaskListName &&
                                                                                index == xChangeTaskListName &&
                                                                                innerIndex == yChangeTaskListName
                                                                            ? IconButton(onPressed: () {}, icon: Icon(Icons.delete))
                                                                            : SizedBox(
                                                                                width: 0,
                                                                              ),
                                                                      ],
                                                                    ),
                                                                    Padding(
                                                                      padding:
                                                                          const EdgeInsets.fromLTRB(
                                                                              50,
                                                                              0,
                                                                              0,
                                                                              0),
                                                                      child:
                                                                          Divider(),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .fromLTRB(
                                                                      0,
                                                                      2,
                                                                      0,
                                                                      8),
                                                              child: Row(
                                                                children: [
                                                                  SizedBox(
                                                                    width: 50,
                                                                  ),
                                                                  Container(
                                                                    width: MediaQuery.of(context)
                                                                            .size
                                                                            .width -
                                                                        70,
                                                                    child:
                                                                        Focus(
                                                                      child:
                                                                          TextField(
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                20),
                                                                        cursorColor:
                                                                            Colors.blue,
                                                                        decoration:
                                                                            InputDecoration(
                                                                          border:
                                                                              InputBorder.none,
                                                                          focusedBorder:
                                                                              InputBorder.none,
                                                                          enabledBorder:
                                                                              InputBorder.none,
                                                                          errorBorder:
                                                                              InputBorder.none,
                                                                          disabledBorder:
                                                                              InputBorder.none,
                                                                          hintText:
                                                                              "Thêm mục…",
                                                                          hintStyle:
                                                                              TextStyle(fontSize: 20),
                                                                        ),
                                                                      ),
                                                                      onFocusChange:
                                                                          (hasFocus) {
                                                                        if (hasFocus) {
                                                                          setState(
                                                                              () {
                                                                            isAddTask =
                                                                                true;
                                                                          });
                                                                        } else {
                                                                          setState(
                                                                              () {
                                                                            isAddTask =
                                                                                false;
                                                                          });
                                                                        }
                                                                      },
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      )
                                                    : SizedBox(
                                                        height: 0,
                                                      ),
                                              ],
                                            )),
                                  ),
                                ],
                              )
                            : SizedBox(
                                height: 0,
                              ),

                        ///Comment display here
                        ///TODO: remember to change list to the loaded commentList
                        commentUserIDList.length < 1
                            ? SizedBox(height: 30)
                            : Column(
                                children: List.generate(
                                commentUserIDList.length,
                                (index) => Padding(
                                  padding: const EdgeInsets.only(
                                      left: 25, right: 20, top: 20),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(top: 20),
                                        child: CircleAvatar(
                                          radius: 25,

                                          ///TODO: Load Avatar
                                          backgroundImage: AssetImage(
                                              commentUserAvatarList[index]),
                                        ),
                                      ),
                                      SizedBox(width: 20),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          ///User Name
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width -
                                                115,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                ///TODO: Load User Name who comments this
                                                Text(
                                                  commentUserNameList[index],
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 18),
                                                ),

                                                PopupMenuButton(
                                                    icon:
                                                        Icon(Icons.more_horiz),
                                                    itemBuilder: (BuildContext
                                                            context) =>
                                                        <
                                                            PopupMenuEntry<
                                                                String>>[
                                                          const PopupMenuItem<
                                                              String>(
                                                            value:
                                                                "Chỉnh sửa",
                                                            child: Text(
                                                                'Chỉnh sửa'),
                                                          ),
                                                          const PopupMenuItem<
                                                              String>(
                                                            value: "Xóa",
                                                            child: Text('Xóa'),
                                                          ),
                                                        ]),
                                              ],
                                            ),
                                          ),

                                          ///Comment content
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width -
                                                115,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10)),
                                            ),
                                            child: TextField(
                                              controller:
                                                  commentContentTxtCtrlList[
                                                      index],
                                              readOnly: true,
                                              keyboardType:
                                                  TextInputType.multiline,
                                              maxLines: null,
                                              decoration: InputDecoration(
                                                contentPadding:
                                                    const EdgeInsets.all(5),
                                                border: InputBorder.none,
                                                focusedBorder: InputBorder.none,
                                                enabledBorder: InputBorder.none,
                                                errorBorder: InputBorder.none,
                                                disabledBorder:
                                                    InputBorder.none,
                                              ),
                                            ),
                                          ),

                                          SizedBox(height: 10),

                                          ///Load date comment
                                          ///TODO: change suitable variable to the
                                          ///Format hh:mm dd/mm/yyyy if year is different from current year
                                          ///Format hh:mm dd/mm if year is equal to current year
                                          Container(
                                            alignment: Alignment.centerLeft,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width -
                                                115,
                                            child: commentDateList[index].year ==
                                                    DateTime.now().year
                                                ? Text(commentDateList[index]
                                                        .hour
                                                        .toString() +
                                                    ":" +
                                                    (commentDateList[index].minute >= 10
                                                        ? commentDateList[index]
                                                            .minute
                                                            .toString()
                                                        : "0" +
                                                            commentDateList[index]
                                                                .minute
                                                                .toString()) +
                                                    " " +
                                                    commentDateList[index]
                                                        .day
                                                        .toString() +
                                                    "/" +
                                                    commentDateList[index]
                                                        .month
                                                        .toString())
                                                : Text(commentDateList[index]
                                                        .hour
                                                        .toString() +
                                                    ":" +
                                                    (commentDateList[index].minute >= 10
                                                        ? commentDateList[index]
                                                            .minute
                                                            .toString()
                                                        : "0" +
                                                            commentDateList[index]
                                                                .minute
                                                                .toString()) +
                                                    " " +
                                                    commentDateList[index]
                                                        .day
                                                        .toString() +
                                                    "/" +
                                                    commentDateList[index]
                                                        .month
                                                        .toString() +
                                                    "/" +
                                                    commentDateList[index]
                                                        .year
                                                        .toString()),
                                          ),

                                          SizedBox(height: 20),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              )),

                        ///for bottom sheet not cover last element
                        SizedBox(
                          height: 69,
                        )
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
                          avatar(50, 50, Colors.grey,
                              Image.asset('assets/images/BlueBG.png')),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: TextField(
                              controller: commentEnterTxtCtrl,
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
              });
        });
  }
}
