import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class avatar extends StatelessWidget {
  late double width = 50;
  late double height = 50;
  late Color borderColor = Colors.grey;
  late Image ava;

  avatar(this.width, this.height, this.borderColor, this.ava);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: new BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: borderColor),
        image: new DecorationImage(
          fit: BoxFit.cover,
          image: ava.image,
        ),
      ),
    );
  }
}