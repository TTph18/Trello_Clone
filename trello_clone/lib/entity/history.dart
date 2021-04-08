import 'package:floor/floor.dart';

@entity
class History
{
  @primaryKey
  String activityid;

  @ColumnInfo(name: 'tai khoan', nullable: false)
  String account;

  @ColumnInfo(name: 'noi dung', nullable: false)
  String content;

  @ColumnInfo(name: 'thoi gian hoat dong', nullable: false)
  String time;

  History(this.activityid, this.account, this.content, this.time);
}