import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:trello_clone/icons/app_icons.dart';
import 'package:trello_clone/models/user.dart';
import 'package:trello_clone/screens/card_screen/board_item.dart';
import '../../route_path.dart';

class CreateCardScreen extends StatefulWidget {
  @override
  CreateCardScreenState createState() => CreateCardScreenState();
}

class CreateCardScreenState extends State<CreateCardScreen> {
  final formKey = GlobalKey<FormState>();
  String selectedBoard = "";
  List<String> groupName = ["Tên nhóm 1", "Tên nhóm 2", "Tên nhóm 3"];
  List<BoardItem> boardItems = [
    BoardItem(name: "Tên nhóm 1", type: "sep"),
    BoardItem(name: "Tên bảng 1 nhóm 1", type: "data"),
    BoardItem(name: "Tên bảng 2 nhóm 1", type: "data"),
    BoardItem(name: "Tên nhóm 2", type: "sep"),
    BoardItem(name: "Tên bảng 1 nhóm 2", type: "data"),
    BoardItem(name: "Tên bảng 2 nhóm 2", type: "data"),
    BoardItem(name: "Tên bảng 3 nhóm 2", type: "data"),
    BoardItem(name: "Tên bảng 4 nhóm 2", type: "data"),
    BoardItem(name: "Tên nhóm 3", type: "sep"),
    BoardItem(name: "Tên bảng 1 nhóm 3", type: "data"),
    BoardItem(name: "Tên bảng 2 nhóm 3", type: "data"),
    BoardItem(name: "Tên bảng 3 nhóm 3", type: "data"),
  ];

