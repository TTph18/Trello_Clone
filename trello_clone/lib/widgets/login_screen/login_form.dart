import 'package:flutter/material.dart';
import 'package:trello_clone/route_path.dart';
import 'package:trello_clone/screens/main_screen/main_screen.dart';
import 'package:trello_clone/services/authentication_service.dart';
import 'package:trello_clone/services/validate_service.dart';

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  var _loginFormKey = GlobalKey<FormState>();
  var _emailTextController = TextEditingController();
  var _passwordTextController = TextEditingController();
  String _error = "";

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Center(
        child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
        children: [
        Form(
        key: _loginFormKey,
        child: Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 0),
            child: Container(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 20.0),
                  child: Column(
                    children: [
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
                                  decoration: InputDecoration(
                                    hintText: "Email",
                                  ),
                                  validator: (value) {
                                    if (_emailTextController.text.length <= 0) {
                                      return "Email không được để trống";
                                    }
                                    /*else if (!validateEmail(_emailTextController.toString())) {
                            return "Email không hợp lệ"; //Bo sung sau
                          }*/ else
                                      return null;
                                  },
                                ),
                                TextFormField(
                                  controller: _passwordTextController,
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    hintText: "Mật khẩu",
                                  ),

                                  validator: (value) {
                                    if (_passwordTextController.text.length <=
                                        0) {
                                      return "Mật khẩu không được để trống";
                                    }
                                    return null;
                                  },
                                ),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(
                                      0, 20.0, 0, 10.0),
                                  child: ElevatedButton(
                                      style: ButtonStyle(
                                        backgroundColor: MaterialStateProperty
                                            .resolveWith<Color>(
                                              (Set<MaterialState> states) {
                                            if (states.contains(
                                                MaterialState.pressed))
                                              return Colors.green;
                                            return Colors
                                                .green; // Use the component's default.
                                          },
                                        ),
                                      ),
                                      onPressed: () async {
                                        if (_loginFormKey.currentState!.validate()) {
                                          String? shouldNavigate = await signIn(
                                              _emailTextController.text,
                                              _passwordTextController.text);
                                          if (shouldNavigate == "Signed In") {
                                            Navigator.of(context).pushNamed(
                                                MAIN_SCREEN);
                                          } else {
                                            _error = shouldNavigate!;
                                            showAlertDialog(context);
                                          }
                                        }
                                      },
                                      child: Text("Đăng nhập", style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),)
                                  ),
                                ),
                                TextButton(
                                    style: TextButton.styleFrom(
                                      primary: Colors.black,
                                      textStyle: TextStyle(
                                        fontSize: 15,
                                        //fontStyle: FontStyle.italic
                                      ),
                                    ),
                                    onPressed: () {
                                      {
                                        Navigator.of(context).pushNamed(
                                            REGISTER_SCREEN);
                                      }
                                    },
                                    child: Text("Chưa có tài khoản?")
                                ),
                              ]
                          )
                      )
                    ],
                  ),
                )
            )
        )
    ),],),),),);
  }

  showAlertDialog(BuildContext context) {

    // set up the buttons
    Widget cancelButton = ElevatedButton(
      child: Text("Cancel"),
      onPressed:  () {Navigator.of(context).pop();},
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      content: Text(_error),
      actions: [
        cancelButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
