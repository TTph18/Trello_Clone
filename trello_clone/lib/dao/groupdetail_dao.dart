import 'package:floor/floor.dart';
import '../entity/groupdetail.dart';
@dao
abstract class GroupDetailDao
{
  @Query('SELECT * FROM CHECKLIST')
  Future<List<GroupDetail>> findAll();

  @Query('SELECT * FROM CHECKLIST WHERE GroupID = :id')
  Stream<GroupDetail> findById(int id);

  @insert
  Future<void> insertGroupDetail(GroupDetail groupDetail);
}