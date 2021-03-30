import 'package:flutter/material.dart';
import 'package:trello_clone/route_path.dart';

class RegisterForm extends StatefulWidget {
  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  var _registerFormKey = GlobalKey<FormState>();
  var _usernameTextController = TextEditingController();
  var _passwordTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _registerFormKey,
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
                    return "Email không được để trống";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordTextController,
                obscureText: true,
                decoration: InputDecoration(
                    hintText: "Mật khẩu"
                ),
              ),
              TextFormField(

                obscureText: true,
                decoration: InputDecoration(
                    hintText: "Nhập lại mật khẩu"
                ),
              ),
              ElevatedButton(
                  onPressed: () {
                    if(_registerFormKey.currentState.validate()) {
                      Navigator.of(context).pushNamed(MAIN_SCREEN);
                    }
                  },
                  child: Text("Tạo tài khoản"))
            ],
          ),
        )
    );
  }
}