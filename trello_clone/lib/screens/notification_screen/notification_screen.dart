import 'package:flutter/material.dart';
import 'package:trello_clone/models/boards.dart';
import 'package:trello_clone/screens/board_screen/board_screen.dart';
import 'package:trello_clone/widgets/reuse_widget/avatar.dart';

class NotificationScreen extends StatefulWidget {
  @override
  NotificationScreenState createState() => NotificationScreenState();
}

class NotificationScreenState extends State<NotificationScreen> {
  late List<Boards> boards;
  List<String> titles = [
    'Title 1',
    'Title 2',
    'Title 3',
  ];
  List<String> times = [
    'Times 1',
    'Times 2',
    'Times 3',
  ];
  List<String> avas = [
    'assets/images/BlueBG.png',
    'assets/images/BlueBG.png',
    'assets/images/BlueBG.png',
  ];
  @override
  void initState() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Thông báo",
        ),
      ),
      body: ListView.builder(
          itemCount: titles.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                ///TODO: Uncomment after init boards
                //Route route = MaterialPageRoute(
                //    builder: (context) => BoardScreen(boards[index], false));
                //Navigator.push(context, route);
              },
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                    ),
                    child: Row(
                      children: [
                        avatar(
                          50,
                          50,
                          Colors.grey,
                          Image.asset(avas[index]),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              titles[index],
                              style: TextStyle(fontSize: 16),
                            ),
                            Text(
                              times[index],
                              style: TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Divider(),
                ],
              ),
            );
          }),
    );
  }
}
