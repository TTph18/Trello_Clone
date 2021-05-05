import 'package:flutter/material.dart';

class CustomListTile extends StatelessWidget {
  late IconData icon;
  late String text;
  late VoidCallback onTap;

  CustomListTile(this.icon, this.text, this.onTap);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 14.0, 0, 14.0),
        child: Row(
          children: <Widget>[
            Icon(icon),
            SizedBox(
              width: 30,
            ),
            Text(
              text,
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}