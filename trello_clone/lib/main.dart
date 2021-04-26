// @dart=2.11
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:trello_clone/route_generator.dart';
import 'package:trello_clone/screens/login_screen/login_screen.dart';

Future<void> main() async
{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        onGenerateRoute: RouteGenerator.generateRoute,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Scaffold(
            body: LoginScreen()
        )
    );
  }
}

