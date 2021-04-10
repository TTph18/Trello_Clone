import 'package:floor/floor.dart';

@entity
class CheckList
{
  @primaryKey
  int cardid;

  @ColumnInfo(name: 'noi dung', nullable: true)
  String content;

  @ColumnInfo(name: 'trang thai (done = 1)', nullable: false)
  int state;

  @ColumnInfo(name: 'so thu tu', nullable: false)
  int number;

  CheckList(this.cardid, this.content, this.state, this.number);
}