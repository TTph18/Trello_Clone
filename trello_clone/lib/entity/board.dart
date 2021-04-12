// @dart=2.12
import 'package:floor/floor.dart';

@entity
class Board
{
  @primaryKey
  int boardid;

  @ColumnInfo(name: 'ten bang')
  String boardname;

  @ColumnInfo(name: 'mo ta')
  String discribe;

  @ColumnInfo(name: 'nguoi tao')
  String creator;

  Board(this.boardid, this.boardname, this.discribe, this.creator);
}