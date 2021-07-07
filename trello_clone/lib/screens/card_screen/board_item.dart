import 'package:trello_clone/models/boards.dart';

class BoardItem {
  Boards boards;
  String wpname;
  String type;

  BoardItem({required this.wpname, required this.type, required this.boards});
}