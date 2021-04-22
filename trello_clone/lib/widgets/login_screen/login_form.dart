import 'package:flutter/material.dart';
import 'package:trello_clone/route_path.dart';
import 'package:trello_clone/screens/main_screen/main_screen.dart';
import 'package:trello_clone/services/authentication_service.dart';

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
                          hintText: "Mật khẩu",
                        ),

                        validator: (value){
                          if (_passwordTextController.text.length <= 0) {
                            return "Mật khẩu không được để trống";
                          }
                          return null;
                        },
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
                            onPressed: () async {
                              if(_loginFormKey.currentState!.validate()) {
                                bool shouldNavigate =  await signIn(_emailTextController.text, _passwordTextController.text);
                                if (shouldNavigate) {
                                  Navigator.of(context).pushNamed(MAIN_SCREEN);
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
                          onPressed: (){
                            {
                              Navigator.of(context).pushNamed(REGISTER_SCREEN);
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
    );
  }
}
