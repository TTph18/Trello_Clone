import 'package:floor/floor.dart';

@entity
class GroupDetail
{
  @Entity(primaryKeys: ['groupid','account'])
  String groupid;

  String account;

  GroupDetail(this.groupid, this.account);
}