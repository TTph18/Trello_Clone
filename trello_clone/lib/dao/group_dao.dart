import 'package:floor/floor.dart';
import '../entity/group.dart';
@dao
abstract class GroupDao
{
  @Query('SELECT * FROM GROUP')
  Future<List<Group>> findAll();

  @Query('SELECT * FROM CHECKLIST WHERE GroupID = :id')
  Stream<Group?> findById(int id);

  @insert
  Future<void> insertGroup(Group group);
}