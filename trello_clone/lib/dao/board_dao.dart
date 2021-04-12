import 'package:floor/floor.dart';
import '../entity/board.dart';
@dao
abstract class BoardDao
{
  @Query('SELECT * FROM BOARD')
  Future<List<Board>> findAll();

  @Query('SELECT * FROM BOARD WHERE BoardID = :id')
  Stream<Board?> findById(int id);

  @insert
  Future<void> insertBoard(Board board);
}