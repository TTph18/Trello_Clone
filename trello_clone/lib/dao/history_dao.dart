import 'package:floor/floor.dart';
import 'package:trello_clone/entity/history.dart';

@dao
abstract class HistoryDao
{
  @Query('SELECT * FROM HISTORY')
  Future<List<History>> findAll();

  @Query('SELECT * FROM HISTORY WHERE ActivityID = :id')
  Stream<History> findById(int id);

  @insert
  Future<void> insertCheckList(History history);
}