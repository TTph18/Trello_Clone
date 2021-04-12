// @dart=2.12
import 'package:floor/floor.dart';

@entity
class CheckList
{
  @primaryKey
  int cardid;

  @ColumnInfo(name: 'noi dung')
  String content;

  @ColumnInfo(name: 'trang thai')
  bool state;

  @ColumnInfo(name: 'so thu tu')
  int number;

  CheckList(this.cardid, this.content, this.state, this.number);
}