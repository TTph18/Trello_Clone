import 'package:floor/floor.dart';

@entity
class GroupDetail
{
  @primaryKey
  int groupid;

  @ColumnInfo(name: 'mat khau', nullable: false)
  String creator;

  @ColumnInfo(name: 'ma bang', nullable: false)
  int boardid;

  GroupDetail(this.groupid, this.creator, int boardid);
}