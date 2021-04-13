import 'package:floor/floor.dart';

@entity
class Group
{
  @primaryKey
  String groupid;

  @ColumnInfo(name: 'ten nhom')
  String groupname;

  @ColumnInfo(name: 'mo ta')
  String discribe;

  Group(this.groupid, this.groupname, this.discribe);
}