import 'package:floor/floor.dart';

@entity
class Group
{
  @primaryKey
  int groupid;

  @ColumnInfo(name: 'ten nhom', nullable: false)
  String groupname;

  @ColumnInfo(name: 'mo ta', nullable: true)
  String discribe;

  Group(this.groupid, this.groupname, this.discribe);
}