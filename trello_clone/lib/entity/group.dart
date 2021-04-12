// @dart=2.12
import 'package:floor/floor.dart';

@entity
class Group
{
  @primaryKey
  int groupid;

  @ColumnInfo(name: 'ten nhom')
  String groupname;

  @ColumnInfo(name: 'mo ta')
  String description;

  Group(this.groupid, this.groupname, this.description);
}