// @dart=2.12
import 'package:floor/floor.dart';

@entity
class History
{
  @primaryKey
  String activityid;

  @ColumnInfo(name: 'tai khoan')
  String account;

  @ColumnInfo(name: 'noi dung')
  String content;

  @ColumnInfo(name: 'thoi gian hoat dong')
  String time;

  History(this.activityid, this.account, this.content, this.time);
}