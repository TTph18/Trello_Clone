import 'package:floor/floor.dart';
import '../entity/checklist.dart';
@dao
abstract class CheckListDao
{
  @Query('SELECT * FROM CHECKLIST')
  Future<List<CheckList>> findAll();

  @Query('SELECT * FROM CHECKLIST WHERE CardID = :id')
  Stream<CheckList> findById(int id);

  @insert
  Future<void> insertCheckList(CheckList checkList);
}