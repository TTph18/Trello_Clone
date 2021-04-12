// @dart=2.12
import 'package:floor/floor.dart';

@entity
class GroupDetail
{
  @primaryKey
  int groupid;

  @ColumnInfo(name: 'mat khau')
  String creator;

  @ColumnInfo(name: 'ma bang')
  int boardid;

  GroupDetail(this.groupid, this.creator, this.boardid);
}