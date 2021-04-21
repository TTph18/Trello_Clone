import 'package:flutter/material.dart';
import 'package:trello_clone/widgets/create_board_screen/create_board_form.dart';
import '../../route_path.dart';

class CreateBoardScreen extends StatefulWidget {
  @override
  CreateBoardScreenState createState() => CreateBoardScreenState();
}

class CreateBoardScreenState extends State<CreateBoardScreen> {

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
          onPressed: () {},
        ),
      ]),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CreateBoardForm()
        ],
      ),
    );
  }
}
