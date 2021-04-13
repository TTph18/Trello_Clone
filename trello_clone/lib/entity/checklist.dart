import 'package:floor/floor.dart';

@entity
class CheckList
{
  @primaryKey
  String cardid;

  @ColumnInfo(name: 'noi dung')
  String content;

  @ColumnInfo(name: 'trang thai (done = 1)')
  int state;

  @ColumnInfo(name: 'so thu tu')
  int number;

  CheckList(this.cardid, this.content, this.number, this.state);
}