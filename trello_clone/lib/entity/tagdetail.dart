import 'package:floor/floor.dart';

@entity
class TagDetail
{
  @primaryKey
  int tagid;

  //@ColumnInfo(name: 'mau')
  String color;

  //@ColumnInfo(name: 'noi dung')
  String content;
  TagDetail(this.tagid, this.color, this.content);
}