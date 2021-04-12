// @dart=2.12
import 'package:floor/floor.dart';

@entity
class TagDetail
{
  @primaryKey
  int tagid;

  @ColumnInfo(name: 'mau')
  String color;

  TagDetail(this.tagid, this.color);
}