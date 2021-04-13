// @dart=2.12
import 'package:floor/floor.dart';

@entity
class Board
{
  @primaryKey
  String boardid;

  @ColumnInfo(name: 'ten bang')
  String boardname;

  @ColumnInfo(name: 'mo ta')
  String discribe;

  @ColumnInfo(name: 'tai khoan cua nguoi tao bang')
  String creator;

  @ColumnInfo(name: 'ma nhom')
  String groupid;

  Board(this.boardid, this.boardname, this.discribe, this.creator, this.groupid);
}