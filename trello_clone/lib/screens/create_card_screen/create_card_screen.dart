import 'package:flutter/material.dart';
import '../../route_path.dart';

class CreateCardScreen extends StatefulWidget {
  @override
  CreateCardScreenState createState() => CreateCardScreenState();
}

class CreateCardScreenState extends State<CreateCardScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Thêm thẻ'),
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
    );
  }
}
