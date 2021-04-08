import 'package:floor/floor.dart';
import '../entity/list.dart';
@dao
abstract class ListDao
{
  @Query('SELECT * FROM CHECKLIST WHERE ListID = :id')
  Stream<List> findById(int id);

  @insert
  Future<void> insertCheckList(List list);
}