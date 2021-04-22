import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:trello_clone/screens/login_screen/login_screen.dart';
import 'package:trello_clone/screens/main_screen/main_screen.dart';
import 'package:provider/provider.dart';

class AuthenticationWrapper extends StatefulWidget {
  @override
  _AuthenticationWrapperState createState() => _AuthenticationWrapperState();
}

class _AuthenticationWrapperState extends State<AuthenticationWrapper> {
  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User>();
    if (firebaseUser != null) {
      return Material(
        child: MainScreen(),
      );
    }
    return Material(
      child: LoginScreen(),
    );
  }
}