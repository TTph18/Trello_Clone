import 'package:flutter/material.dart';
import 'package:trello_clone/widgets/create_board_screen/create_board_form.dart';

class CreateBoardScreen extends StatefulWidget {
  @override
  CreateBoardScreenState createState() => CreateBoardScreenState();
}

class CreateBoardScreenState extends State<CreateBoardScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
