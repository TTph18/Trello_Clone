import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'route_path.dart';
import 'screens/login_screen/login_screen.dart';
import 'screens/register_screen/register_screen.dart';
import 'screens/main_screen/main_screen.dart';
import 'screens/create_board_screen/create_board_screen.dart';
import 'screens/create_card_screen/create_card_screen.dart';

class RouteGenerator{
  static Route<dynamic> generateRoute(RouteSettings settings){
    //var data = settings.arguments;
    switch (settings.name){
      case LOGIN:
        return MaterialPageRoute(
            settings:RouteSettings(name: LOGIN),
            builder:(_) => LoginScreen(),
            maintainState: false
        );
      case MAIN_SCREEN:
        return MaterialPageRoute(
          settings: RouteSettings(name: MAIN_SCREEN),
          builder: (_) => MainScreen(),
        );
      case REGISTER_SCREEN:
        return MaterialPageRoute(
          settings: RouteSettings(name: REGISTER_SCREEN),
          builder: (_) => RegisterScreen(),
          maintainState: false
        );
      case CREATE_BOARD_SCREEN:
        return MaterialPageRoute(
            settings: RouteSettings(name: CREATE_BOARD_SCREEN),
            builder: (_) => CreateBoardScreen(),
            maintainState: false
        );
      case CREATE_CARD_SCREEN:
        return MaterialPageRoute(
            settings: RouteSettings(name: CREATE_CARD_SCREEN),
            builder: (_) => CreateCardScreen(),
            maintainState: false
        );
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder: (_) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Error'),
          ),
          body: Center(
            child: Text('ERROR'),
          ),
        );
      },
    );
  }
}