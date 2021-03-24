import 'package:flutter/material.dart';
import 'package:trello_clone/route_path.dart';

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  var _loginFormKey = GlobalKey<FormState>();
  var _usernameTextController = TextEditingController();
  var _passwordTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _loginFormKey,
        child: Padding(
          padding: const EdgeInsets.only(left: 50.0, right: 50.0),
          child: Column(
            children: [
              TextFormField(
                controller: _usernameTextController,
                decoration: InputDecoration(
                    hintText: "Username"
                ),
                validator: (value){
                  if (_usernameTextController.text.length <= 0) {
                    return "Username cannot be empty";
                  } else if(_usernameTextController.text.length < 5) {
                    return "Username must be longer than 5";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordTextController,
                obscureText: true,
                decoration: InputDecoration(
                    hintText: "Password"
                ),
              ),
              ElevatedButton(
                  onPressed: () {
                    if(_loginFormKey.currentState.validate()) {
                      Navigator.of(context).pushNamed(MAIN_SCREEN);
                    }
                  },
                  child: Text("Login"))
            ],
          ),
        )
    );
  }
}
