import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trello_clone/route_path.dart';
import 'package:trello_clone/services/authentication_service.dart';
import 'package:trello_clone/services/validate_service.dart';

class RegisterForm extends StatefulWidget {
  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  var _registerFormKey = GlobalKey<FormState>();
  var _emailTextController = TextEditingController();
  var _userNameTextController = TextEditingController();
  var _profileNameTextController = TextEditingController();
  var _passwordTextController = TextEditingController();
  var _checkpasswordTextController = TextEditingController();
  String _error = "";

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              WillPopScope(
                onWillPop: () async => true,
                child: Form(
                  key: _registerFormKey,
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
                                    decoration: InputDecoration(hintText: "Email"),
                                    validator: (value) {
                                      if (_emailTextController.text.length <= 0) {
                                        return "Email kh??ng ???????c ????? tr???ng";
                                      }
                                      if (validateEmail(_emailTextController.text) == false) {
                                        return "Email kh??ng h????p l????";
                                      }
                                      return null;
                                    },
                                  ),
                                  TextFormField(
                                    controller: _userNameTextController,
                                    decoration: InputDecoration(hintText: "T??n ????ng nh???p"),
                                    validator: (value) {
                                      if (_userNameTextController.text.length <= 0) {
                                        return "T??n ????ng nh???p kh??ng ???????c ????? tr???ng";
                                      }
                                      return null;
                                    },
                                  ),
                                  TextFormField(
                                    controller: _profileNameTextController,
                                    decoration: InputDecoration(hintText: "T??n hi???n th???"),
                                    validator: (value) {
                                      if (_profileNameTextController.text.length <= 0) {
                                        return "T??n hi???n th??? kh??ng ???????c ????? tr???ng";
                                      }
                                      return null;
                                    },
                                  ),
                                  TextFormField(
                                    controller: _passwordTextController,
                                    obscureText: true,
                                    decoration: InputDecoration(hintText: "M???t kh???u"),
                                    validator: (value) {
                                      if (_passwordTextController.text.length <= 0) {
                                        return "M???t kh???u kh??ng ???????c ????? tr???ng";
                                      }
                                    },
                                  ),
                                  TextFormField(
                                    controller: _checkpasswordTextController,
                                    obscureText: true,
                                    decoration: InputDecoration(hintText: "Nh???p l???i m???t kh???u"),
                                    validator: (value) {
                                      if (_passwordTextController.text.length <= 0) {
                                        return "M???t kh???u kh??ng ???????c ????? tr???ng";
                                      }
                                      if (_checkpasswordTextController.text != _passwordTextController.text) {
                                        return "M???t kh???u nh???p kh??ng kh???p";
                                      }
                                      return null;
                                    },
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.fromLTRB(0, 20.0, 0, 10.0),
                                        child: ElevatedButton(
                                          style: ButtonStyle(
                                            backgroundColor: MaterialStateProperty.resolveWith<Color>(
                                              (Set<MaterialState> states) {
                                                if (states.contains(MaterialState.pressed)) return Colors.green;
                                                return Colors.green; // Use the component's default.
                                              },
                                            ),
                                          ),
                                          onPressed: () async {
                                            Navigator.of(context).pushNamed(LOGIN);
                                          },
                                          child: Text(
                                            "Quay l???i",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.fromLTRB(0, 20.0, 0, 10.0),
                                        child: ElevatedButton(
                                          style: ButtonStyle(
                                            backgroundColor: MaterialStateProperty.resolveWith<Color>(
                                              (Set<MaterialState> states) {
                                                if (states.contains(MaterialState.pressed)) return Colors.green;
                                                return Colors.green; // Use the component's default.
                                              },
                                            ),
                                          ),
                                          onPressed: () async {
                                            if (_registerFormKey.currentState!.validate()) {
                                              String? shouldNavigate = await register(_emailTextController.text, _passwordTextController.text,
                                                  _userNameTextController.text, _profileNameTextController.text);

                                              if (shouldNavigate == "Registered") {
                                                Navigator.of(context).pushNamed(LOGIN);
                                              } else {
                                                _error = shouldNavigate!;
                                                showAlertDialog(context);
                                              }
                                            }
                                          },
                                          child: Text(
                                            "X??c nh???n",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = ElevatedButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
      },
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
