// @dart=2.12
import 'package:floor/floor.dart';

@entity
class Tag
{
  @primaryKey
  String tagname;

  @primaryKey
  String color;

  @ColumnInfo(name: 'ma bang')
  int boardid;

  Tag(this.tagname, this.color, this.boardid);
}