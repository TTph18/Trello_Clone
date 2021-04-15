import 'package:floor/floor.dart';

@entity
class History
{
  @primaryKey
  int activityid;

  //@ColumnInfo(name: 'tai khoan')
  String account;

  //@ColumnInfo(name: 'noi dung')
  String content;

  //@ColumnInfo(name: 'thoi gian hoat dong')
  //DateTime time;

  History(this.activityid, this.account, this.content);
}