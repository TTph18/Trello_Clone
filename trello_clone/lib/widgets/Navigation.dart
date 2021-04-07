import 'dart:ui';
import 'package:flutter/material.dart';

class Item extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(15, 10, 15, 5),
      child: Row(
        children: [
          Icon(Icons.dashboard_sharp),
          SizedBox(width: 20,),
          Text("Bảng", style: TextStyle(fontSize: 16),),
        ],
      ),
    );
  }
}

class NavigationDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
          ),
          Item(),
          Item(),
          Divider(
            thickness: 2,
          ),
          Text(
              "Nhóm",
              style: TextStyle(
                  fontWeight: FontWeight.bold
              )
          ),
          ListView.builder(
              physics: ClampingScrollPhysics(),
              shrinkWrap: true,
              itemCount: 2,
              itemBuilder: (BuildContext context, int index) {
                return Item();
              },
            ),
          Divider(
            thickness: 2,
          ),
        ],
      ),
    );
  }
}