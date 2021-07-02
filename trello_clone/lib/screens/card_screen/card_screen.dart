import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CardScreen extends StatefulWidget {
  late String cardName;
  CardScreen(this.cardName);

  @override
  CardScreenState createState() => CardScreenState(cardName);
}

class CardScreenState extends State<CardScreen> {
  late String cardName;
  CardScreenState(this.cardName);

  @override
  Widget build(BuildContext context) {
    return Scaffold(

    );
  }

}