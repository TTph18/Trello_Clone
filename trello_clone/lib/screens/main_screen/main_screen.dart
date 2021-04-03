import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trello_clone/icons/app_icons.dart';
import 'dart:math' as math;
import 'package:trello_clone/route_path.dart';
import 'package:animate_icons/animate_icons.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

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

class BoardInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(15, 10, 15, 5),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(0, 0, 15, 0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(3.0),
              child: Image(
                image: AssetImage('assets/images/BlueBG.png'),
                width: 50,
                height: 50,
              ),
            ),
          ),
          Text("Tên bảng", style: TextStyle(fontSize: 20),),
        ],
      ),
    );
  }
}



class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    var controller = AnimateIconController();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        leading: new Container(
          child: new Icon(Icons.menu),
        ),
        title: Text('Bảng'),
        actions: [
          IconButton(icon: Transform(
            alignment: Alignment.center,
            transform: Matrix4.rotationY(math.pi),
            child: Icon(MyFlutterApp.search),
          ), onPressed: () {},),
          IconButton(icon: const Icon(MyFlutterApp.bell), onPressed: () {},)
        ]
      ),
      body: Column(
        children: [
          MyAppBar(
            title: Text("Bảng cá nhân", style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.normal,
              fontSize: 16,
            ),),
          ),
          Expanded(
            child: ListView.builder(
              physics: ClampingScrollPhysics(),
              shrinkWrap: true,
              itemCount: 20,
              itemBuilder: (BuildContext context, int index) {
                return BoardInfo();
              },
            ),
          ) //ListView.builder(itemBuilder: itemBuilder)
        ],
      ),
      //floatingActionButton: FloatingActionButton(
      //    onPressed: () {
      //      Navigator.of(context).pushNamed(CREATE_BOARD_SCREEN);
      //    },
      //    backgroundColor: Colors.green,
      //    child: Icon(Icons.menu),
      //),
      floatingActionButton: SpeedDial(
        backgroundColor: Colors.green,
        child: //Icon(Icons.ac_unit),
        AnimateIcons(
          startIcon: Icons.add,
          endIcon: Icons.remove,
          controller: controller = AnimateIconController(),
          onStartIconPress: () {
            return true;
          },
          onEndIconPress: () {
            return true;
          },
          duration: Duration(milliseconds: 100),
          startIconColor: Colors.white,
          endIconColor: Colors.white,
          clockwise: true,
        ),
        visible: true,
        curve: Curves.bounceIn,
        children: [
          SpeedDialChild(
            child: Icon(Icons.accessibility, color: Colors.white,),
            backgroundColor: Colors.green,
            onTap: () {},
          ),
          SpeedDialChild(
            child: Icon(Icons.brush, color: Colors.white,),
            backgroundColor: Colors.green,
            onTap: () {},
          ),
        ],
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