  List<String> boardList = ["Tên bảng 1", "Tên bảng 2", "Tên bảng 3"];
  String? selectedList = "";
  List<String> listList = [
    "Tên danh sách 1",
    "Tên danh sách 2",
    "Tên danh sách 3"
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

  List<Users> pickedUsers = [];

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
          if (selectedTime.minute >= 10)
            startTimeTxtCtrl.text =
                startTimeTxtCtrl.text + selectedTime.minute.toString();
          else
            startTimeTxtCtrl.text =
                startTimeTxtCtrl.text + "0" + selectedTime.minute.toString();
          break;
        case 2:
          endTimeTxtCtrl.text = selectedTime.hour.toString() + ":";
          if (selectedTime.minute >= 10)
            endTimeTxtCtrl.text =
                endTimeTxtCtrl.text + selectedTime.minute.toString();
          else
            endTimeTxtCtrl.text =
                endTimeTxtCtrl.text + "0" + selectedTime.minute.toString();
          break;
        default:
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
              onPressed: () {},
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
                child: DropdownButtonFormField<String>(
                  icon: Icon(Icons.keyboard_arrow_down),
                  hint: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Chọn bảng",
                      style: TextStyle(fontSize: 20.0),
                    ),
                  ),
                  decoration: InputDecoration(
                    labelStyle: TextStyle(fontSize: 18.0, height: 0.9),
                    labelText: "Bảng",
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    contentPadding: EdgeInsets.only(bottom: 0),
                  ),
                  onChanged: (value) {
                    if (value != null)
                      print("VALUE: " + value);
                    else
                      print("NOT VALUE");
                    if (boardItems[boardItems
                                .indexWhere((element) => element.name == value)]
                            .type ==
                        "sep") {
                      return;
                    }
                    setState(() {
                      if (value != null) selectedBoard = value;
                    });
                  },
                  selectedItemBuilder: (BuildContext context) {
                    return boardItems.map((BoardItem item) {
                      return Text(
                        selectedBoard,
                        style: TextStyle(
                          fontSize: 20.0,
                        ),
                      );
                    }).toList();
                  },
                  items: boardItems.map((BoardItem item) {
                    return DropdownMenuItem(
                      value: item.name,
                      onTap: item.type == "data" ? () {} : null,
                      child: item.type == "data"
                          ? Container(
                              padding: EdgeInsets.fromLTRB(15, 7, 15, 7),
                              child: Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.fromLTRB(0, 0, 15, 0),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(3.0),
                                      child: Image(
                                        image: AssetImage(
                                            "assets/images/BlueBG.png"),
                                        width: 50,
                                        height: 50,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    item.name,
                                    style: TextStyle(fontSize: 20),
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
                                      width: 1.0, color: Colors.black),
                                  bottom: BorderSide(
                                      width: 1.0, color: Colors.black),
                                ),
                              ),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  item.name,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                    );
                  }).toList(),
                ),
              ),
            ),

            ///Card list selection
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
              child: DropdownButtonFormField<String>(
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
                onChanged: selectedBoard == ""
                    ? null
                    : (value) {
                        setState(() {
                          selectedList = value;
                        });
                      },
                selectedItemBuilder: (BuildContext context) {
                  return listList.map<Widget>((String item) {
                    return Text(
                      item,
                      style: TextStyle(
                        fontSize: 20.0,
                      ),
                    );
                  }).toList();
                },
                items: listList.map((String item) {
                  return DropdownMenuItem<String>(
                      value: item,
                      child: Row(
                        children: [
                          Text(item, style: TextStyle(fontSize: 20.0)),
                        ],
                      ));
                }).toList(),
              ),
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
                            ///Members here
                            selectedBoard == ""
                                ? SizedBox()
                                : Row(
                                    children: [
                                      IconButton(
                                        icon: Icon(MyFlutterApp.person_outline),
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
                                                (index) => PopupMenuItem<Users>(
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
                                                  pickedUsers.add(value);
                                                  print("Length = " +
                                                      pickedUsers.length
                                                          .toString());
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
                                                            AssetImage(
                                                                pickedUsers[
                                                                        index]
                                                                    .avatar),
                                                      );
                                                    }),
                                              ),
                                            ),
                                    ],
                                  ),

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
                                                        if (startDateTxtCtrl.text == "" && startTimeTxtCtrl.text == "")
                                                          {
                                                            setState(() {
                                                              startDateStr = "";
                                                            });
                                                            ///Save null to database
                                                          }
                                                        else
                                                        {
                                                          setState(() {
                                                            String selectedDay = selectedDate.day.toString();
                                                            String selectedMonth = selectedDate.month.toString();
                                                            String selectedYear = selectedDate.year.toString();
                                                            String selectedTimeStr = selectedTime.hour.toString() + (selectedTime.minute >= 10 ? selectedTime.minute.toString() : "0" + selectedTime.minute.toString());
                                                            startDateStr = "Bắt đầu vào ngày $selectedDay tháng $selectedMonth, năm $selectedYear lúc $selectedTimeStr";
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
                                    child: Text(startDateStr == ""
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
                                                        if (startDateTxtCtrl.text == "" && startTimeTxtCtrl.text == "")
                                                        {
                                                          setState(() {
                                                            startDateStr = "";
                                                          });
                                                          ///Save null to database
                                                        }
                                                        else
                                                        {
                                                          setState(() {
                                                            String selectedDay = selectedDate.day.toString();
                                                            String selectedMonth = selectedDate.month.toString();
                                                            String selectedYear = selectedDate.year.toString();
                                                            String selectedTimeStr = selectedTime.hour.toString() + (selectedTime.minute >= 10 ? ":0" + selectedTime.minute.toString() : ":0" + selectedTime.minute.toString());
                                                            startDateStr = "Bắt đầu vào ngày $selectedDay tháng $selectedMonth, năm $selectedYear lúc $selectedTimeStr";
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
                                    child: Text(endDateStr == ""
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
                                                width:
                                                MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                child:
                                                DropdownButtonFormField<
                                                    String>(
                                                  value: selectedNotiTime,
                                                  decoration:
                                                  InputDecoration(
                                                    contentPadding:
                                                    EdgeInsets.only(
                                                        bottom: 0),
                                                  ),
                                                  onChanged: (value) {
                                                    setState(() {
                                                      selectedNotiTime =
                                                          value;
                                                    });
                                                  },
                                                  items:
                                                  notificationTimeList
                                                      .map((String
                                                  item) {
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
                                                        if (endDateTxtCtrl.text == "" && endDateTxtCtrl.text == "")
                                                        {
                                                          setState(() {
                                                            endDateStr = "";
                                                          });
                                                          ///Save null to database
                                                        }
                                                        else
                                                        {
                                                          setState(() {
                                                            String selectedDay = selectedDate.day.toString();
                                                            String selectedMonth = selectedDate.month.toString();
                                                            String selectedYear = selectedDate.year.toString();
                                                            String selectedTimeStr = selectedTime.hour.toString() + (selectedTime.minute >= 10 ? ":0" + selectedTime.minute.toString() : ":0" + selectedTime.minute.toString());
                                                            endDateStr = "Hết hạn vào ngày $selectedDay tháng $selectedMonth, năm $selectedYear lúc $selectedTimeStr";
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
