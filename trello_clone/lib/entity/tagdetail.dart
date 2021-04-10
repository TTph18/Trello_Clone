import 'package:floor/floor.dart';

@entity
class TagDetail
{
  @primaryKey
  int tagid;

  @ColumnInfo(name: 'mau', nullable: false)
  String color;

  TagDetail(this.tagid, this.color);
}