import 'package:flutter/material.dart';
import 'package:trello_clone/route_path.dart';

class RegisterForm extends StatefulWidget {
  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  var _registerFormKey = GlobalKey<FormState>();
  var _emailTextController = TextEditingController();
  var _passwordTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => true,
      child: Form(
          key: _registerFormKey,
          child: Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 0),
              child: Container(
                  color: Colors.white,
                  child: Padding(
                      padding: const EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 20.0),
                      child: Column(children: [
                        Image(
                          image: AssetImage('assets/images/trello.png'),
                          width: 130,
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 30.0, 0, 0.0),
                          child: Column(
                            children: [
                              TextFormField(
                                controller: _emailTextController,
                                decoration: InputDecoration(hintText: "Email"),
                                validator: (value) {
                                  if (_emailTextController.text.length <= 0) {
                                    return "Email không được để trống";
                                  }
                                  return null;
                                },
                              ),
                              TextFormField(
                                controller: _passwordTextController,
                                obscureText: true,
                                decoration: InputDecoration(hintText: "Mật khẩu"),
                              ),
                              TextFormField(
                                obscureText: true,
                                decoration: InputDecoration(
                                    hintText: "Nhập lại mật khẩu"),
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(0, 20.0, 0, 10.0),
                                child: ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty.resolveWith<Color>(
                                            (Set<MaterialState> states) {
                                          if (states.contains(MaterialState.pressed))
                                            return Colors.green;
                                          return Colors.green; // Use the component's default.
                                        },
                                      ),
                                    ),
                                    onPressed: () {
                                      if(_registerFormKey.currentState.validate()) {
                                        Navigator.of(context).pushNamed(MAIN_SCREEN);
                                      }
                                    },
                                    child: Text("Xác nhận", style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),)
                                ),
                              ),
                            ],
                          ),
                        )
                      ]))))),
      );
  }
}
