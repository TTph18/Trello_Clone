import 'package:flutter/material.dart';
import 'package:trello_clone/route_generator.dart';
import 'package:trello_clone/screens/login_screen/login_screen.dart';
import 'database.dart';
import 'entity/user.dart';

Future<void> main() async
{
  WidgetsFlutterBinding.ensureInitialized();
  final database = await $FloorAppDatabase.databaseBuilder('trelloclone.db').build();
  final userDao = database.userDao;
  //final user1 = User("18520402@gm.uit.edu.vn", "123456","vy");
  //final user2 = User('18520256@gm.uit.edu.vn', '123456','chau');
  //final user3 = User('18520260@gm.uit.edu.vn', '123456','cuc');
  //final user4 = User('18521279@gm.uit.edu.vn', '123456','phuong');
  //await userDao.insertUser(user1);
  //await userDao.insertUser(user2);
  //await userDao.insertUser(user3);
  //await userDao.insertUser(user4);
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

