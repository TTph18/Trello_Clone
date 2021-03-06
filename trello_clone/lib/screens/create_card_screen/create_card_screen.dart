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
      workspaceID: "",
      listNumber: 0, cardNumber: 0, description: "");
  late Boards selectedBoard = nullBr;
  late List<Workspaces> workspaceList = [];
  late Future<List<Users>> futureUserList;
  late List<BoardItem> boardItems = [];

  List<String> boardList = [];
  late Lists selectedList;
  final GlobalKey<FormFieldState> _cardListSelectKey = GlobalKey<FormFieldState>();
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
    selectedList = Lists(
        listID: "", listName: "", cardList: [], position: 1, cardNumber: 0);
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
          endDate = "";
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
          endTime = "";
          startTimeTxtCtrl.text = "";
          endTimeTxtCtrl.text = "";
      }
    });
  }

  String? selectedNotiTime = "Kh??ng nh????c nh????";
  List<String> notificationTimeList = [
    "Kh??ng nh????c nh????",
    "Va??o nga??y h????t ha??n",
    "5 phu??t tr??????c",
    "10 phu??t tr??????c",
    "15 phu??t tr??????c",
    "1 gi???? tr??????c",
    "2 gi???? tr??????c",
    "1 nga??y tr??????c",
    "2 nga??y tr??????c"
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
          title: Text('Th??m th???'),
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

                for (var item in pickedUsers) {
                  userListID.add(item.userID);
                }
                DatabaseService.addCard(
                    selectedBoard.boardID,
                    selectedList.listID,
                    cardNameTxtCtrl.text,
                    descriptionTxtCtrl.text,
                    uid,
                    userListID,
                    startDate,
                    endDate,
                    startTime,
                    endTime);
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
                child: StreamBuilder(
                    stream: DatabaseService.streamWorkspaces(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (!snapshot.hasData) {
                        return Container(
                            alignment: FractionalOffset.center,
                            child: CircularProgressIndicator());
                      } else {
                        workspaceList = snapshot.data;
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
                              for (var _item in workspaceList) {
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
                                  "Ch???n b???ng",
                                  style: TextStyle(fontSize: 20.0),
                                ),
                              ),
                              decoration: InputDecoration(
                                labelStyle:
                                    TextStyle(fontSize: 18.0, height: 0.9),
                                labelText: "B???ng",
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
                                _cardListSelectKey.currentState!.reset();
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
              child: StreamBuilder(
                  stream: DatabaseService.streamLists(selectedBoard.boardID),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (!snapshot.hasData) {
                      return DropdownButtonFormField(
                        icon: Icon(Icons.keyboard_arrow_down),
                        hint: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Ch???n danh s??ch",
                            style: TextStyle(fontSize: 20.0),
                          ),
                        ),
                        decoration: InputDecoration(
                          labelStyle: TextStyle(fontSize: 18.0, height: 0.9),
                          labelText: "Danh s??ch",
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          contentPadding: EdgeInsets.only(bottom: 0),
                        ),
                        items: [],
                      );
                    } else {
                      listList.clear();
                      for (var item in snapshot.data.docs) {
                        Lists _list = Lists.fromDocument(item);
                        listList.add(_list);
                      }
                    }
                    return DropdownButtonFormField(
                      key: _cardListSelectKey,
                      icon: Icon(Icons.keyboard_arrow_down),
                      hint: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Ch???n danh s??ch",
                          style: TextStyle(fontSize: 20.0),
                        ),
                      ),
                      decoration: InputDecoration(
                        labelStyle: TextStyle(fontSize: 18.0, height: 0.9),
                        labelText: "Danh s??ch",
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
                          labelText: "T??n th???",
                          contentPadding: EdgeInsets.only(bottom: 5),
                        ),
                        style: TextStyle(fontSize: 22.0),

                        // The validator receives the text that the user has entered.
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'T??n th??? kh??ng ???????c ????? tr???ng';
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
                          labelText: "M?? t???",
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
                                : StreamBuilder(
                                    stream: DatabaseService.streamListUser(
                                        selectedBoard.userList),
                                    builder: (BuildContext context,
                                        AsyncSnapshot snapshot) {
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
                                                          NetworkImage(
                                                                  users[index]
                                                                      .avatar),
                                                        ),
                                                        title: Text(
                                                            '${users[index].profileName}'),
                                                      ),
                                                    ),
                                                  ),
                                                  onSelected: (value) {
                                                    setState(() {
                                                      bool isSelected = false;
                                                      for (var item
                                                          in pickedUsers) {
                                                        if (value.userID ==
                                                            item.userID)
                                                          isSelected = true;
                                                      }
                                                      if (!isSelected)
                                                        pickedUsers.add(value);
                                                      else
                                                        pickedUsers.removeWhere((element) => element.userID == value.userID);
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
                                                                NetworkImage(
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
                                          'Nga??y b????t ??????u',
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
                                                        hintText: "Cho??n nga??y",
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
                                                            "Cho??n th????i gian",
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
                                                      child: Text("HU??Y"),
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
                                                                "B????t ??????u va??o nga??y $selectedDay tha??ng $selectedMonth, n??m $selectedYear lu??c $selectedTimeStr";
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
                                                      child: Text("HOA??N T????T"),
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
                                            ? "Ng??y b???t ?????u..."
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
                                          'Nga??y b????t ??????u',
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
                                                        hintText: "Cho??n nga??y",
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
                                                            "Cho??n th????i gian",
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
                                                      child: Text("HU??Y"),
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
                                                            startDate =
                                                                selectedDate
                                                                    .toString();
                                                            startTime =
                                                                selectedTime
                                                                    .format(
                                                                        context);
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
                                                                "B????t ??????u va??o nga??y $selectedDay tha??ng $selectedMonth, n??m $selectedYear lu??c $selectedTimeStr";
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
                                                      child: Text("HOA??N T????T"),
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
                                            ? "Ng??y h???t h???n..."
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
                                          'Nga??y h????t ha??n',
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
                                                        hintText: "Cho??n nga??y",
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
                                                            "Cho??n th????i gian",
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
                                                  "Thi????t l????p nh????c nh????",
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
                                                    "Nh????c nh???? chi?? ????????c g????i ??????n ca??c tha??nh vi??n va?? ng??????i theo do??i the??."),
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
                                                      child: Text("HU??Y"),
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
                                                                "H????t ha??n va??o nga??y $selectedDay tha??ng $selectedMonth, n??m $selectedYear lu??c $selectedTimeStr";
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
                                                      child: Text("HOA??N T????T"),
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
