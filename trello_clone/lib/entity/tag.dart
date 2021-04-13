import 'package:floor/floor.dart';

@entity
class Tag
{
  @primaryKey
  String tagid;

  String color;

  Tag(this.tagid, this.color);
}