import 'package:flutter/material.dart';
import 'package:trello_clone/route_path.dart';

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  var _loginFormKey = GlobalKey<FormState>();
  var _emailTextController = TextEditingController();
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
                controller: _emailTextController,
                decoration: InputDecoration(
                    hintText: "Email"
                ),
                validator: (value){
                  if (_emailTextController.text.length <= 0) {
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
                validator: (value){
                  if (_passwordTextController.text.length <= 0) {
                    return "Mật khẩu không được để trống";
                  }
                  return null;
                },
              ),
              ElevatedButton(
                  onPressed: () {
                    if(_loginFormKey.currentState.validate()) {
                      Navigator.of(context).pushNamed(MAIN_SCREEN);
                    }
                  },
                  child: Text("Đăng nhập")),
              TextButton(
                  onPressed: (){
                    {
                      Navigator.of(context).pushNamed(REGISTER_SCREEN);
                    }
                  },
                child: Text("Chưa có tài khoản?")
              )
            ],
          ),
        )
    );
  }
}
