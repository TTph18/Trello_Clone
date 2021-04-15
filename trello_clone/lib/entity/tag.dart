import 'package:floor/floor.dart';

@entity
class Tag
{
  @primaryKey
  int tagid;

  String color;

  Tag(this.tagid, this.color);
}