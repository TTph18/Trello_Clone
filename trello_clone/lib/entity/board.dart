import 'package:floor/floor.dart';

@entity
class Board
{
  @primaryKey
  int boardid;

  @ColumnInfo(name: 'ten bang', nullable: false)
  String boardname;

  @ColumnInfo(name: 'mo ta', nullable: false)
  String discribe;

  @ColumnInfo(name: 'tai khoan cua nguoi tao bang', nullable: false)
  String creator;

  Board(this.boardid, this.boardname, this.discribe, this.creator);
}