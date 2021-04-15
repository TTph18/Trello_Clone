import 'package:floor/floor.dart';

@Entity(primaryKeys: ['groupid','account'])
class GroupDetail
{
  int groupid;

  String account;

  GroupDetail(this.groupid, this.account);
}