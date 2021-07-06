import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trello_clone/icons/app_icons.dart';
import 'package:trello_clone/icons/my_flutter_app2_icons.dart';
import 'package:trello_clone/models/boards.dart';
import 'dart:math' as math;

import 'package:trello_clone/widgets/reuse_widget/avatar.dart';

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
      resizeToAvoidBottomInset: true,
      backgroundColor: Color.fromRGBO(244, 245, 247, 1.0),
      appBar: AppBar(
          backgroundColor: Colors.white,
          leading: Builder(builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.clear),
              color: Colors.black,
              onPressed: () {
                ///TODO: Uncomment after init boards
                //Route route =
                //MaterialPageRoute(builder: (context) => BoardScreen(boards, false));
                //Navigator.push(context, route);
              },
            );
          }),
          elevation: 0.0,
          actions: [
            PopupMenuButton<String>(
                icon: const Icon(
                  Icons.more_vert,
                  color: Colors.black,
                ),
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
                    child: Text("Tên thẻ", style: TextStyle(fontSize: 30)),
                    /// Change card name to $cardName when data is loaded
                  ),
                ),

                ///Card auto-description (user cannot change this description)
                Container(
                  width: MediaQuery.of(context).size.width,
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 25.0, top: 15.0, bottom: 20.0),
                    child: Text("Danh sách Tên danh sách trong Tên bảng",
                        ///Change card list name to $cardlistName
                        ///Change board name to $boardName
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

                SizedBox(
                  height: 10,
                ),

                ///Member
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
                      Icon(MyFlutterApp.person_outline),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        "Thành viên...",
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
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
                        top: BorderSide(color: Colors.grey.shade400),),
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
                          width: 24,
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width - 94,
                          child: Text(endDateStr == ""
                              ? "Ngày hết hạn..."
                              : "$endDateStr",
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      ],
                    ),
                  ),
                  onTap: () {
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

                ///Attachment
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
                      Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.rotationY(math.pi),
                        child: Icon(MyFlutterApp2.attach),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        "Tệp đính kèm...",
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                ),

                ///for bottom sheet not cover last element
                SizedBox(height: 69,)

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
              avatar(50, 50, Colors.grey,
                  Image.asset('assets/images/BlueBG.png')),
              SizedBox(width: 10,),
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Enter a message',
                    suffixIcon: IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.send, size: 30,),
                    ),
                    border: new OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(30.0),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10,),
              IconButton(
                  onPressed: () {}, icon: Icon(MyFlutterApp2.attach)),
            ],
          ),
        ),
      ),
    );
  }
}
