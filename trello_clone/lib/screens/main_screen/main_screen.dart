import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class MyAppBar extends AppBar with PreferredSizeWidget {
  @override
  get preferredSize => Size.fromHeight(50);
  MyAppBar({Key key, Widget title}) : super(
    key: key,
    title: title,
    automaticallyImplyLeading: false,
    backgroundColor: Colors.white,
  );
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        leading: new Container(
          child: new Icon(Icons.menu),
        ),
        title: Text("Board"),
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () {},)
        ]
      ),
      body: Column(
        children: [
          MyAppBar(
            title: Text("'s workspace", style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.normal,
              fontSize: 16,
            ),),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.green,
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
